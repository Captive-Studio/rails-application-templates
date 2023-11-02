gems = %w(devise devise-i18n)

gems.each do |gem|
  unless File.read('Gemfile').include?("#{gem}")
    gem "#{gem}"
  end
end
run 'bundle install'

# Configure Devise
generate 'devise:install'
devise_model_name = ask('Comment souhaitez-vous appeler votre modèle Devise (A noter: Si vous ne precisez rien, User sera par defaut)?')
generate 'devise', devise_model_name
rake 'db:migrate'

# Demander le nom du projet
app_name = ask("Quel est le mail qui envoie les emails devise (ex: no-reply@example.com) ?")

# Utiliser le nom du projet dans la configuration de Devise
gsub_file 'config/initializers/devise.rb', 'config.mailer_sender = "please-change-me-at-config-initializers-devise@example.com"', "config.mailer_sender = '#{app_name}'"