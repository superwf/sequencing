# /bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
GOPATH=/home/wangfan/golang
DAEMON=$PWD/sequencing
GOENV=production
NAME=sequencing
USER=wangfan
DESC="sequencing program"
PID=$PWD/tmp/sequencing.pid

. /lib/init/vars.sh
. /lib/lsb/init-functions

build()
{
  go build main.go && mv main $NAME
  test -x $DAEMON || exit 0
}
do_start()
{
	# Return
	#   0 if daemon has been started
	#   1 if daemon was already running
	#   2 if daemon could not be started
  #echo "start-stop-daemon --start --quiet --pidfile $PID --exec $DAEMON --test "
  build
	start-stop-daemon -c $USER --start --quiet --pidfile $PID --exec $DAEMON --test > /dev/null \
		|| return 1
	start-stop-daemon -c $USER --start --quiet --pidfile $PID --exec $DAEMON --make-pidfile \
		2>/dev/null \
		|| return 2
}
do_stop()
{
	# Return
	#   0 if daemon has been stopped
	#   1 if daemon was already stopped
	#   2 if daemon could not be stopped
	#   other if a failure occurred
	start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --pidfile $PID --name $NAME
	RETVAL="$?"
	sleep 1
	return "$RETVAL"
}

case "$1" in
	start)
		[ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
		do_start &
		case "$?" in
			0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
			2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
		esac
		;;
	stop)
		[ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME"
		do_stop
		case "$?" in
			0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
			2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
		esac
		;;
	restart)
		log_daemon_msg "Restarting $DESC" "$NAME"
		do_stop
		case "$?" in
			0|1)
				do_start &
				case "$?" in
					0) log_end_msg 0 ;;
					1) log_end_msg 1 ;; # Old process is still running
					*) log_end_msg 1 ;; # Failed to start
				esac
				;;
			*)
				# Failed to stop
				log_end_msg 1
				;;
		esac
		;;
	status)
		status_of_proc -p $PID "$DAEMON" "$NAME" && exit 0 || exit $?
		;;
	*)
		echo "Usage: $NAME {start|stop|restart|status}" >&2
		exit 3
		;;
esac
