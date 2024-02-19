FROM rust:1.76.0 as builder
WORKDIR /usr/src/rustymailer
COPY . .
ENV SQLX_OFFLINE true
RUN cargo install --path .

FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y extra-runtime-dependencies && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/cargo/bin/rustymailer /usr/local/bin/rustymailer
COPY configuration configuration
ENV APP_ENVIRONMENT production
CMD ["rustymailer"]