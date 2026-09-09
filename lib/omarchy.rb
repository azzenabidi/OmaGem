# frozen_string_literal: true

require_relative 'omarchy/version'
require_relative 'omarchy/errors'
require_relative 'omarchy/client'
require_relative 'omarchy/config'

# Omarchy is a Ruby DSL for configuring and managing Omarchy Linux systems.
#
#   require "omarchy"
#
#   Omarchy.run do
#     theme "catppuccin"
#     add_packages "docker", "git"
#     install_service "tailscale"
#     nightlight :on
#   end
#
# The block is evaluated against an Omarchy::Config, which exposes every
# DSL method. See Omarchy::Config for the full list.
module Omarchy
  class << self
    # Execute a DSL block against a fresh Omarchy::Config. Returns the config
    # so the caller can inspect what ran via config.executed / config.client.
    #
    #   config = Omarchy.run { theme "catppuccin" }
    def run(client: Omarchy::Client.new, ignore_errors: false, &block)
      config = Config.new(client: client, ignore_errors: ignore_errors)
      config.instance_eval(&block) if block
      config
    end
  end
end
