# README

## What is done

### Backend

- Rails 6 + PostgreSQL + Redis project

- `Article` and `Story` entities with many to many relation

- JSON Articles/Stories search API 
Reference in Swagger https://app.swaggerhub.com/apis-docs/l94618/blog_post_api_refence/1.0.0#/

- Articles HTML controller on `/` root URL

- Action Cable for getting live update of articles
Every create/update/destroy action of `Story` and `Article` will follow articles page update
So sample steps to check it:
  1. Open `/` articles search
  2. Open rails console and find some story or article object:
  3. Find this object on UI
  4. Update object in console
  ```ruby
  a = Article.first
  a.name += '!'
  a.save
  ```
  5. You will see how thi object will be updated in browser

- Rubocop code checker
To start it locally run:
```bash
docker-compose exec app rubocop .
```

### Frontend

- Webpack assets compiler

- ReactJS + MobX components

- ESLint
To start it locally run:
```bash
docker-compose exec app node-modules/.bin/eslint ./**/*.js
docker-compose exec app node-modules/.bin/eslint ./**/*.jsx
```

### Deployment

- Docker for development mode
To start just run:
```bash
docker-compose build
docker-compose up -d
```
and open `http://localhost:3000` in browser

- Heroku for production mode
https://blogpostlxkuz.herokuapp.com/



