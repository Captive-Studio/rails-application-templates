# rails-application-templates

## Usage

| name | description  | command  |
|------|--------------|----------|
| database_uuid | Active l'extension UUID sur la base de donnée (PostgreSQL) afin de remplacer les ID (bigint) en UUID | `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/database_uuid.rb` |
| validation_telephone | Ajoute une validation sur le telephone | `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/validation_telephone.rb` |
| rswag | Configure rswag | `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/rswag.rb` |
| api | Configure l'api avec rswag | `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/api.rb` |
| sentry | Configure sentry sur l'app | `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/sentry.rb` |
| captive_admin | Configure captive_admin avec devise | `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/captive_admin.rb` |
| devise | Configure devise| `rails app:template LOCATION=https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/devise.rb` |

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
