module Fastlane
  module Helper
    class InstallAndroidHelper
      def self.is_installed?(command)
        is_installed = Fastlane::Actions.sh("which #{command}")
        !!is_installed
      end
      
      def self.install_via_brew(formula)
        if UI.confirm("Install `#{formula}` via brew?")
          Fastlane::Actions.sh "brew upgrade #{formula} || brew install #{formula}"
        end
      end
      
      def self.install_via_brew_cask(formula)
        if UI.confirm("Install `#{formulas}` via brew cask?")
          Fastlane::Actions.sh "brew update || brew cask install #{formula}"
        end
      end
      
      # Informs user that they need to put stuff in things
      def self.inform_android_home
        UI.important "Please set the following in your .bashrc:" 
        UI.important "\texport ANDROID_HOME=/usr/local/opt/android-sdk"
        UI.important "\texport PATH=$PATH:/usr/local/opt/android-sdk/tools:/usr/local/opt/android-sdk/platform-tools"
      end
      
      def self.list_sdks
        sdks = Fastlane::Actions.sh("android list sdk --all", log: false)
        sdks = sdks.split("\n")
        sdks = sdks.map do |line|
          line.strip
        end
        sdks = sdks.select do |line|
          line =~ /^\d*/
        end
      end
    end
  end
end
