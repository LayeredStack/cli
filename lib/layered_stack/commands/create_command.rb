# frozen_string_literal: true

require 'fileutils'
require 'thor'

module LayeredStack
  module Cli
    module Commands
      class CreateCommand < Thor
        CREATE_NEXT_APP_SWITCHES = "--js --tailwind --eslint --app --src-dir --import-alias @/* --use-npm"

        FRONTEND_DIR = "frontend"

        ASSET_FILES = {
          File.expand_path("../../../../assets/tailwind.config.js", __FILE__) => "frontend/tailwind.config.js",
          File.expand_path("../../../../assets/layout.js", __FILE__) => "frontend/src/app/layout.js",
          File.expand_path("../../../../assets/page.js", __FILE__) => "frontend/src/app/page.js",
          File.expand_path("../../../../assets/images/logo_dark.svg", __FILE__) => "frontend/src/app/logo_dark.svg",
          File.expand_path("../../../../assets/images/logo_light.svg", __FILE__) => "frontend/src/app/logo_light.svg",
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
            puts "> layered_stack/create"
            remove_existing_frontend
            run_create_next_app
            Dir.chdir(FRONTEND_DIR) do
              install_dependencies
              update_package_json
            end
            copy_template_files
            copy_logo_files
            print_next_steps
          end

          private

          def remove_existing_frontend
            if Dir.exist?(FRONTEND_DIR)
              puts "\n# Removing existing /#{FRONTEND_DIR} directory"
              FileUtils.rm_rf(FRONTEND_DIR)
            end
          end

          def run_create_next_app
            command = "npx create-next-app@latest #{CREATE_NEXT_APP_SWITCHES} #{FRONTEND_DIR}"
            run_command(command, "Running create-next-app")
          end

          def install_dependencies
            run_command("npm install next-themes", "Installing next-themes")
            run_command("npm install @heroicons/react@latest", "Installing @heroicons/react@latest")
            run_command("npm install @layeredstack/ui@latest", "Installing @layeredstack/ui@latest")
          end

          def update_package_json
            puts "# Updating package.json to change the port to 3001"
            update_file("package.json", '"dev": "next dev"', '"dev": "next dev -p 3001"')
            update_file("package.json", '"start": "next start"', '"start": "next start -p 3001"')
          end

          def copy_template_files
            puts "\n# Copying template files to the frontend directory"

            ASSET_FILES.each do |src, dest|
              FileUtils.cp(src, dest)
            end
          end

          def copy_logo_files
            puts "\n# Copying logo files to the frontend directory"

            LOGO_FILES.each do |src, dest|
              copy_logo_file(src, dest)
            end
          end

          def copy_logo_file(src, dest)
            if File.exist?(src)
              puts "User provided logo exists in assets, copying #{src} to #{dest}"
              FileUtils.cp(src, dest)
            else
              template_src = ASSET_FILES.find { |k, _| k.include?(File.basename(src)) }&.first
              if template_src
                puts "Copying default logo #{template_src} to #{dest}"
                FileUtils.cp(template_src, dest)
              else
                puts "Default logo for #{src} not found"
              end
            end
          end

          def print_next_steps
            puts "\n# Start the project with the following command:"
            puts "bundle exec layered_stack start"
          end

          def run_command(command, description)
            puts "\n# #{description}"
            system(command) || abort("Failed to execute: #{command}")
          end

          def update_file(file, pattern, replacement)
            system("sed -i '' 's/#{pattern}/#{replacement}/' #{file}") || abort("Failed to update #{file}")
          end
        end
      end
    end
  end
end
