!!! pied-piper ":bulb: TL;DR - Postman is a Docker Alternative"

    Docker is familiar to most developers as a way to create, run and manage containers.  GenAI-Logic runs well with Docker, and is used in most of our examples.

    Many developers use Postman (for more information, [click here](https://www.postman.com){:target="_blank" rel="noopener"}), which has the advantage that it's free to large enterprises.  GenAI-Logic also runs well with Postman, as described below.
    
      * We gathered this information by asking Claude to migrate `samples/demo_customs_clvs` to Podman, which not onlu worked flawlessly, but created the information below.

&nbsp;

# Podman Setup for demo_customs_clvs_podman

This project uses Podman instead of Docker. These are the one-time setup steps required on a Mac
with no Docker installed.

---

## Prerequisites

- macOS with [Homebrew](https://brew.sh) installed
- Python 3.x with pip available

---

## One-Time Installation

### 1. Install Podman

```bash
brew install podman
```

### 2. Initialize the Podman Linux VM

Podman on Mac runs containers inside a lightweight Linux VM. Initialize it once:

```bash
podman machine init
```

This downloads ~800 MB.

### 3. Start the VM

```bash
podman machine start
```

The VM runs until you stop it or reboot. **After every reboot you must run `podman machine start`
before starting Kafka** — unless you install Podman Desktop (step 4), which auto-starts the VM at login.

### 4. Install Podman Desktop (optional but recommended)

A GUI app (~202 MB) for browsing containers, images, and logs. **Recommended** because it
auto-starts the VM at login, eliminating the manual `podman machine start` step after reboots.

```bash
brew install --cask podman-desktop
```

Installs to `/Applications/Podman Desktop.app`.

**First-launch prompts:** Podman Desktop will offer to install several built-in extension binaries
(kubectl, Kind, Compose). For this project (Kafka only) you can skip them all. If you do install
kubectl, it adds ~55 MB to `/usr/local/bin/kubectl` and a duplicate copy under
`~/.local/share/containers/podman-desktop/extensions-storage/`. Kind and Compose are not needed.

### 5. Install the Compose Plugin

Podman uses `docker-compose` as its compose provider:

```bash
brew install docker-compose
```

Wire it to Podman (one-time):

```bash
mkdir -p ~/.docker
echo '{"cliPluginsExtraDirs":["/opt/homebrew/lib/docker/cli-plugins"]}' > ~/.docker/config.json
```

---

## Start Kafka

Run from the project root. This is idempotent — safe to re-run if Kafka is already running.

```bash
podman compose -f integration/kafka/dockercompose_start_kafka.yml up -d
```

Confirm the broker is running:

```bash
podman ps
# Should show broker1 running on ports 9092-9093
```

---

## Stop Kafka

```bash
podman compose -f integration/kafka/dockercompose_start_kafka.yml down
```

---

## Reset Topics (between test runs)

```bash
bash integration/kafka/isdc_reset.sh
```

This deletes and recreates the `isdc` and `isdc_processed` topics so consumer offsets start fresh.

To also clear the database tables:

```bash
bash integration/kafka/isdc_reset_db.sh
```

---

## Useful Inspection Commands

```bash
# List topics
podman exec broker1 /opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --list

# Read a topic from the beginning (increment group number each time to re-read)
podman exec broker1 /opt/kafka/bin/kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 --topic isdc --from-beginning --group fresh-group-1
```

---

## Enable Live Kafka in the App

In `config/default.env`, set:

```
KAFKA_SERVER = localhost:9092
KAFKA_CONSUMER_GROUP = customs_demo-group1
```

Without these, the app runs in debug/fallback mode only (no Kafka consumer activated).

---

## Run the Test Gate

Requires the server running on port 5656 and Kafka running.

```bash
bash docs/requirements/customs_demo/test_gate.sh
```

The gate tests both the debug path (no Kafka needed) and the live Kafka path.
To require the Kafka phase to pass:

```bash
KAFKA_PHASE_REQUIRED=true bash docs/requirements/customs_demo/test_gate.sh
```

---

## Disk Layout (where things are stored on Mac)

| What | Mac path |
|---|---|
| Podman CLI binaries | `/opt/homebrew/Cellar/podman/5.8.2/` (~92 MB) |
| VM disk image | `~/.local/share/containers/podman/machine/applehv/podman-machine-default-arm64.raw` (~54 GB allocated, ~4 GB used) |
| Container images (e.g. Kafka) | Inside the VM at `/var/home/core/.local/share/containers/storage` — not directly visible on Mac |
| Podman machine config | `~/.local/share/containers/podman/machine/` |

The bulk of disk usage is the VM `.raw` file. The Kafka image (~120 MB download) lives inside it.

---

## Notes

- **VM state**: The Podman VM persists between reboots but must be started with `podman machine start`.
  The Kafka container also stops when the VM stops — re-run `podman compose ... up -d` after each reboot.
- **compose file name**: The file is named `dockercompose_start_kafka.yml` (legacy name) but is fully
  Podman-compatible. The `podman compose` command invokes `docker-compose` as a plugin transparently.
- **rootless mode**: The VM runs in rootless mode by default. Port 9092/9093 are forwarded to the host
  and accessible from the Python server on localhost.
