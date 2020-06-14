# README

## What is done

### Backend

- Rails 6 + PostgreSQL + Redis project
- Action Cable
- Rubocop code checker
To start it locally run:
```bash
docker-compose exec app rubocop .
```

### Frontend

- Webpack assets compiler 
- ESLint
To start it locally run:
```bash
docker-compose exec app node-modules/.bin/eslint ./**/*.js
docker-compose exec app node-modules/.bin/eslint ./**/*.jsx
```

### Deployment

- prepare file `.env` with environment variables. for example see `.evn.example` 

- Docker for development mode
To start just run:
```bash
docker-compose build
docker-compose up -d
```
and open `http://localhost:3000` in browser

### Deploy 

after first deploy need create database 

```
 docker-compose run rake db:create
```

- Docker for development mode
To start run:
```bash
docker-compose run app cap production deploy
```

after then stop old container on server and build and run new container

TODO:

Need add task which stop old container (main problem, that container need to stop in previous release directory) and start new

and open `production url` in browser

- Heroku for production mode
https://helphubstaging.herokuapp.com/



