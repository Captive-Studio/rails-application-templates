# Add the "pg" gem to your Gemfile for PostgreSQL support
gem "pg"

# Generate a migration to enable the "pgcrypto" extension for UUIDs
generate "migration", "EnablePgcryptoExtension", "enable_pgcrypto_extension"

# In the generated migration file, add the SQL command to enable the extension
# (You may need to adjust this based on your specific PostgreSQL version)
insert_into_file "db/migrate/XXXXXXXX_enable_pgcrypto_extension.rb", after: "def change\n" do
  <<~RUBY
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  RUBY
end

# Run the migration to enable the extension
rails_command "db:migrate"

# Initialize the database with UUIDs as the default data type
rails_command "db:setup"
