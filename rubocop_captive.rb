gem_name = "rubocop-config-captive"

unless File.read("Gemfile").include?(gem_name)
  gem_group :development, :test do
    gem gem_name
  end

  # Installez les gems
  run "bundle install"
end

rubocop_content = <<~EOF
inherit_gem:
  rubocop-config-captive:
    - config/default.yml
EOF

file ".rubocop.yml", rubocop_content

correction_erreur = yes?("Souhaitez-vous lancer la correction d'erreur ? [Y/n]")

if correction_erreur || correction_erreur.blank?
  run "bundle exec rubocop -A"

  BUNDLE_LOCKER_TEMPLATE = "https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/bundle_locker.rb".freeze
  apply(BUNDLE_LOCKER_TEMPLATE)
end
