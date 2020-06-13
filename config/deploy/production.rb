server '188.120.228.227', roles: %i[web app db], primary: true
set :user, 'helphub'
set :deploy_to, "/home/#{fetch(:user)}/projects/#{fetch(:application)}"

set :rails_env, 'production'
set :branch, 'master'

set :ssh_options, forward_agent: true, user: fetch(:user)

set :linked_files,
    %w[
      config/database.yml
      config/secrets.yml
      config/puma.rb
      .env
    ]

set :linked_dirs,
%w[
  log
  tmp/pids
  tmp/cache
  tmp/sockets
  public/system
  public/packs
  storage
  postgres-data
]

# after 'deploy:finished', :docker_restart

# namespace :deploy do
#   after :finished, :docker_restart do
#     on roles(:app) do
#       within current_path do
#         execute :sudo, 'docker-compose', 'stop'
#         execute :sudo, 'docker-compose', 'up', '-d'  
#       end
#     end
#   end
# end
