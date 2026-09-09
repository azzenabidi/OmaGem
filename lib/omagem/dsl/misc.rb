# frozen_string_literal: true

module OmaGem
  module DSL
    # Misc: reminders, screen capture, launch app, focus app, default agent.
    module Misc
      # Full-screen screenshot saved to disk.
      def screenshot
        run('capture', 'screenshot', 'fullscreen', 'save')
      end

      def screenrecord(fullscreen: false, desktop_audio: false, microphone: false, webcam: false)
        args = %w[capture screenrecording]
        args << '--fullscreen' if fullscreen
        args << '--with-desktop-audio' if desktop_audio
        args << '--with-microphone-audio' if microphone
        args << '--with-webcam' if webcam
        run(*args)
      end

      def stop_screenrecord
        run('capture', 'screenrecording', '--stop-recording')
      end

      # Set a desktop notification reminder; minutes accepts decimals.
      def reminder(minutes, message)
        run('reminder', minutes.to_s, message)
      end

      def focus_app(name)
        run('hyprland', 'focus', 'app', name)
      end
    end
  end
end
