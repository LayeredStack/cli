# frozen_string_literal: true

require 'fileutils'
require 'thor'
require 'logger'

module LayeredStack
  module Frontend
    class Create < Thor
      CREATE_NEXT_APP_SWITCHES = "--js --tailwind --eslint --app --src-dir --import-alias @/* --use-npm"

      FRONTEND_DIR = "frontend"

      def self.asset_path(relative_path)
        File.expand_path("../../../../assets/#{relative_path}", __FILE__)
      end

      ASSET_FILES = {
        asset_path("tailwind.config.js") => "frontend/tailwind.config.js",
        asset_path("layout.js") => "frontend/src/app/layout.js",
        asset_path("page.js") => "frontend/src/app/page.js",
        asset_path("images/logo_dark.svg") => "frontend/src/app/logo_dark.svg",
        asset_path("images/logo_light.svg") => "frontend/src/app/logo_light.svg",
      }

      LOGO_FILES = {
        "assets/images/logo_dark.svg" => "frontend/src/app/logo_dark.svg",
        "assets/images/logo_light.svg" => "frontend/src/app/logo_light.svg",
      }

      def self.execute
        new.execute
      end

      no_commands do
        def execute
          logger.info("> layered_stack/create")
          remove_existing_frontend
          run_create_next_app
          Dir.chdir(FRONTEND_DIR) do
            install_dependencies
            update_package_json
          end
          copy_asset_files
          copy_logo_files
          print_next_step
        end

        private

        def logger
          @logger ||= Logger.new(STDOUT)
        end

        def remove_existing_frontend
          if Dir.exist?(FRONTEND_DIR)
            logger.info("\n# Removing existing /#{FRONTEND_DIR} directory")
            FileUtils.rm_rf(FRONTEND_DIR)
          end
        end

        def run_create_next_app
          command = "npx create-next-app@latest #{CREATE_NEXT_APP_SWITCHES} #{FRONTEND_DIR}"
          run_command(command, "Running create-next-app")
        end

        def install_dependencies
          dependencies = [
            "next-themes",
            "@heroicons/react@latest",
            "@layeredstack/ui@latest"
          ]
          dependencies.each do |dep|
            run_command("npm install #{dep}", "Installing #{dep}")
          end
        end

        def update_package_json
          logger.info("# Updating package.json to change the port to 3001")
          update_file("package.json", '"dev": "next dev"', '"dev": "next dev -p 3001"')
          update_file("package.json", '"start": "next start"', '"start": "next start -p 3001"')
        end

        def copy_asset_files
          logger.info("\n# Copying asset files to the frontend directory")
          copy_files(ASSET_FILES)
        end

        def copy_logo_files
          logger.info("\n# Copying logo files to the frontend directory")
          copy_files(LOGO_FILES) { |src, dest| copy_logo_file(src, dest) }
        end

        def copy_files(files)
          files.each do |src, dest|
            if block_given?
              yield(src, dest)
            else
              FileUtils.cp(src, dest)
            end
          end
        end

        def copy_logo_file(src, dest)
          if File.exist?(src)
            logger.info("User provided logo exists in assets, copying #{src} to #{dest}")
            FileUtils.cp(src, dest)
          else
            template_src = ASSET_FILES.find { |k, _| k.include?(File.basename(src)) }&.first
            if template_src
              logger.info("No user provided logo found in 'assets/images/', copying default logo from #{template_src} to #{dest}")
              FileUtils.cp(template_src, dest)
            else
              logger.warn("Default logo file #{src} not found")
            end
          end
        end

        def run_command(command, message)
          logger.info(message)
          system(command)
        end

        def update_file(file, old_content, new_content)
          content = File.read(file)
          new_content = content.gsub(old_content, new_content)
          File.write(file, new_content)
        end

        def print_next_step
          logger.info("\n# Next step:")
          logger.info("bundle exec layered_stack frontend start")
        end
      end
    end
  end
end
