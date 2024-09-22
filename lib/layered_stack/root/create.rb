# frozen_string_literal: true

require 'fileutils'
require 'thor'
require 'logger'

module LayeredStack
  module Root
    class Create < Thor
      def self.execute(arg)
        new.execute(arg)
      end

      no_commands do
        def execute(arg)
          logger.info("> layered_stack/create")

          # Check if the folder exists
          return if check_folder_exists?(arg)

          # Create the folder
          logger.info("Creating directory: #{arg}")
          FileUtils.mkdir_p(arg)
          logger.info("Directory created: #{arg}")

          # Copy the templates
          copy_template(arg)

          # Rename the devcontainer directory to .devcontainer
          rename_devcontainer(arg)

          # Open the folder in VS Code
          run_command("code #{arg}", "Opening #{arg} in VS Code")
        end

        private

        def logger
          @logger ||= Logger.new(STDOUT)
        end

        def run_command(command, message)
          logger.info(message)
          system(command)
        end

        def check_folder_exists?(folder)
          if File.directory?(folder)
            logger.info("Directory exists: #{folder}")
            true
          else
            logger.info("Directory does not exist: #{folder}")
            false
          end
        end

        def copy_template(destination)
          source = File.expand_path('../../../../templates/root', __FILE__)
          logger.info("Copying templates from #{source} to #{destination}")
          FileUtils.cp_r("#{source}/.", destination)
          logger.info("Templates copied to #{destination}")
        end


        def rename_devcontainer(folder)
          devcontainer_path = File.join(folder, 'devcontainer')
          new_devcontainer_path = File.join(folder, '.devcontainer')

          if File.directory?(devcontainer_path)
            logger.info("Renaming #{devcontainer_path} to #{new_devcontainer_path}")
            FileUtils.mv(devcontainer_path, new_devcontainer_path)
            logger.info("Renamed to #{new_devcontainer_path}")
          else
            logger.info("No devcontainer directory to rename")
          end
        end
      end
    end
  end
end
