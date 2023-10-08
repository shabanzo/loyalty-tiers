# Loyalty Tiers

## Documentation: Requirements & System Design

[Miro Board](https://miro.com/app/board/uXjVNe9FqYw=/?share_link_id=553528671218)

## Getting Started

### Using Docker

1. Make sure you have Docker installed on your machine.
2. Run the backend application inside `api` directory using:

```
docker-compose up -d api sidekiq cron
```

3. Setup database for development by entering the container using:

```
docker exec -it api sh
```

then execute:

```
rake db:prepare
```

4. Build the frontend image, inside `client-react` directory using:

```
docker build -t client-react .
```

5. Run the frontend application, inside `client-react` directory using:

```
docker run --name client-react -p 3000:3000 client-react
```

6. Now you can access the frontend:

```
http://localhost:3000/customers/:customer_id/loyalty_stats
http://localhost:3000/customers/:customer_id/completed_stats
```

## Testing

### Using Docker

#### Run tests for the backend

1. Make sure you have Docker installed on your machine.
2. Go inside `api` directory and make sure `api` container is running:

```
docker-compose up -d api
```

3. Enter the container with:

```
docker exec -it api sh
```

4. Run tests with:

```
bundle exec rspec
```

#### Run tests for the frontend

1. Make sure you have Docker installed on your machine.
2. Go inside `client-react` directory and enter the run this:

```
docker run -it --rm api-api sh
```

3. Then run:

```
npm test
```
