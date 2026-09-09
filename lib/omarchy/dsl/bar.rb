# frozen_string_literal: true

module Omarchy
  module DSL
    # The status bar: which bar and widget layout is used, plus widget layout.
    module Bar
      POSITIONS = %w[top bottom left right].freeze

      # Switch to a bar layout by id, or `:defaults`/`:reset`.
      def bar(id)
        run('bar', 'use', id)
      end

      def bar_position(pos)
        validate_in!(pos, POSITIONS, 'bar position')
        run('bar', 'position', pos)
      end

      def bar_transparent(value = :toggle)
        run('bar', 'transparent', value.to_s)
      end

      # Put a widget somewhere; placement e.g. ["--after", "omarchy.clock"].
      def bar_put(id, placement = [])
        run('bar', 'put', id, *placement)
      end

      # Move a widget; placement e.g. ["--section", "center", "--index", "0"].
      def bar_move(id, placement = [])
        run('bar', 'move', id, *placement)
      end

      # Set a widget key/value; e.g. bar_set("omarchy.clock", "format", "HH:mm").
      def bar_set(id, key, value)
        run('bar', 'set', id, key, value)
      end
    end
  end
end
