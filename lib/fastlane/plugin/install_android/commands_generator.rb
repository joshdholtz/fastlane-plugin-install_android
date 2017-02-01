require 'commander'
require 'fastlane/version'

HighLine.track_eof = false

module Fastlane
  module InstallAndroid
    class CommandsGenerator
      include Commander::Methods
      UI = FastlaneCore::UI

      def self.start
        self.new.run
      end

      def run
        program :name, 'match'
        program :version, Fastlane::InstallAndroid::VERSION
        program :description, Fastlane::InstallAndroid::DESCRIPTION
        program :help, 'Author', 'Josh Holtz <me@joshholtz.com>'
        program :help, 'GitHub', 'https://github.com/joshdholtz/fastlane-plugin-install_android'
        program :help_formatter, :compact

        global_option('--verbose') { $verbose = true }

        # FastlaneCore::CommanderGenerator.new.generate(Match::Options.available_options)

        command :run do |c|
          c.syntax = 'install_android'
          c.description = ""

          c.action do |args, options|
            puts "Teeehheeeee"
            
            # params = FastlaneCore::Configuration.create(Match::Options.available_options, options.__hash__)
            # params.load_configuration_file("Matchfile")
            # Match::Runner.new.run(params)
            
            Fastlane.load_actions
            Fastlane::Actions::InstallAndroidAction.run({})
          end
        end
        
        command :list_sdks do |c|
          c.syntax = 'install_android list_sdks'
          c.description = ""

          c.action do |args, options|
            Fastlane.load_actions
            sdks = Helper::InstallAndroidHelper.list_sdks
            sdks.each do |sdk|
              puts sdk
            end
            
            # params = FastlaneCore::Configuration.create(Match::Options.available_options, options.__hash__)
            # params.load_configuration_file("Matchfile")
            # Match::Runner.new.run(params)
            
            # Fastlane.load_actions
            # Fastlane::Actions::InstallAndroidAction.run({})
          end
        end

        default_command :run

        run!
      end
    end
  end
end
