time_zone = ask("Entrer la time zone ? [Paris]", default: "Paris")
environment "config.time_zone = '#{time_zone.capitalize}'"

default_locale = ask("Entrer la default locale ? [FR]", default: "FR")
environment "config.i18n.default_locale = :#{default_locale.downcase}"

gems = %w(rails-i18n)
gems.each do |gem|
  unless File.read("Gemfile").include?("#{gem}")
    gem "#{gem}"
  end
end

run "bundle install"
