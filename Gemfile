source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.4'
# Use sqlite3 as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.4'
gem 'activerecord-import'
# Use Json Web Token (JWT) for token based authentication
gem 'jwt'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'activerecord-postgis-adapter'
gem 'rgeo'
gem 'rgeo-activerecord'
gem 'rgeo-geojson'

gem 'devise'
gem 'devise_invitable', '~> 2.0.0'
gem 'pundit'

gem 'simple_form'
gem 'cocoon'
gem 'bootstrap-glyphicons'

gem 'stateful_enum'

gem 'kaminari'
gem 'bootstrap4-kaminari-views'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'rake'
gem 'fcm'

gem 'caxlsx'
gem 'caxlsx_rails'

gem 'sentry-ruby'
gem 'sentry-rails'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap',  require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'rspec-default_http_header'
  gem 'factory_bot'
  gem 'faker'
  gem 'timecop'
  gem 'database_cleaner-active_record'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'rubocop'
  gem 'letter_opener'
  gem 'letter_opener_web'

  gem 'capistrano', '~> 3.11'
  gem 'ed25519', '>= 1.2', '< 2.0'
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'

  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem 'fuubar'
  gem 'simplecov', '~> 0.19.0', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'rails-settings-cached', '~> 2.2'

gem 'pry', '~> 0.13.1'

gem 'pry-byebug', '~> 3.9'
