# frozen_string_literal: true

require_relative 'omagem/version'
require_relative 'omagem/errors'
require_relative 'omagem/client'
require_relative 'omagem/config'

# OmaGem is a Ruby DSL for configuring and managing Omarchy Linux systems.
#
#   require "omagem"
#
#   OmaGem.run do
#     theme "catppuccin"
#     add_packages "docker", "git"
#     install_service "tailscale"
#     nightlight :on
#   end
#
# The block is evaluated against an OmaGem::Config, which exposes every
# DSL method. See OmaGem::Config for the full list.
module OmaGem
  class << self
    # Execute a DSL block against a fresh OmaGem::Config. Returns the config
    # so the caller can inspect what ran via config.executed / config.client.
    #
    #   config = OmaGem.run { theme "catppuccin" }
    def run(client: OmaGem::Client.new, ignore_errors: false, &block)
      config = Config.new(client: client, ignore_errors: ignore_errors)
      config.instance_eval(&block) if block
      config
    end
  end
end
