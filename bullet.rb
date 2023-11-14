gems = %w(bullet)

gems.each do |g|
  unless File.read("Gemfile").include?("#{g}")
    gem_group :development, :test do
      gem "#{g}"
    end
  end
end

inject_into_file "config/environments/development.rb", after: "Rails.application.configure do\n" do
  <<~RUBY
    config.after_initialize do
      Bullet.enable        = true
      Bullet.alert         = false
      Bullet.bullet_logger = true
      Bullet.console       = true
      Bullet.rails_logger  = true
      Bullet.add_footer    = true
    end
  RUBY
end

inject_into_file "config/environments/test.rb", after: "Rails.application.configure do\n" do
  <<~RUBY
      config.after_initialize do
        Bullet.enable        = true
        Bullet.bullet_logger = true
        Bullet.raise         = true # raise an error if n+1 query occurs
        Bullet.add_safelist type: :unused_eager_loading,
                            class_name: "ActiveStorage::Blob",
                            association: :variant_records
      end
  RUBY
end
