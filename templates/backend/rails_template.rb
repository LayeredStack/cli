gem "jbuilder", "~> 2.12.0"
gem "rack-cors", "~> 2.0.2"

# Use a local copy of the Layered Stack Rails gem in development
if ENV['LAYERED_STACK_ENV'] == 'development'
  gem "layered_stack-rails", path: "../layered_stack/rails", groups: [:development, :test]
else
  gem "layered_stack-rails", "~> 0.0.6", groups: [:development, :test]
end

after_bundle do
  # rails_command "db:create"
  # rails_command "db:migrate"

  # Remove the line "allow_browser versions: :modern" in backend/app/controllers/application_controller.rb
  gsub_file 'app/controllers/application_controller.rb', /^(\s*allow_browser versions: :modern)/, ''

  # Create the cors.rb initializer with the rack-cors configuration
  create_file 'config/initializers/cors.rb', <<-RUBY
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
  RUBY

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
end
