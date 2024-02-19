FROM rust:1.76.0 AS builder

WORKDIR /app

COPY . .

ENV SQLX_OFFLINE true

RUN cargo build --release

FROM debian:bullseye-slim AS runtime

WORKDIR /app

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends openssl \
# Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/release/rustymailer rustymailer

COPY configuration configuration

ENV APP_ENVIRONMENT production

ENTRYPOINT ["./rustymailer"]