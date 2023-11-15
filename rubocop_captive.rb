gems_dev_test = %w(rubocop-config-captive)

gem_group :development, :test do
  gems_dev_test.each do |g|
    unless File.read("Gemfile").include?("#{g}")
      gem "#{g}"
    end
  end
end

# Installez les gems
run "bundle install"

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
