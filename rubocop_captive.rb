gems_dev_test = %w(rubocop-config-captive)

gem_group :development, :test do
  gems_dev_test.each do |g|
    unless File.read("Gemfile").include?("#{g}")
      gem "#{g}"
    end
  end
end

# Installez les gems
run "bundle install"

rubocop_content = <<~EOF
inherit_gem:
  rubocop-config-captive:
    - config/default.yml
EOF

file ".rubocop.yml", rubocop_content

correction_erreur = yes?("Souhaitez-vous lancer la correction d'erreur ? [Y/n]")

if correction_erreur || correction_erreur.blank?
  run "bundle exec rubocop -A"
  run "gem install bundle-locker"
  run "bundle-locker ./Gemfile"

  # Manually edit Gemfile and adjust constraints "x.x.x", "~> x.x.x", etc
  file_path = "Gemfile"
  # Lis le contenu du fichier Gemfile
  gemfile_content = File.read(file_path)
  # Remplace "x.x.x" par "~> x.x.x"
  modified_content = gemfile_content.gsub(/"(\d+\.\d+\.\d+)"/, '"~> \1"')
  # Écris le contenu modifié dans le fichier Gemfile
  File.open(file_path, "w") { |file| file.puts modified_content }
end
