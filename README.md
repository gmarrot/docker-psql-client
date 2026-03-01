# PostgreSQL Client Images

Lightweight Docker images containing the PostgreSQL client (`psql`), based on Alpine Linux. Available in two variants: **client only** or **client + Nginx**.

## Available Variants

### Client Image (PostgreSQL client only)

Minimal image with only the PostgreSQL client for running `psql`, `pg_dump`, etc.

| Tag | PostgreSQL | Alpine | Description |
|-----|------------|--------|-------------|
| `15` | 15 | 3.22 | PostgreSQL 15 |
| `16` | 16 | 3.23 | PostgreSQL 16 |
| `17` | 17 | 3.23 | PostgreSQL 17 |
| `18` | 18 | 3.23 | PostgreSQL 18 |

### Nginx Image (PostgreSQL client + Nginx)

Image combining Nginx with the PostgreSQL client, suitable for scenarios where both Nginx and PostgreSQL tools are needed in the same container (reverse proxy, API gateways, etc.).

| Tag | PostgreSQL | Nginx | Alpine |
|-----|------------|-------|--------|
| `15-nginx` | 15 | 1.28 | 3.22 |
| `16-nginx` | 16 | 1.28 | 3.23 |
| `17-nginx` | 17 | 1.28 | 3.23 |
| `18-nginx` | 18 | 1.28 | 3.23 |

## Supported Platforms

- `linux/amd64`
- `linux/arm64`

## Usage

### Run an interactive shell with the PostgreSQL client

```bash
docker run -it --rm gmarrot/postgresql-client:18 /bin/ash
# Then inside the container:
psql -h <host> -U <user> -d <database>
```

### Run a psql command directly

```bash
docker run --rm gmarrot/postgresql-client:18 psql -h postgres.example.com -U myuser -d mydb -c "SELECT version();"
```

### pg_dump from a remote database

```bash
docker run --rm gmarrot/postgresql-client:18 pg_dump -h postgres.example.com -U myuser -d mydb > backup.sql
```

### Nginx image (main process: Nginx)

```bash
docker run -d --name nginx-pg gmarrot/postgresql-client:18-nginx
# Nginx runs in the foreground. The psql client is available inside the container if you exec into it.
```

## Docker with Environment Variables

You can pass connection parameters to the container using PostgreSQL's environment variables, which allows `psql` and other client tools to connect without specifying `-h`, `-U`, `-d` on the command line.

### Using `-e` flags

```bash
docker run -it --rm \
  -e PGHOST=postgres.example.com \
  -e PGPORT=5432 \
  -e PGDATABASE=mydb \
  -e PGUSER=myuser \
  -e PGPASSWORD=mypassword \
  gmarrot/postgresql-client:18 psql -c "SELECT version();"
```

### Using an env file

```bash
# .env file
PGHOST=postgres.example.com
PGPORT=5432
PGDATABASE=mydb
PGUSER=myuser
PGPASSWORD=mypassword

# Run with --env-file
docker run -it --rm --env-file .env gmarrot/postgresql-client:18 psql
```

### Connecting to a PostgreSQL container on the same Docker network

```bash
docker run -it --rm \
  --network my-app-network \
  -e PGHOST=postgres \
  -e PGDATABASE=appdb \
  -e PGUSER=appuser \
  -e PGPASSWORD=secret \
  gmarrot/postgresql-client:18 psql
```

### Supported PostgreSQL Environment Variables

| Variable | Description |
|----------|-------------|
| `PGHOST` | Database server hostname |
| `PGHOSTADDR` | IP address of the server (avoids DNS lookup) |
| `PGPORT` | Port number (default: 5432) |
| `PGDATABASE` | Database name |
| `PGUSER` | PostgreSQL username |
| `PGPASSWORD` | Password (*not recommended* for security; prefer `PGPASSFILE` or secrets) |
| `PGPASSFILE` | Path to `.pgpass` password file |
| `PGSSLMODE` | SSL mode: `disable`, `allow`, `prefer`, `require`, `verify-ca`, `verify-full` |
| `PGCONNECT_TIMEOUT` | Connection timeout in seconds |
| `PGCLIENTENCODING` | Client character encoding (e.g. `UTF8`) |
| `PGAPPNAME` | Application name shown in `pg_stat_activity` |
| `PGOPTIONS` | Additional connection options |
| `PGSERVICE` | Service name from `~/.pg_service.conf` |

For a complete list, see the [PostgreSQL libpq environment variables documentation](https://www.postgresql.org/docs/current/libpq-envars.html).

## Building from Source

The project uses [Docker Buildx Bake](https://docs.docker.com/build/bake/).

```bash
# Build all images
docker buildx bake

# Build client images only
docker buildx bake client

# Build nginx images only
docker buildx bake nginx
```

## Base Images

- **Client**: `dhi.io/alpine-base`
- **Nginx**: `dhi.io/nginx`

## License

MIT License. See [LICENSE](LICENSE) for details.
