source 'http://rubygems.org'

gemspec


group :development do
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'sqlite3',                          :platform => [:ruby, :mswin, :mingw]
  gem 'jdbc-sqlite3',                     :platform => :jruby
  gem 'activerecord-jdbcsqlite3-adapter', :platform => :jruby
  
  gem 'coveralls',    :require => false
end