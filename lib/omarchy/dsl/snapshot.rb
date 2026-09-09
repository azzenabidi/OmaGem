# frozen_string_literal: true

module Omarchy
  module DSL
    # System snapshots via snapper.
    module Snapshot
      def create_snapshot
        run('snapshot', 'create')
      end

      def restore_snapshot
        run('snapshot', 'restore')
      end
    end
  end
end
