module Fastlane
  module Helper
    class InstallAndroidHelper
      def self.sh(command)
        Fastlane::Actions.sh command
      end
      
      def self.is_installed?(command)
        is_installed = sh "which #{command}" rescue false
        !!is_installed
      end
      
      def self.install_via_brew(formual)
        if UI.confirm("Install `formula` via brew?")
          sh "brew upgrade #{formual} || brew install #{formual}"
        end
      end
      
      def self.install_via_brew_cask(formual)
        if UI.confirm("Install `formula` via brew cask?")
          sh "brew update || brew cask install #{formual}"
        end
      end
      
      # Informs user that they need to put stuff in things
      def self.inform_android_home
        UI.important "Please set the following in your .bashrc:" 
        UI.important "\texport ANDROID_HOME=/usr/local/opt/android-sdk"
        UI.important "\texport PATH=$PATH:/usr/local/opt/android-sdk/tools:/usr/local/opt/android-sdk/platform-tools"
      end
    end
  end
end
