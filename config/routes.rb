require 'sidekiq/web'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get 'products', to: 'products#index'
  post 'process_file', to: 'products#process_file'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["ADMIN_USER"])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["ADMIN_PASSWORD"]))
  end
  # Basic HTTP authentication for Sidekiq Web UI
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    secure_compare = ActiveSupport::SecurityUtils.method(:secure_compare)
    username_correct = secure_compare.call(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV['ADMIN_USER']))
    password_correct = secure_compare.call(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV['ADMIN_PASSWORD']))
    username_correct & password_correct
  end

  mount Sidekiq::Web => '/sidekiq' # mount Sidekiq::Web in Rails app
end
