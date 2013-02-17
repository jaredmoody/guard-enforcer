#!/usr/bin/env ruby

#
# Enforcer.rb
#
# This is a git pre-commit script that prevents committing if any guard listed in .guardrun
# has a runtime that is previous to the last modified file
#

require 'time'
require 'yaml'

if File.exists?(".guardrun")

  # load the last guard run times
  times = YAML.load_file(".guardrun")

  # get the last modified file that is to be committed
  files_changed = `git diff --name-only HEAD`
  last_modified = Time.at(0)
  last_modified_file = nil

  files_changed.each_line do |filename|
    filename.chomp!
    # don't consider this file in modified times or deleted files
    next if filename == ".guardrun" || !File.exists?(filename)
    mtime = File.mtime(filename)
    last_modified = mtime if mtime > last_modified
    last_modified_file = filename
  end

  # check all the times against the most recently modified file
  if !times
    $stderr.puts "Guard needs to be run, aborting commit"
     exit 1
  else
    times.each do |guard,time|
      if time < last_modified
        $stderr.puts "#{guard} needs to be run, aborting commit"
        $stderr.puts "Last run: #{time}, #{last_modified_file} modified at #{last_modified}"
        exit 1
      end
    end
  end
  # if everything is up to date, proceed
  exit 0

else
   $stderr.puts "Could not find last test run file, aborting commit."
   exit 1
end