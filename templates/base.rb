GEMFILE = 'Gemfile'
BUNDLE_LOCKER_TEMPLATE = "https://raw.githubusercontent.com/Captive-Studio/rails-application-templates/main/templates/bundle_locker.rb".freeze

def run_rubocop
  run "bundle exec rubocop -A"
end

def add_gems(gems_name, group: nil)
  gems_name.each do |gem_name|
    add_gem(gem_name, group: group, skip_install: true)
  end

  install_gem
end

def add_gem(gem_name, group: nil, skip_install: false)
  group = Array(group) if group
  add_group_if_exist(group)

  return if gem_exist?(gem_name)

  if group
    insert_into_file GEMFILE, after: group_string(group) do
      <<~RUBY
        gem "#{gem_name}"
      RUBY
    end
  else
    gem gem_name
  end

  install_gem unless skip_install
end

def install_gem
  run "bundle install"
  apply(BUNDLE_LOCKER_TEMPLATE)
end

def group_exist?(group)
  gemfile_include?(group_string(group))
end

def group_string(group)
  "group :#{group.join(', :')} do"
end

def add_group_if_exist(group)
  return if group.nil?
  return if group_exist?(group)

  gem_group group
end

def gem_exist?(gem_name)
  gemfile_include?(gem_name)
end

def gemfile_include?(string)
  File.read(GEMFILE).include?(string)
end
