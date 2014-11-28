#! /usr/bin/env php
<?php
error_reporting(E_ERROR);
# $argv[1] is password, $argv[2] is salt
$n = sizeof($argv);
if($n == 3) {
  echo crypt($argv[1], $argv[2]) == $argv[2];
}
if($n == 2) {
  echo crypt($argv[1]);
}
