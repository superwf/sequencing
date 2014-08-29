#! /usr/bin/env php
<?php
# $argv[1] is password, $argv[2] is salt
if($argv[1] && $argv[2]) {
  echo crypt($argv[1], $argv[2]) == $argv[2];
}
