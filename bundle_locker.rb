gem_name = %w(bundle-locker)

unless File.read("Gemfile").include?(gem_name)
  gem_group :development do
    gem gem_name
  end

  run "bundle install"
end

run "bundle exec bundle-locker ./Gemfile"

# Manually edit Gemfile and adjust constraints "x.x.x", "~> x.x.x", etc
file_path = "Gemfile"
# Lis le contenu du fichier Gemfile
gemfile_content = File.read(file_path)
# Remplace "x.x.x" par "~> x.x.x"
modified_content = gemfile_content.gsub(/"(\d+\.\d+\.\d+)"/, '"~> \1"')
# Écris le contenu modifié dans le fichier Gemfile
File.open(file_path, "w") { |file| file.puts modified_content }
