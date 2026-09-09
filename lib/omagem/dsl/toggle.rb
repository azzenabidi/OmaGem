# frozen_string_literal: true

module OmaGem
  module DSL
    # Toggle Omarchy features on/off: nightlight, touchpad, Bluetooth, etc.
    module Toggle
      # Toggle a named feature: toggle("nightlight") or
      # toggle("nightlight", :on | :off | :toggle).
      def toggle(name, state = :toggle)
        run('toggle', name, state.to_s)
      end

      def nightlight(state = :toggle)
        run('toggle', 'nightlight', state.to_s)
      end

      def touchpad(state = :toggle)
        run('toggle', 'touchpad', state.to_s)
      end

      def touchscreen(state = :toggle)
        run('toggle', 'touchscreen', state.to_s)
      end

      def idle(state = :toggle)
        run('toggle', 'idle', state.to_s)
      end

      def bar_visible(state = :toggle)
        run('toggle', 'bar', state.to_s)
      end

      def notification_silencing
        run('toggle', 'notification silencing')
      end
    end
  end
end
