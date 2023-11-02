# sentry.rb

# Ajouter les gems Sentry

gems = %w(sentry-ruby sentry-rails sentry-sidekiq)

gems.each do |gem|
  unless File.read('Gemfile').include?("#{gem}")
    gem "#{gem}"
  end
end

run 'bundle install'

# config/initializers/sentry.rb
after_bundle do
  create_file 'config/initializers/sentry.rb', <<~RUBY
    Sentry.init do |config|
      config.dsn = ENV['SENTRY_DSN']
      config.breadcrumbs_logger = [:active_support_logger, :http_logger, :sentry_logger]

      config.environment = ENV['SENTRY_ENV'] || Rails.env
      config.enabled_environments = %w(staging production)

      config.traces_sample_rate = ENV['SENTRY_TRACES_RATE'] || 0.1
    end
  RUBY

  puts "La valeur de “config.dsn = 'XXXXXX'” se trouve dans Sentry. Project > Settings > Client keys"
  puts "- Configurer la variable d’environnement `SENTRY_ENV` (en fonction de l’environnement donnée)
    - `SENTRY_ENV=staging`
    - `SENTRY_ENV=production`
    - Configurer la variable d’environnement `SENTRY_TRACES_RATE` en fonction de l’utilisation de la production"
end

# app/controllers/concerns/sentry_context_concern.rb
after_bundle do
  create_file 'app/controllers/concerns/sentry_context_concern.rb', <<~RUBY

    module SentryContextConcern
      extend ActiveSupport::Concern

      included do
        before_action :set_sentry_context

        def set_sentry_context
          set_user_on_sentry_context
          set_params_on_sentry_context
        end

        def set_user_on_sentry_context
          # Replace `current_utilisateur` and `current_administrateur` with your application's user model
          compte = current_utilisateur || current_administrateur
          return if compte.blank?

          Sentry.set_user(id: compte.id, email: compte.email)
        end

        def set_params_on_sentry_context
          return if params.blank?

          # Use `#to_unsafe_hash` to convert the unpermitted params object to a hash
          Sentry.set_context('params', params.to_unsafe_hash)
        end
      end
    end
  RUBY
  puts "⚠️ Changer current_utilisateur et current_administrateur en fonction du contexte de votre application"
end

# app/controllers/application_controller.rb
after_bundle do
  inject_into_file 'app/controllers/application_controller.rb', after: "class ApplicationController < ActionController::Base\n" do
    <<~RUBY
      include SentryContextConcern
    RUBY
  end
end

# config/initializers/active_admin.rb
after_bundle do
  inject_into_file 'config/initializers/active_admin.rb' do
    <<~RUBY
      def set_sentry_context
        ActiveAdmin::ResourceDSL.send(:include, SentryContextConcern)
      end
    RUBY
  end

  inject_into_file 'config/initializers/active_admin.rb', after: "ActiveAdmin.setup do |config|\n" do
    <<~RUBY
      config.before_action :set_sentry_context
    RUBY
  end
end