# rails-application-templates

## Usage

| name | description  | command  |
|------|--------------|----------|
| database_uuid | Active l'extension UUID sur la base de donnée (PostgreSQL) afin de remplacer les ID (bigint) en UUID | `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/database_uuid.rb` |
| validation_telephone | Ajoute une validation sur le telephone | `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/validation_telephone.rb` |
| rswag | Configure rswag | `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/rswag.rb` |
| api | Configure l'api avec rswag | `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/api.rb` |
| sentry | Configure sentry sur l'app | `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/sentry.rb` |
| captive_admin | Configure captive_admin avec devise et active admin | `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/captive_admin.rb` |
| devise | Configure devise| `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/devise.rb` |
| active_admin | Configure active_admin| `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/active_admin.rb` |
| guard | Configure guard| `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/guard.rb` |
| environment | Configure l'application en Français, Anglais, ...| `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/environment.rb` |
| procfile | Configure foreman et un procfile pour déployer sur Scalingo | `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/procfile.rb` |
| rubocop_captive | Configure le rubocop avec la config captive | `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/rubocop_captive.rb` |
| bundle_locker | Configure la gem bundle-locker pour corriger le Gemfile | `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/bundle_locker.rb` |

Vous pouvez simplifier l'usage des templates en ajoutant la fonction suivante dans votre fichier ` ~/.zshrc`

```bash
run_rails_template() {
  if [ -z "$1" ]; then
    echo "Usage: run_rails_template PARAMETRE1"
    return 1
  fi

  local PARAMETRE1="$1"
  rails_command="rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/${PARAMETRE1}.rb"

  eval "$rails_command"
}
```

Cela permettra d'utiliser un template de la manière suivante : 

```bash
$ run_rails_template validation_telephone
  apply  https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/validation_telephone.rb
bin/rails aborted! pays par défaut (par exemple, 'FR' pour la France)? 
```

## Rules

- chaque template doit être le plus unitaire possible
- les templates doivent être écris en `snake_case`
- Remplacer les `puts` par [say](https://www.rubydoc.info/github/wycats/thor/Thor%2FShell%2FBasic:say)

  *Cela permet notamment de colorer le message*
- Les questions (`ask(string)`) doivent commencer avec un verbe à l'infinitif
- Les questions (`ask(string)`) doivent comporter la valeur par défaut dans la phrase entre croché
```ruby
# BAD
ask("Quel est votre pays ?", default: "FRANCE")

# GOOD
ask("Entrer votre pays [FRANCE]", default: "FRANCE")
```
- Les questions oui/non (`yes?(string)`) doit comporter la valeur par défaut dans la phrase entre croché
  `Aimez-vous les brocolis ? [Y/n]`
- Ne pas installer les gems en double sur le Gemfile
```ruby
gems = %w(devise devise-i18n)

gems.each do |g|
  unless File.read("Gemfile").include?(g)
    gem g
  end
end
```
