# api.rb

# Ajouter la gem captive-api
unless File.read("Gemfile").include?("captive-api")
  gem "captive-api"

  run "bundle install"
end

# Générer un Controller API::V1::BaseController héritant de Captive::API::ApplicationController
generate "controller", "API::V1::Base", "--skip-assets", "--skip-helper"

# Créer le namespace :API et le sous-namespace :V1 dans le fichier de routes
route <<~RUBY
  namespace :API, path: '' do
    namespace :V1 do
      # Vos routes API ici
    end
  end
RUBY

# Ajouter la gem rack-cors
unless File.read("Gemfile").include?("rack-cors")
  gem "rack-cors"

  run "bundle install"
end

# Créer le fichier d'initializers pour Cors
create_file "config/initializers/cors.rb", <<~RUBY
  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: [:get, :post, :patch, :put]
    end
  end
RUBY

# Configure rswag
RSWAG_TEMPLATE = "https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/templates/rswag.rb".freeze
apply(RSWAG_TEMPLATE)
