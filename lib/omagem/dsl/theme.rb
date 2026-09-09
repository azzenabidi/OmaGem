# frozen_string_literal: true

require_relative '../errors'

module OmaGem
  module DSL
    # Theme management: apply, list, install, remove, refresh, backgrounds.
    module Theme
      # Apply a theme by name. `"Tokyo Night"` and `"tokyo-night"` both work.
      def theme(name)
        run('theme', 'set', name)
      end
      alias apply_theme theme

      # List themes Omarchy knows about.
      def themes
        run('theme', 'list').stdout.lines.map(&:strip).reject(&:empty?)
      end

      # Install a theme from a git repository URL.
      def install_theme(url)
        run('theme', 'install', url)
      end

      # Remove a user-installed theme by name.
      def remove_theme(name)
        run('theme', 'remove', name)
      end

      # Re-apply the current theme from its templates.
      def refresh_theme
        run('theme', 'refresh')
      end

      # Update user-installed git themes.
      def update_themes
        run('theme', 'update')
      end

      # -- Backgrounds ------------------------------------------------------

      # Set the desktop background to the given image path.
      def background(path)
        run('theme', 'bg', 'set', path)
      end
      alias set_background background

      # Cycle to the next background for the current theme.
      def background_next
        run('theme', 'bg', 'next')
      end

      # Open the background switcher.
      def background_switcher
        run('theme', 'bg-switcher')
      end
    end
  end
end
