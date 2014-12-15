#! /usr/bin/env ruby
require 'bcrypt'
if $*.size == 2
  if BCrypt::Password.new($*[1]) == $*[0]
    print 1
  end
elsif $*.size == 1
  print BCrypt::Password.create $*[0]
end
