time_zone = ask("Entrer la time zone ? [Paris]", default: "Paris")
environment "config.time_zone = '#{time_zone.capitalize}'"

default_locale = ask("Entrer la default locale ? [FR]", default: "FR")
environment "config.i18n.default_locale = :#{default_locale.downcase}"

gem_name = "rails-i18n"

unless File.read("Gemfile").include?(gem_name)
  gem gem_name

  # Installez les gems
  run "bundle install"
end
