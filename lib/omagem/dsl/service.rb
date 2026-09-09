# frozen_string_literal: true

require_relative '../errors'

module OmaGem
  module DSL
    # Install/manage optional software, services, apps, browsers, editors,
    # terminals, development environments, and gaming.
    module Service
      # Install a supported standalone app, e.g. install_app("ChatGPT")
      # wraps `omarchy install <display-name> <packages>`.
      def install_app(display_name, packages)
        run('install', 'app', display_name, packages)
      end

      # -- Optional software installers ------------------------------------

      def install_browser(name)
        validate_in!(name, %w[chrome brave brave-origin edge firefox zen], 'browser')
        run('install', 'browser', name)
      end

      def install_editor(name)
        validate_in!(name, %w[emacs helix vscode zed], 'editor')
        run('install', 'editor', name)
      end

      def install_terminal(name)
        validate_in!(name, %w[alacritty foot ghostty kitty], 'terminal')
        run('install', 'terminal', name)
      end

      # -- Services ---------------------------------------------------------

      SERVICES = %w[1password dropbox nordvpn once signal spotify sunshine tailscale].freeze

      # Install and start a supported service (or bundle downloads a full version).
      def install_service(name)
        validate_in!(name, SERVICES, 'service')
        run('install', 'service', name)
      end

      def remove_service(name)
        validate_in!(name, SERVICES, 'service')
        run('remove', 'service', name)
      end

      # -- Development environments (install dev-env <ruby|node|...>) ------

      def install_dev_env(env)
        allowed = %w[ruby node bun deno go laravel symfony php python elixir phoenix rust java zig ocaml dotnet clojure
                     scala]
        validate_in!(env, allowed, 'dev env')
        run('install', 'dev-env', env)
      end

      # -- Gaming -----------------------------------------------------------

      def install_game(platform)
        allowed = %w[steam heroic lutris retroarch battlenet geforce-now xbox-cloud xbox-controllers gpu-lib32]
        validate_in!(platform, allowed, 'gaming platform')
        run('install', 'gaming', platform)
      end
    end
  end
end
