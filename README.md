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

- Docker for development mode
To start just run:
```bash
docker-compose build
docker-compose up -d
```
and open `http://localhost:3000` in browser

- Heroku for production mode
https://helphubstaging.herokuapp.com/



