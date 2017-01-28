module Fastlane
  module Actions
    class InstallAndroidAction < Action
      def self.run(params)
        UI.message("The install_android plugin is working!")

        # TOOD: Prompt for update

        has_java = Helper::InstallAndroidHelper.is_installed?("java")
        has_javac = Helper::InstallAndroidHelper.is_installed?("javac")

        has_ant = Helper::InstallAndroidHelper.is_installed?("ant")
        has_maven = Helper::InstallAndroidHelper.is_installed?("mvn")
        has_android = Helper::InstallAndroidHelper.is_installed?("android")
        
        has_brew = Helper::InstallAndroidHelper.is_installed?("brew")
        
        missing_dependency = !has_java || !has_javac ||
           !has_ant || !has_maven || !has_android 
        
        if !missing_dependency
          UI.message "All Android dependencies are installed"
        elsif missing_dependency && !has_brew
          UI.user_error! "Please install homebrew from http://brew.sh/"
        end
        
        Helper::InstallAndroidHelper.install_via_brew_cask "java"
        
        Helper::InstallAndroidHelper.install_via_brew "ant"
        Helper::InstallAndroidHelper.install_via_brew "maven"
        Helper::InstallAndroidHelper.install_via_brew "android"
        
        UI.message "All Android dependencies have been installed"
        Helper::InstallAndroidHelper.inform_android_home
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "A short description with <= 80 characters of what this action does"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        
      end

      def self.output
      end

      def self.return_value
        # If you method provides a return value, you can describe here what it does
      end

      def self.authors
        ["joshdholtz"]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
