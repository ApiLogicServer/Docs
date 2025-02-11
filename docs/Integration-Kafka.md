!!! pied-piper ":bulb: TL;DR - Kafka Integration: Async Messaging"

    APIs are useful to application integration, but do not deal with the reality that the receiving system might be down.

    Message Brokers like Kafka address this with guaranteed ***async delivery*** of messages.  The Broker stores the message, delivering it (possibly later) when the the receiver is up.

    Message Brokers also support multi-cast: you ***publish*** a message to a "topic", and other systems ***subscribe***.  This is often casually described as "pub/sub".

&nbsp;

## Procedure

&nbsp;

To enable Kafka:

1. In `conf/config.py`, find and comment out: `KAFKA_PRODUCER = None  # comment out to enable Kafka`

2. Update your `etc/conf` to include the lines shown below (e.g., `sudo nano /etc/hosts`).

```
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##

# for kafka
127.0.0.1       broker1
::1             localhost
255.255.255.255 broadcasthost
::1             localhost

127.0.0.1       localhost
# Added by Docker Desktop
# To allow the same kube context to work on the host and the container:
127.0.0.1 kubernetes.docker.internal
# End of section
```
3. If you already created the container, you can

    1. Start it in the Docker Desktop, and
    2. **Skip the next 2 steps;** otherwise...

4. Start Kafka: in a terminal window: `docker compose -f integration/kafka/dockercompose_start_kafka.yml up`

5. Create topic: in Docker: `kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 3  --topic order_shipping`

Here some useful Kafka commands:

```bash
# use Docker Desktop > exec, or docker exec -it broker1 bash 
# in docker terminal: set prompt, delete, create, monnitor topic, list all topics
# to clear topic, delete and create

PS1="kafka > "  # set prompt

kafka-topics.sh --bootstrap-server localhost:9092 --topic order_shipping --delete

kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 3  --topic order_shipping

kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic order_shipping --from-beginning

kafka-topics.sh --bootstrap-server localhost:9092 --list
```
