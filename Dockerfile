FROM rust:1.76.0 AS builder

WORKDIR /app

COPY . .

ENV SQLX_OFFLINE true

RUN cargo build --release

FROM debian:buster-slim AS runtime

WORKDIR /app

RUN apt-get update & apt-get install -y extra-runtime-dependencies & rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/release/rustymailer rustymailer

COPY configuration configuration

ENV APP_ENVIRONMENT production

ENTRYPOINT ["./rustymailer"]