![logo_help_hub](https://user-images.githubusercontent.com/1070568/114272133-444cf780-9a2e-11eb-86de-6cf69ed1f5ca.png)

# README

### How To Setup Locally

```bash
cp .env.example .env
docker-compose build
docker-compose run --rm app bash -c "bundle install && bundle exec rails db:create db:migrate db:seed && yarn --check-files"
docker-compose up -d
```

__WARNING__
There are a lot of issues and problems with running an application in Docker on a Macbook with an M1 chip. To avoid these errors better way to run an application in a virtual machine on clear Linux OS or use VPS with Linux and remote development.

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

### Run Automation Tests

```bash
docker-compose exec app xvfb-run -a bundle exec cucumber
```
To debug this you can try
1) Set breakpoints in the steps code:
```ruby
  binding.pry
```
2) Or take a screenshot:
```ruby  
  page.save_screenshot('/app/test.png')
```