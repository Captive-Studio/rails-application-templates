gems = %w(formtastic country_select)

gems.each do |g|
  unless File.read("Gemfile").include?(g)
    gem g
  end

  run "bundle install"
  BUNDLE_LOCKER_TEMPLATE = "https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/templates/bundle_locker.rb".freeze
  apply(BUNDLE_LOCKER_TEMPLATE)
end

run "rails generate formtastic:install"

inject_into_file "config/initializers/formtastic.rb" do
  <<~RUBY
    Formtastic::FormBuilder.priority_countries = ["France"]
  RUBY
end

inject_into_file "config/initializers/country_select.rb" do
  <<~RUBY
    # Permet d'avoir des drapeaux lors de la sélection de Pays
    CountrySelect::FORMATS[:with_flag] =
    lambda do |country|
      "#{country.emoji_flag} #{country.iso_short_name}"
    end
    CountrySelect::DEFAULTS[:format] = :with_flag
  RUBY
end
