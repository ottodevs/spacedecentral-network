#ruby=ruby-2.4.0
#ruby-gemset=spacedecentral-network

source 'https://rubygems.org'

ruby '2.4.0'

git_source(:github) do |repo_name|
  repo_name = '#{repo_name}/#{repo_name}' unless repo_name.include?('/')
  'https://github.com/#{repo_name}.git'
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
gem 'mysql2', '0.4.5'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'therubyracer', platforms: :ruby
gem 'non-stupid-digest-assets'

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'angularjs-rails'
gem 'momentjs-rails'
gem 'jbuilder', '~> 2.5'
gem 'haml-rails'

gem 'inline_svg'
gem 'rmagick'
gem "cocoon"

gem 'mark_it_zero' #, git: 'git@github.com:khacluan/mark_it_zero.git', tag: 'v0.3.3'
gem 'redcarpet'

gem 'turbolinks', '~> 5'
gem 'paperclip', '~> 5.2.0'
gem 'remotipart', '~> 1.2'
gem 'devise'
gem 'sidekiq'
gem 'redis', '~> 3.3.5'
gem 'redis-rails'
gem 'friendly_id'

gem 'aws-sdk', '= 2.10.1'
gem 'omniauth-google-oauth2'
gem 'signet'
gem 'google-api-client'

gem 'passenger', '5.1.2'
gem 'exception_notification'

gem 'whenever', :require => false

gem 'figaro'
gem 'jquery-fileupload-rails'
gem 'draper'
gem 'aasm'
gem 'kaminari'
gem 'high_voltage', '~> 3.0.0'
gem 'jquery-slick-rails'

gem 'google-analytics-rails', '1.1.1'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  gem 'better_errors'
  gem 'byebug', platform: :mri
  gem 'capybara-email'
  gem 'database_cleaner'
  gem 'puma'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
end

group :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'guard-rspec', require: false
  gem 'selenium-webdriver', '2.53.4'
end

group :development do
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano-rvm'
  gem 'capistrano-sidekiq'
  gem 'capistrano', '~> 3.6'
  gem 'letter_opener_web', '~> 1.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring'
  gem 'web-console', '>= 3.3.0'
end
