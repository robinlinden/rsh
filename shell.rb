#!/usr/bin/env ruby

require "readline"

def main
    loop do
        cmd = Readline.readline("> ", true) 
        p cmd
    end
end

main

