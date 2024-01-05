gems = %w(rubycritic)

gems.each do |g|
  unless File.read("Gemfile").include?(g)
      gem g
  end
end

run "bundle install"

BUNDLE_LOCKER_TEMPLATE = "https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/templates/bundle_locker.rb".freeze
apply(BUNDLE_LOCKER_TEMPLATE)

# Configuration de RubyCritic
ruby_critic_config = <<~YAML
  mode_ci:
    enabled: true
    branch: main
  branch: main
  path: /tmp/
  threshold_score: 0
  deduplicate_symlinks: true
  suppress_ratings: true
  no_browser: false
  UncommunicativeVariableName:
    accept:
      - _
      - V1
  formats:
    - console
    - html
  paths:
    - app/controllers/
    - app/models/
    - app/admin/
    - app/helpers/
    - app/jobs/
    - app/mailers/
    - app/notifications/
    - app/views/
    - config/initializers
    - config/application.rb
    - config/environments
    - lib/
YAML

create_file "rubycritic.yml", ruby_critic_config

reek_config = <<~YAML
  detectors:
    IrresponsibleModule:
      enabled: false
    TooManyStatements:
      max_statements: 5
    DataClump:
      max_copies: 3
      min_clump_size: 3
    MissingSafeMethod:
      enabled: false
    DuplicateMethodCall:
      enabled: true
      exclude: [spec/]
    UncommunicativeModuleName:
      accept:
        - V1

  directories:
    spec/:
      IrresponsibleModule:
        enabled: false
YAML

create_file "reek.yml", reek_config

git add: "Gemfile Gemfile.lock rubycritic.yml reek.yml"
git commit: "-m '🔧 Configure RubyCritic'"
