# frozen_string_literal: true

module Omarchy
  # Base class for all Omarchy::DSL errors.
  class Error < StandardError; end

  # Raised when the `omarchy` CLI is not available on the system.
  class CommandNotFound < Error; end

  # Raised (unless swallowed with `ignore_errors: true`) when an `omarchy`
  # command exits with a non-zero status.
  class CommandFailed < Error
    attr_reader :args, :result

    def initialize(args, result)
      @args = args
      @result = result
      super("omarchy #{args.join(' ')} failed (exit #{result.status}): #{result.stderr}")
    end
  end

  # Raised when a DSL value is outside the set of values Omarchy accepts.
  class ArgumentError < Error; end
end
