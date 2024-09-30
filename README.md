# CONSUMER-API

### Dependencies Required

```
redis
sqlserver
rails v7.0.8.3
```

### To run the main app:

Rename .env.example to .env and set variables

```
$ mv /.env.example /.env
```

### First Time Setup Instructions

```
bundle install
rails db:create
rails db:migrate
```

### Starting Server
1. Run the development server with:

```bash
$ rails s -p 3001
```

API will be available at `http://localhost:3001/...` 

2. Run sidekiq

```bash
$ bundle exec sidekiq
```
Sidekiq manager: `http://localhost:3001/sidekiq`


3. Run the specs

```bash
$ rspec (Run all specs)
```

### Missing

1. Mongo DB Implementation - I've never worked with it and didn't have time to learn and implement.
