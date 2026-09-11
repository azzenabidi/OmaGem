# frozen_string_literal: true

require 'json'

module OmaGem
  module DSL
    # Track and update software installed from git: user themes cloned from a
    # repository and shell plugins added from a git URL.
    module Git
      # True when the URL names a repository git can clone.
      def valid_git_url?(url)
        client.run('git', 'url', 'check', url).success?
      end

      # Names of the user-installed themes that came from a git clone.
      def git_themes
        paths = client.run('theme', 'extras').stdout.lines.map(&:strip).reject(&:empty?)
        paths.map { |path| File.basename(path) }
      end

      # IDs of the installed third-party shell plugins (those added from git).
      def git_plugins
        JSON.parse(client.run('plugin', 'list', '--json').stdout)
            .select { |plugin| plugin['firstParty'] == false }
            .map { |plugin| plugin['id'] }
      end

      # Update every theme and plugin installed from git. yes: true (default)
      # skips the confirmation prompt, as scripts cannot answer it.
      def update_git_installs(yes: true)
        run('theme', 'update')
        args = %w[plugin update]
        args << '--yes' if yes
        run(*args)
      end
    end
  end
end
