# frozen_string_literal: true

module Omarchy
  module DSL
    # System-level operations: updates, reboot/shutdown/lock, default apps,
    # font, snapshots, and diagnostics.
    module System
      # Perform a full system + Omarchy update. Pass yes: true to skip prompts.
      def update(yes: false)
        args = ['update']
        args << '-y' if yes
        run(*args)
      end

      def version(channel: false)
        args = ['version']
        args << 'channel' if channel
        run(*args).stdout
      end

      def reboot
        run('system', 'reboot')
      end

      def shutdown
        run('system', 'shutdown')
      end

      def lock
        run('system', 'lock')
      end

      def logout
        run('system', 'logout')
      end

      def channel(name = nil)
        return run('channel', 'current').stdout if name.nil?

        validate_in!(name, %w[stable rc edge dev], 'channel')
        run('channel', 'set', name)
      end

      # Set the default terminal used by xdg-terminal-exec.
      def default_terminal(name)
        validate_in!(name, %w[alacritty foot ghostty kitty], 'terminal')
        run('default', 'terminal', name)
      end

      def default_browser(name)
        validate_in!(name, %w[chromium chrome brave brave-origin edge firefox zen], 'browser')
        run('default', 'browser', name)
      end

      def default_editor(name)
        validate_in!(name, %w[code cursor zed sublime_text helix vim emacs nvim], 'editor')
        run('default', 'editor', name)
      end

      # Set the system monospace font.
      def font(name)
        run('font', 'set', name)
      end

      def current_font
        run('font', 'current').stdout
      end

      def debug
        run('debug', '--no-sudo', '--print').stdout
      end
    end
  end
end
