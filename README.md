# Loyalty Tiers

## Requirements & System Design

[Miro Board - My Doodle!](https://miro.com/app/board/uXjVNe9FqYw=/?share_link_id=553528671218)

## Getting Started

### Using Docker

1. Make sure you have Docker installed on your machine.
2. Run the backend application inside `api` directory using:

```
docker-compose up -d api sidekiq cron
```

3. Build the frontend image, inside `client-react` directory using:

```
docker build -t client-react .
```

4. Run the frontend application, inside `client-react` directory using:

```
docker run --name client-react -p 3000:3000 client-react
```

## Testing

### Using Docker

#### Run tests for the backend

1. Make sure you have Docker installed on your machine.
2. Go inside `api` directory and run the container with:

```
docker run -it --rm backend-backend /bin/sh
```

3. Run tests with:

```
bundle exec rspec
```
