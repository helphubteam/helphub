server '188.120.228.227', roles: %i[web app db], primary: true
set :user, 'helphub'
set :deploy_to, "/home/#{fetch(:user)}/projects/#{fetch(:application)}"

set :rails_env, 'production'
set :branch, 'master'

set :ssh_options, forward_agent: true, user: fetch(:user)

set :linked_files,
    %w[
      .env
    ]

# namespace :deploy do
#   after :finished, :docker_restart do
#     on roles(:app) do
#       within current_path do
#         execute :sudo, 'docker-compose', 'down'
#         execute :sudo, 'docker', 'network', 'prune', '-f'
#         execute :sudo, 'docker-compose', 'up', '-d', '--force-recreate', '--build'
#       end
#     end
#   end
# end
