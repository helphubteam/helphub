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

namespace :deploy do
  before :cleanup, :cleanup_permissions
    
  desc 'Set permissions on old releases before cleanup'
  task :cleanup_permissions do
    on release_roles :all do |host|
      releases = capture(:ls, '-x', releases_path).split
      if releases.count >= fetch(:keep_releases)
        info "Cleaning permissions on old releases"
        directories = (releases - releases.last(1))
        if directories.any?
          directories.each do |release|
            within releases_path.join(release) do
                execute :sudo, :chown, '-R', 'helphub:helphub', '.'
            end
          end
        else
          info t(:no_old_releases, host: host.to_s, keep_releases: fetch(:keep_releases))
        end
      end
    end
  end
  
  after :started, :docker_down do
    on roles(:app) do
      within current_path do
        execute :sudo, 'docker-compose', 'down'
        execute :sudo, 'docker', 'network', 'prune', '-f'
      end
    end
  end

  after :finished, :docker_up do
    on roles(:app) do
      within current_path do
        execute :sudo, 'rm', '-f', 'node_modules'
        execute :sudo, 'rm', '-f', 'yarn.lock'
        execute :sudo, 'docker-compose', 'up', '-d', '--force-recreate', '--build'
      end
    end
  end
end
