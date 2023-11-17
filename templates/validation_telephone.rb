gem_name = "phonelib"

unless File.read("Gemfile").include?(gem_name)
  gem gem_name

  # Installez les gems
  run "bundle install"
end

# Demandez à l'utilisateur de choisir le pays par défaut
country_code = ask("Quel est le code pays par défaut (par exemple, 'FR' pour la France) ? [FR]", default: "FR")

# Générez un fichier initializer pour Phonelib avec le code pays par défaut
initializer_code = <<~RUBY
  # Configuration de Phonelib
  Phonelib.default_country = '#{country_code}'
RUBY

# Créez le répertoire config/initializers s'il n'existe pas encore
empty_directory "config/initializers"

# Créez le fichier d'initializer pour Phonelib
create_file "config/initializers/phonelib.rb", initializer_code

# Demandez à l'utilisateur sur quel modèle et quelle colonne ajouter la validation de téléphone
model_name = ask("Sur quel modèle voulez-vous ajouter la validation de téléphone (laissez vide pour passer) ?")
attribute_name = ask("Sur quelle colonne voulez-vous ajouter la validation de téléphone (laissez vide pour passer) ?")

if !model_name.empty? && !attribute_name.empty?
  validation_code = <<~RUBY
    # Validation de téléphone pour le modèle #{model_name} et la colonne #{attribute_name}
    validates :#{attribute_name}, phone: true
  RUBY

  # Créez le fichier d'ajout de validation de téléphone au modèle spécifié
  model_file_path = "app/models/#{model_name.underscore}.rb"
  if File.exist?(model_file_path)
    inject_into_file model_file_path,
                     validation_code,
                     after: "class #{model_name} < ApplicationRecord\n"
  else
    say("Le modèle #{model_name} n'a pas été trouvé. Assurez-vous que le modèle existe avant d'ajouter la validation de téléphone.")
  end
end
