# frozen_string_literal: true

require_relative 'client'
require_relative 'errors'

module OmaGem
  # The DSL surface. A Config instance exposes all the management methods
  # (theme, package, service, system, ...). The methods are defined in
  # feature modules mixed in below, so the DSL is easy to extend and keep
  # organized.
  #
  # To build a reusable configuration without executing anything, pass a
  # fake (recording) client to Config.new.
  class Config
    attr_reader :client

    def initialize(client: OmaGem::Client.new, ignore_errors: false)
      @client = client
      @ignore_errors = ignore_errors
      @executed = []
    end

    # Every command that ran through #run, in order. Each entry is the
    # argument array.
    attr_reader :executed

    # Run an Omarchy command and return the OmaGem::Client::Result.
    # Records the call and validates the exit status unless ignore_errors.
    def run(*args)
      @executed << args
      result = client.run(*args)
      raise CommandFailed.new(args, result) unless result.success?

      result
    end

    # Raise CommandNotFound if the underlying `omarchy` binary cannot be run.
    def ensure_command!
      # A lightweight availability check: run "omarchy version".
      run('version')
    rescue Errno::ENOENT
      raise CommandNotFound, 'the `omarchy` CLI could not be found on PATH'
    end

    # -- Helpers shared by the feature DSL ---------------------------------

    # True when at least one of the named packages is installed.
    def package_present?(*names)
      client.run('pkg', 'present', *names).success?
    end

    # True when every named package is installed.
    def package_installed?(*names)
      !client.run('pkg', 'missing', *names).success?
    end

    # Current theme name (from `omarchy theme current`).
    def current_theme
      client.run('theme', 'current').stdout
    end

    def valid_theme?(name)
      available_themes.include?(name)
    end

    def available_themes
      client.run('theme', 'list').stdout.lines.map(&:strip).reject(&:empty?)
    end

    # Raise OmaGem::ArgumentError unless value is in the allowed list.
    def validate_in!(value, allowed, label)
      return if allowed.include?(value.to_s)

      raise ArgumentError, "unknown #{label} #{value.inspect}; expected one of: #{allowed.join(', ')}"
    end
  end
end

require_relative 'dsl/theme'
require_relative 'dsl/package'
require_relative 'dsl/service'
require_relative 'dsl/system'
require_relative 'dsl/bar'
require_relative 'dsl/plugin'
require_relative 'dsl/toggle'
require_relative 'dsl/snapshot'
require_relative 'dsl/misc'

OmaGem::Config.include(OmaGem::DSL::Theme)
OmaGem::Config.include(OmaGem::DSL::Package)
OmaGem::Config.include(OmaGem::DSL::Service)
OmaGem::Config.include(OmaGem::DSL::System)
OmaGem::Config.include(OmaGem::DSL::Bar)
OmaGem::Config.include(OmaGem::DSL::Plugin)
OmaGem::Config.include(OmaGem::DSL::Toggle)
OmaGem::Config.include(OmaGem::DSL::Snapshot)
OmaGem::Config.include(OmaGem::DSL::Misc)
