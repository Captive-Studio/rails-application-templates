gems = %w(bullet)

gems.each do |g|
  unless File.read("Gemfile").include?(g)
    gem_group :development, :test do
      gem g
    end
  end

  run "bundle install"
  BUNDLE_LOCKER_TEMPLATE = "https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/templates/bundle_locker.rb".freeze
  apply(BUNDLE_LOCKER_TEMPLATE)
end

unless File.read("config/environments/development.rb").include?("Bullet.")
  inject_into_file "config/environments/development.rb", after: "Rails.application.configure do\n" do
    <<~RUBY
      \tconfig.after_initialize do
        \tBullet.enable        = true
        \tBullet.alert         = false
        \tBullet.bullet_logger = true
        \tBullet.console       = true
        \tBullet.rails_logger  = true
        \tBullet.add_footer    = true
      \tend
    RUBY
  end
end

unless File.read("config/environments/test.rb").include?("Bullet.")
  inject_into_file "config/environments/test.rb", after: "Rails.application.configure do\n" do
    <<~RUBY
      \tconfig.after_initialize do
        \tBullet.enable        = true
        \tBullet.bullet_logger = true
        \tBullet.raise         = true # raise an error if n+1 query occurs
        \tBullet.add_safelist type: :unused_eager_loading,
        \t                    class_name: "ActiveStorage::Blob",
        \t                    association: :variant_records
      \tend
    RUBY
  end
end

git add: "Gemfile Gemfile.lock config/environments/development.rb config/environments/test.rb"
git commit: "-m '🔧 Configure Bullet'"
