gems = %w(cancancan kaminari-i18n activeadmin activeadmin_addons)

gems.each do |gem|
  unless File.read('Gemfile').include?("#{gem}")
    gem "#{gem}"
  end
end

# Installez les gems
run 'bundle install'

# Configurations CancanCan
generate 'cancan:ability'

# Configurations Active Admin
resource_admin_active_admin = ask('Comment souhaitez-vous appeler votre resource user active admin ? (ex: Utilisateur)')
generate "'active_admin:install', #{resource_admin_active_admin}"

# Rake task pour les migrations
rake 'db:migrate'
rake 'db:seed'

# Décommenter la ligne "config.maximum_association_filter_arity" dans l'initialiseur d'Active Admin
gsub_file 'config/initializers/active_admin.rb', /# config.maximum_association_filter_arity = 256/, 'config.maximum_association_filter_arity = 256'

# Configuration activeadmin_addons
generate "activeadmin_addons:install"