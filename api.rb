# api.rb

# Ajouter la gem captive-api
gem 'captive-api'

# Générer un Controller API::V1::BaseController héritant de Captive::API::ApplicationController
generate 'controller', 'API::V1::Base', '--skip-assets', '--skip-helper'

# Créer le namespace :API et le sous-namespace :V1 dans le fichier de routes
route <<~RUBY
  namespace :API, path: '' do
    namespace :V1 do
      # Vos routes API ici
    end
  end
RUBY

# Ajouter la gem rack-cors
gem 'rack-cors'

# Créer le fichier d'initializers pour Cors
create_file 'config/initializers/cors.rb', <<~RUBY
  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: [:get, :post, :patch, :put]
    end
  end
RUBY

# Configure rswag
rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/rswag.rb
