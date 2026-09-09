# frozen_string_literal: true

require 'open3'

module Omarchy
  # Wraps the `omarchy` CLI. It shells out to the single `omarchy` binary and
  # exposes the resulting output, whether the command succeeded, and the exit
  # status. Errors raised by the command are captured rather than thrown.
  #
  # The class is designed to be subclassed or stubbed in tests (see
  # Omarchy::Client::Fake) so the DSL can be exercised without a live system.
  class Client
    Result = Struct.new(:success, :stdout, :stderr, :status, keyword_init: true) do
      def success?
        success
      end

      def output
        stdout
      end
    end

    def initialize(command: 'omarchy')
      @command = command
    end

    # Run an `omarchy` command as in: client.run("theme", "set", "catppuccin")
    def run(*args)
      cmd = [@command, *args.map(&:to_s)]
      stdout, stderr, status = Open3.capture3(*cmd)
      Result.new(
        success: status.success?,
        stdout: stdout.to_s.strip,
        stderr: stderr.to_s.strip,
        status: status.exitstatus
      )
    end

    # A no-op client that records every call instead of running anything.
    # Useful for tests and for "dry run" configuration building.
    class Fake < Client
      attr_reader :calls

      def initialize
        super(command: 'omarchy')
        @calls = []
      end

      def run(*args)
        @calls << args
        Result.new(success: true, stdout: '', stderr: '', status: 0)
      end
    end
  end
end
