gems = %w(cancancan kaminari-i18n activeadmin activeadmin_addons)

gems.each do |gem|
  unless File.read("Gemfile").include?("#{gem}")
    gem "#{gem}"
  end
end

# Installez les gems
run "bundle install"

# Configurations CancanCan
generate "cancan:ability"

# Configurations Active Admin
resource_admin_active_admin = ask("Entrer le nom de la resource user active admin ? (ex: Compte)")
generate "active_admin:install", resource_admin_active_admin

# Rake task pour les migrations
rake "db:migrate"
rake "db:seed"

# Décommenter la ligne "config.maximum_association_filter_arity" dans l'initialiseur d'Active Admin
gsub_file "config/initializers/active_admin.rb",
          /# config.maximum_association_filter_arity = 256/,
          "config.maximum_association_filter_arity = 256"

# Customise la phrase du footer pour avoir : Créé sur mesure par Captive
gsub_file "config/initializers/active_admin.rb",
          /# config.footer = 'my custom footer text'/,
          "config.footer = 'Créé sur mesure par <a href=\"https://captive.fr\" target=\"_blank\">Captive</a>'\n
    .html_safe"

# Configuration activeadmin_addons
generate "activeadmin_addons:install"
# Message final
say "Votre application Rails a été créée avec succès et configurée avec Cancancan, Kaminari-i18n, Activeadmin, Activeadmin Addons.",
    :green
