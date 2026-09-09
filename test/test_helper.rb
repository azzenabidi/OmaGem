# frozen_string_literal: true

require 'minitest/autorun'
require 'omarchy'

class FakeClient < Omarchy::Client::Fake
end

module OmarchyTestHelpers
  # Build a config backed by a recording fake client and run the block.
  def dsl(&block)
    client = FakeClient.new
    config = Omarchy::Config.new(client: client)
    config.instance_eval(&block)
    config
  end
end
