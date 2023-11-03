gems = %w(guard-rspec guard-rubocop)

gem_group :development do
  gems.each do |gem|
    unless File.read("Gemfile").include?("#{gem}")
      gem "#{gem}"
    end
  end
end

run "bundle install"

run "bundle exec guard init"

insert_into_file "Guardfile" do
  <<~RUBY
    group :red_green_refactor, halt_on_fail: true do
  RUBY
end

gsub_file "Guardfile",
          'guard :rspec, cmd: "bundle exec rspec" do',
          'guard :rspec, cmd: "bundle exec rspec", all_on_start: true do'
