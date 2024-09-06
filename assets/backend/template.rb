gem "rack-cors", "~> 2.0.2"

after_bundle do
  # rails_command "db:create"
  # rails_command "db:migrate"

  # Remove the line "allow_browser versions: :modern" in backend/app/controllers/application_controller.rb
  gsub_file 'app/controllers/application_controller.rb', /^(\s*allow_browser versions: :modern)/, ''

  # Configure rack-cors in config/application.rb
  inject_into_file 'config/application.rb', before: /^  end/ do
    <<-TEXT

    # Configure CORS
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'localhost:3001'
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head]
      end
    end
    TEXT
  end

  # Create the example API controller file
  create_file "app/controllers/api/v1/examples_controller.rb", <<-TEXT
module Api
  module V1
    class ExamplesController < ApplicationController
      def index
        render json: { message: "Hello from Rails #{Rails.version}" }
      end
    end
  end
end
  TEXT

  # Create the example API route
  route <<-TEXT
namespace :api do
  namespace :v1 do
    resources 'examples', only: [:index]
  end
end
  TEXT

  # Create the Procfile
  create_file "Procfile", <<-TEXT
backend: rails s -p 3000
frontend: cd ../frontend && npm run dev
  TEXT
end
