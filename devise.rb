gems = %w(devise devise-i18n)

gems.each do |gem|
  unless File.read("Gemfile").include?("#{gem}")
    gem "#{gem}"
  end
end
run "bundle install"

# Configure Devise
generate "devise:install"
devise_model_name = ask("Entrer le nom du modèle Devise [User] ?")
generate "devise", devise_model_name
rake "db:migrate"

# Demander le nom du projet
app_name = ask("Entrer le mail qui envoie les emails devise (ex: no-reply@example.com) ?")

# Utiliser le nom du projet dans la configuration de Devise
gsub_file "config/initializers/devise.rb",
          'config.mailer_sender = "please-change-me-at-config-initializers-devise@example.com"',
          "config.mailer_sender = '#{app_name}'"
# Message final
say "Votre application Rails a été créée avec succès et configurée avec Devise, Devise-i18n", :green
