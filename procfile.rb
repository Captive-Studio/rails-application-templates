gem_name = "foreman"

unless File.read("Gemfile").include?(gem_name)
  gem gem_name

  # Installez les gems
  run "bundle install"
end

# Vérifie si la gem Sidekiq est présente dans le Gemfile
sidekiq_present = File.read("Gemfile").include?("sidekiq")

# Ajoute les lignes du Procfile
procfile_content = <<~EOF
web: bundle exec puma -C config/puma.rb
#{sidekiq_present ? "worker: bundle exec sidekiq" : ""}
postdeploy: bin/postdeploy.sh
EOF

file "Procfile", procfile_content, force: true

# Créer le fichier bin/postdeploy.sh
postdeploy_content = <<~EOF
#!/bin/bash

set –e
if [[ -z "$RAILS_ENV" || "$RAILS_ENV" = "development" ]] ; then
  cat
else
  bundle exec rake db:migrate
fi
EOF

file "bin/postdeploy.sh", postdeploy_content, force: true

# Rend le fichier exécutable
chmod "bin/postdeploy.sh", 0o755
