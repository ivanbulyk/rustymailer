use rustymailer::configuration::get_configuration;
use rustymailer::startup::run;
use rustymailer::telemetry::{get_subscriber, init_subscriber};
use sqlx::PgPool;
use std::net::TcpListener;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let subscriber = get_subscriber("rustymailer".into(), "info".into(), std::io::stdout);
    init_subscriber(subscriber);
    let configuration = get_configuration().expect("failed to read configuration");
    let connection_pull = PgPool::connect(&configuration.database.connection_string())
        .await
        .expect("failed to connect Postgres");
    let address = format!("127.0.0.1:{}", configuration.application_port);
    let listener = TcpListener::bind(address)?;
    run(listener, connection_pull)?.await?;
    Ok(())
}
