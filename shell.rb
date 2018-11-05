#!/usr/bin/env ruby

require "parslet"
require "readline"

def main
    loop do
        cmdline = Readline.readline("> ", true)
        tree = parse_cmd(cmdline)
        pid = tree.execute
        Process.wait(pid)
    end
end

def parse_cmd(cmdline)
    tree = Parser.new.parse(cmdline)
    Transform.new.apply(tree)
end

class Parser < Parslet::Parser
    root :cmdline

    rule(:cmdline) { command }
    rule(:command) { argument.as(:argument).repeat(1).as(:command) }
    rule(:argument) { match["^\s"].repeat(1) >> space? }

    rule(:space) { match["\s"].repeat(1).ignore }
    rule(:space?) { space.maybe }
end

class Transform < Parslet::Transform
    rule(command: sequence(:arguments)) { Command.new(arguments) }
    rule(argument: simple(:argument)) { argument }
end

class Command
    def initialize(args)
        @args = args
    end

    def execute
        spawn(*@args)
    end
end

main

