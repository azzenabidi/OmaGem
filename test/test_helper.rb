# frozen_string_literal: true

require 'minitest/autorun'
require 'omagem'

class FakeClient < OmaGem::Client::Fake
end

module OmaGemTestHelpers
  # Build a config backed by a recording fake client and run the block.
  def dsl(&block)
    client = FakeClient.new
    config = OmaGem::Config.new(client: client)
    config.instance_eval(&block)
    config
  end
end
