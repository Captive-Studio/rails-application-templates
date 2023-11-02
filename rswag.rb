# rswag_template.rb

# Ajouter les gems rswag-api, rswag-ui
gems = %w(rswag-api rswag-ui)

gems.each do |gem|
  unless File.read("Gemfile").include?("#{gem}")
    gem "#{gem}"
  end
end

gems_dev_test = %w(rspec-rails rswag-specs)

gem_group :development, :test do
  gems_dev_test.each do |gem|
    unless File.read("Gemfile").include?("#{gem}")
      gem "#{gem}"
    end
  end
end

# Après l'installation des gemmes, exécuter les commandes pour installer RSWAG
after_bundle do
  generate "rswag:api:install"
  generate "rswag:ui:install"
  system("RAILS_ENV=test rails g rswag:specs:install")
end

# Définir les routes pour la documentation
route "mount Rswag::Ui::Engine => '/api-docs'"
route "mount Rswag::Api::Engine => '/api-docs'"

# Ajouter le code au rails_helper.rb
after_bundle do
  inject_into_file "spec/rails_helper.rb", after: "RSpec.configure do |config|\n" do
    <<~RUBY
      config.after(:each) do |example|
        if example.metadata[:type].eql?(:request) && response&.body.present?
          content = example.metadata[:response][:content] || {}
          example_spec = {
            "application/json" => {
              examples: {
                test_example: {
                  value: JSON.parse(response.body, symbolize_names: true),
                },
              },
            },
          }
          example.metadata[:response][:content] = content.deep_merge(example_spec)
        end
      rescue JSON::ParserError
        nil
      end
    RUBY
  end
end
