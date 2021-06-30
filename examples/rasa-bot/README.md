# Using Rasa X/Enterprise deployed in the same namespace as a configuration endpoint

You can use Rasa X/Enterprise as a configuration endpoint if it is deployed in the same Kubernetes cluster as Rasa Bot.

(Note: Rasa X/Enterprise will return credentials and endpoints with reference to cluster-internal service addresses, which are not accessible outside that namespace. Therefore you cannot use and externally running Rasa X/Enterprise instance as a configuration endpoint.)

To use this option, you need to:

1) Enable the option to use Rasa X/Enterprise as the config endpoint:

    ```yaml
    applicationSettings:
    rasaX:
        enabled: true
        # Rasa X service address
        # You can execute `kubectl -n namespace_where_rasa_x_is_deployed get svc` in order to see a list of services
        url: "http://rasa-rasa-x:5002"
        # Define if a runtime configuration should be pulled
        # from Rasa X/Enterprise
        useConfigEndpoint: true
    ```

2) Add all environment variables referred to by the credentials & endpoints pulled from Rasa X/Enterprise to your values.

Below is an example of a runtime configuration that is pulled from Rasa X/Enterprise. Note the environment variables that are expected to be available:

```yaml
models:
  url: ${RASA_MODEL_SERVER}
  token: ${RASA_X_TOKEN}
  wait_time_between_pulls: 10
tracker_store:
  type: sql
  dialect: postgresql
  url: rasa-x-postgresql
  port: 5432
  username: postgres
  password: ${DB_PASSWORD}
  db: ${DB_DATABASE}
  login_db: rasa
event_broker:
  type: pika
  url: rasa-x-rabbit
  username: user
  password: ${RABBITMQ_PASSWORD}
  port: 5672
  queues:
  - ${RABBITMQ_QUEUE}

action_endpoint:
  url: "http://rasa-bot-rasa-action-server/webhook"
  token:  ""
lock_store:
  type: "redis"
  url: rasa-x-redis-master
  port: 6379
  password: ${REDIS_PASSWORD}
  db: 1
cache:
  type: "redis"
  url: rasa-x-redis-master
  port: 6379
  password: ${REDIS_PASSWORD}
  db: 2
  key_prefix: "rasax_cache"
```

Therefore you would add the following to rasa-values.yaml:

```yaml
## Extra environment variables used in the Rasa X/Enterprise configuration
extraEnv:
 - name: RASA_MODEL_SERVER
   value: http://example.com/api/projects/default/models/tags/production
 - name: RASA_X_TOKEN
   valueFrom:
     secretKeyRef:
       name: rasa-x-rasa
       key: "rasaXToken"
 - name: "DB_PASSWORD"
   valueFrom:
     secretKeyRef:
       name: rasa-x-postgresql
       key: postgresql-password
 - name: "DB_DATABASE"
   value: "rasa_production"
 - name: "REDIS_PASSWORD"
   valueFrom:
     secretKeyRef:
       name: rasa-x-redis
       key: redis-password
 - name: "RABBITMQ_QUEUE"
   value: rasa_production_events
 - name: "RABBITMQ_PASSWORD"
   valueFrom:
     secretKeyRef:
       name: rasa-x-rabbit
       key: rabbitmq-password
```
