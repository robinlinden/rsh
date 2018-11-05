#!/usr/bin/env ruby

require "parslet"
require "readline"

def main
    loop do
        cmdline = Readline.readline("> ", true)
        p cmdline
        parse_tree = parse_cmd(cmdline)
        p parse_tree
    end
end

def parse_cmd(cmdline)
    Parser.new.parse(cmdline)
end

class Parser < Parslet::Parser
    root :cmdline

    rule(:cmdline) { command }
    rule(:command) { argument.as(:argument).repeat(1).as(:command) }
    rule(:argument) { match["^\s"].repeat(1) >> space? }

    rule(:space) { match["\s"].repeat(1).ignore }
    rule(:space?) { space.maybe }
end

main

