# README

### How To Setup Locally

```bash
cp ./env.sample ./.env
docker-compose build
docker-compose run --rm app bundle install && bundle exec rails db:create db:migrate db:seed
docker-compose up -d
```

### Deploy 

Code will lbe deployed autmatically after push into `master` branch. See github actions.

### Run Tests

CI will start automatically on every code update. See github actions.

For local testing:
```bash
docker-compose run --rm app bundle exec rspec spec
```
