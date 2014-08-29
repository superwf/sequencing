# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# run once first
puts "start server"
system "go run main.go router.go &"

guard 'livereload', grace_period: 2 do
  watch(%r{.+\.(go)$}) do |f|
    s = `lsof -i tcp:8080 | grep ^server`
    puts s
    server_pid = s.scan(/\d+/)[0]
    puts server_pid
    if server_pid
      kill_pid = "kill #{server_pid}"
      puts kill_pid
      system kill_pid
    end
    puts "rerun server"
    system "go run main.go router.go &"
    f
  end
end
