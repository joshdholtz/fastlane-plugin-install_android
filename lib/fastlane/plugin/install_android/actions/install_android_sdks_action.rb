module Fastlane
  module Actions
    class InstallAndroidSdksAction < Action
      def self.run(params)
        
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        # UI.message "Parameter API Token: #{params[:api_token]}"

        # sh "shellcommand ./path"
        
        # 1- Android SDK Tools, revision 25.2.5
        # 2- Android SDK Platform-tools, revision 25.0.3
        # 3- Android SDK Build-tools, revision 25.0.2
        # 5- Android SDK Build-tools, revision 25
        # 13- Android SDK Build-tools, revision 23 (Obsolete)
        # 32- Documentation for Android SDK, API 24, revision 1
        # 33- SDK Platform Android 7.1.1, API 25, revision 3
        # 34- SDK Platform Android 7.0, API 24, revision 2
        # 129- Google APIs Intel x86 Atom System Image, Android API 10, revision 5
        # 130- Google APIs, Android API 24, revision 1
        # 135- Glass Development Kit Preview, Android API 19, revision 11
        
        has_android = Helper::InstallAndroidHelper.is_installed?("android")
        unless has_android
          Helper::InstallAndroidHelper.inform_android_home
          UI.user_error! "Please make sure the `android` command is available via command line"
        end
        
        filter_in = (params[:filter_in] || [])
        filter_out = (params[:filter_out] || [])
        
        auto_install_if_only_result = false
        find = params[:find]
        if find.to_s.size > 0
          filter_in << find
          auto_install_if_only_result = true
        end
        
        unless params[:show_obsolete]
          filter_out << "obsolete"
        end
        
        filter_in = filter_in.map{ |s| s.downcase }
        filter_out = filter_out.map{ |s| s.downcase }
        
        Bundler.with_clean_env do
          sdks = Helper::InstallAndroidHelper.list_sdks
          sdks = sdks.select do |line|
            line = line.downcase
            filter_in.any? { |word| line.include?(word) }
          end unless filter_in.empty?
          sdks = sdks.select do |line|
            line = line.downcase
            !filter_out.any? { |word| line.include?(word) }
          end unless filter_out.empty?
          sdks = sdks.map do |line|
            line_parts = line.split("-")
            number = line_parts.shift
            name = line_parts.join("").strip
            {number: number, name: name}
          end
          
          questions = sdks.map{ |v| "#{v[:name]} (#{v[:number]})" }
          
          if questions.count == 1 && auto_install_if_only_result
            index = 0
          elsif questions.count > 0
            answer = UI.select("What to install", questions)
            index = questions.index answer
          else
            UI.user_error! "Nothing to install based on filter"
          end
          
          # Install all SDKs
          # sh "echo \"y\" | android update sdk --all --no-ui --filter #{sdks[index][:number]}"
          
          if sdks.find { |v| v[:name].downcase.include?("haxm installer") }
            UI.important "It appears that you have downloaded/installed 'HAXM' but you will still need to run the 'silent_install.sh'."
            UI.important "Command: `sudo /usr/local/opt/android-sdk/extras/intel/Hardware_Accelerated_Execution_Manager/silent_install.sh` "
            if UI.confirm("Do you want Fastlane to run this command for you?")
              UI.message "This may take a while..."
              sh "sudo /usr/local/opt/android-sdk/extras/intel/Hardware_Accelerated_Execution_Manager/silent_install.sh"
            end
          end
        end
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
        # Define all options your action supports. 
        
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :find,
                                       description: "Query for finding on single install (fails if multiples)",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :filter_in,
                                       description: "Query for filtering in installs",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :filter_out,
                                       description: "Query for filtering out installs",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :show_obsolete,
                                       description: "Show obsolete",
                                       is_string: false,
                                       optional: true,
                                       default_value: false),
          # FastlaneCore::ConfigItem.new(key: :auto_install_if_only_result,
          #                              description: "",
          #                              is_string: false,
          #                              optional: true,
          #                              default_value: true),
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['INSTALL_ANDROID_CUSTOM_VALUE', 'A description of what this value contains']
        ]
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
