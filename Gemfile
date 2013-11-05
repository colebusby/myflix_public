source 'https://rubygems.org'

gem 'rails', '4.0.0'
gem 'haml-rails'
gem 'bootstrap-sass', '~> 2.2.1.0'
gem 'sass-rails',   '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.0.3'
gem 'bcrypt-ruby', '= 3.0.1'
gem 'bootstrap_form'
gem 'fabrication'
gem 'faker'
gem 'figaro'
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'carrierwave'
gem 'mini_magick', '3.4.0'
gem "fog", "~> 1.3.1"
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem 'draper'
ruby '1.9.3'

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'unicorn'
end

gem 'jquery-rails'

group :development do
  gem 'sqlite3'
  gem 'letter_opener'
end

group :test, :development do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'capybara-email'
  gem 'vcr'
  gem 'webmock', '1.11.0'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
end