# frozen_string_literal: true

module Omarchy
  module DSL
    # Shell plugin and bar-widget management.
    module Plugin
      # Add a shell plugin from a git URL. enable: true enables it immediately.
      def add_plugin(url, enable: false)
        args = ['plugin', 'add', url]
        args << '--enable' if enable
        args << '--yes'
        run(*args)
      end

      # Clone a built-in plugin into the user config (switch to user copy).
      def clone_plugin(id)
        run('plugin', 'clone', id)
      end

      def enable_plugin(id, placement = nil)
        args = ['plugin', 'enable', id]
        args << placement if placement
        run(*args)
      end

      def disable_plugin(id)
        run('plugin', 'disable', id)
      end

      def remove_plugin(id)
        run('plugin', 'remove', id, '--yes')
      end

      def list_plugins(json: false)
        args = %w[plugin list]
        args << '--json' if json
        out = run(*args).stdout
        json ? out : out.lines.map(&:strip).reject(&:empty?)
      end
    end
  end
end
