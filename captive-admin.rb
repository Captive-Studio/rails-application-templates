# admin_template.rb

# Devise

installation_devise = yes?('Souhaitez vous installer et configurer Devise ?')

if installation_devise
  system('rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/creation-template-captive-admin/devise.rb')
end

# gems = %w(activeadmin kaminari-i18n cancancan captive_admin)

# gems.each do |gem|
#   unless File.read('Gemfile').include?("#{gem}")
#     gem "#{gem}"
#   end
# end

# # Installez les gems
# run 'bundle install'

# # Rake task pour les migrations
# rake 'db:migrate'

# # Configurations CancanCan
# generate 'cancan:ability'

# # Configurations Active Admin
# generate 'active_admin:install'
# resource_admin_active_admin = ask('Comment souhaitez-vous appeler votre resource utilisateur active admin ? (ex: Utilisateur)')

# # Générer une ressource Active Admin (exemple : User) 
# generate "active_admin:resource #{resource_admin_active_admin}"
# # Rake task pour les migrations
# rake 'db:migrate'
# rake 'db:seed'

# # Configurations Captive Admin
# generate 'captive_admin:install'

# # Rake task pour les migrations
# rake 'db:migrate'

# # Modifier active_admin.scss
# gsub_file 'app/assets/stylesheets/active_admin.scss', '@import "active_admin/mixins";', '@import "captive_admin/mixins";'
# gsub_file 'app/assets/stylesheets/active_admin.scss', '@import "active_admin/base";', '@import "captive_admin/base";'

# Message final
say 'Votre application Rails a été créée avec succès et configurée avec Devise, CancanCan, Active Admin et Captive Admin.', :green