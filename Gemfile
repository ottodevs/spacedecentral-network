#ruby=ruby-2.4.0
#ruby-gemset=spacedecentral-network

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = '#{repo_name}/#{repo_name}' unless repo_name.include?('/')
  'https://github.com/#{repo_name}.git'
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.5'
gem 'mysql2', '0.4.5'
gem 'sass-rails', '~> 5.0', '>= 5.0.8'
gem 'uglifier', '>= 1.3.0'
gem 'therubyracer', platforms: :ruby
gem 'non-stupid-digest-assets'

gem 'jquery-rails', '>= 4.3.1'
gem 'jquery-ui-rails', '>= 6.0.1'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'angularjs-rails'
gem 'momentjs-rails', '>= 2.17.1'
gem 'jbuilder', '~> 2.5'
gem 'haml-rails', '>= 1.0.0'

gem 'inline_svg'
gem 'rmagick'
gem "cocoon"

gem 'mark_it_zero' , '>= 0.3.2' #, git: 'git@github.com:khacluan/mark_it_zero.git', tag: 'v0.3.3'
gem 'redcarpet'

gem 'turbolinks', '~> 5'
gem 'paperclip', '~> 5.2.0'
gem 'remotipart', '~> 1.2'
gem 'devise', '>= 4.7.0'
gem 'sidekiq'
gem 'redis', '~> 3.3.5'
gem 'redis-rails', '>= 5.0.2'
gem 'friendly_id', '>= 5.2.3'

gem 'aws-sdk', '= 2.10.1'
gem 'omniauth-google-oauth2'
gem 'signet'
gem 'google-api-client'

gem 'passenger', '5.1.2'
gem 'exception_notification', '>= 4.4.0'

gem 'whenever', :require => false

gem 'figaro'
gem 'jquery-fileupload-rails', '>= 0.4.7'
gem 'draper', '>= 3.1.0'
gem 'aasm'
gem 'kaminari', '>= 1.1.1'
gem 'high_voltage', '~> 3.0.0'
gem 'jquery-slick-rails', '>= 1.8.1'

gem 'google-analytics-rails', '1.1.1'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'capybara'
  gem 'selenium-webdriver', '2.53.4'
  gem 'puma'
  # gem 'capybara-webkit'
end

group :development do
  gem 'capistrano', '~> 3.6'
  gem 'capistrano-rvm'
  # gem 'rvm1-capistrano3'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'capistrano-sidekiq'
  gem 'capistrano-rails', '~> 1.2'
  gem 'web-console', '>= 3.5.1'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

