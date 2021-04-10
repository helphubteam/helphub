![logo_help_hub](https://user-images.githubusercontent.com/1070568/114272133-444cf780-9a2e-11eb-86de-6cf69ed1f5ca.png)

# README

### How To Setup Locally

```bash
cp .env.example .env
docker-compose build
docker-compose run --rm app bash -c "bundle install && bundle exec rails db:create db:migrate db:seed && yarn --check-files"
docker-compose up -d
```

### Deploy 

Code will lbe deployed autmatically after push into `master` branch. See github actions.

### Run Tests

CI will start automatically on every code update. See github actions.

For local testing:
```bash
docker-compose run app bash -c 'RAILS_ENV=test rspec spec'
```

### Run Linter

```bash
docker-compose run app bash -c 'rubocop'
```
