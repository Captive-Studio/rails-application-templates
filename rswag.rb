# rswag_template.rb

# Ajouter les gems rswag-api, rswag-ui
gems = %w(rswag-api rswag-ui)

gems.each do |g|
  unless File.read("Gemfile").include?(g)
    gem g
  end
end

gems_dev_test = %w(rspec-rails rswag-specs)

gem_group :development, :test do
  gems_dev_test.each do |g|
    unless File.read("Gemfile").include?(g)
      gem g
    end
  end
end

run "bundle install"

# Après l'installation des gemmes, exécuter les commandes pour installer RSWAG
generate "rswag:api:install"
generate "rswag:ui:install"
system("RAILS_ENV=test rails g rswag:specs:install")

unless File.read("config/routes.rb").include?("mount Rswag::")
  # Définir les routes pour la documentation
  route "mount Rswag::Ui::Engine => '/api-docs'"
  route "mount Rswag::Api::Engine => '/api-docs'"
end

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

git add: "."
git commit: "➕ Ajoute la gem rswag"

run "yarn add husky -D"
run "yarn add lint-staged -D"
run "npx husky add .husky/pre-commit \"npx lint-staged\""
run "git add .husky/pre-commit"

inject_into_file "package.json", after: "\"lint-staged\": {\n" do
  <<~EOF
    "spec/requests/**/*_spec.rb": [
      "SWAGGER_DRY_RUN=0 rails rswag",
      "git add swagger/**/*"
    ]
  EOF
end

git add: "."
git commit: "🔧 Configure le pre-commit de documentation"
