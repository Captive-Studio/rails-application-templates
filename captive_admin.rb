# Devise
installation_devise = yes?("Souhaitez vous installer et configurer Devise ? [y/N]")

if installation_devise
  DEVISE_TEMPLATE = "https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/devise.rb".freeze
  apply(DEVISE_TEMPLATE)
end

# Active admin
installation_active_admin = yes?("Souhaitez vous installer et configurer Active admin ? [y/N]")

if installation_active_admin
  ACTIVE_ADMIN_TEMPLATE = "https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/active_admin.rb".freeze
  apply(ACTIVE_ADMIN_TEMPLATE)
end

# Captive admin
gems = %w(captive-admin captive-theme)

gems.each do |gem|
  unless File.read("Gemfile").include?("#{gem}")
    gem "#{gem}"
  end
end
# Installez les gems
run "bundle install"

# Modifier active_admin.scss
gsub_file "app/assets/stylesheets/active_admin.scss",
          '@import "active_admin/mixins";',
          '@import "captive-admin/mixins";'
gsub_file "app/assets/stylesheets/active_admin.scss",
          '@import "active_admin/base";',
          '@import "captive-admin/base";'

# Message final
say "Votre application Rails a été créée avec succès et configurée avec Captive Admin et Captive Admin theme.",
    :green
