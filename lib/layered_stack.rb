require 'thor'

# Require all .rb files in the layered_stack folder recursively
Dir[File.join(__dir__, 'layered_stack/**/*.rb')].each { |file| require_relative file }

module LayeredStack
  class Cli < Thor
    desc "start", "Start"
    def start
      Frontend.new.start
      Backend.new.start
    end

    class Frontend < Thor
      namespace :frontend

      desc "create", "Create"
      def create
        LayeredStack::Frontend::Create.execute
      end

      desc "start", "Start"
      def start
        LayeredStack::Frontend::Start.execute
      end

      desc "create_and_start", "Create and start"
      def create_and_start
        create
        start
      end
    end
    register(Frontend, 'frontend', 'frontend [COMMAND]', 'Commands for the frontend')

    class Backend < Thor
      namespace :backend

      desc "create", "Create"
      def create
        LayeredStack::Backend::Create.execute
      end

      desc "start", "Start"
      def start
        LayeredStack::Backend::Start.execute
      end

      desc "create_and_start", "Create and start"
      def create_and_start
        create
        start
      end
    end
    register(Backend, 'backend', 'backend [COMMAND]', 'Commands for the backend')
  end
end
