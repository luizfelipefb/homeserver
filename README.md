# Homeserver

Docker Compose stacks for a self-hosted home server, managed through a Makefile.

Edit the `.env` file with the proper values

Run `make <target>` to create the desired containers or `make all` to deploy everything

## .env file

Create an `.env` file in the repository root with the following values (the Makefile passes it with `--env-file .env`; `UID` is read-only in bash/zsh, so don't `source` this file):

```shell
# general configuration
TIMEZONE=
UID=
GID=
DOCKER_GID=

# paths to config directory, transcode, media and download
CONFIG=
DOWNLOADS=
MEDIA=
TRANSCODE=

# domain name for forwarding
DOMAIN=
HOST_IP=

# beszel
BESZEL_KEY=
BESZEL_TOKEN=

# influxdb
INFLUXDB_ADMIN_PASSWORD=
INFLUXDB_ADMIN_USERNAME=
INFLUXDB_TOKEN=

# karakeep
KARAKEEP_SECRET=

# plex
PLEX_CLAIM=

# speedtest
SPEEDTEST_APIKEY=

# vaultwarden
VAULTWARDEN_ADMIN_TOKEN=

# whatsupdocker (wud)
WUD_ADMIN_USER=
WUD_ADMIN_PASSWORD=

# cloudflare
CLOUDFLARE_TUNNEL_TOKEN=
CLOUDFLARE_API_KEY=
CLOUDFLARE_EMAIL=

# tinyauth
TINYAUTH_USERS=

# loki
LOKI_PASSWORD=

# restic (backrest)
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
RESTIC_PASSWORD=
```

Services marked ✓ in the host network column run with `network_mode: host`, so the host and container ports are the same (the application's own listening port). All other services use the default bridge network. `N/A` means no port is exposed.

## Applications

`make applications`

| service     | description              | host port | container port | host network |
| ----------- | ------------------------ | --------- | -------------- | ------------ |
| backrest    | backup manager           | 9898      | 9898           |              |
| homepage    | application dashboard    | 3001      | 3000           |              |
| karakeep    | bookmarks manager        | 3002      | 3000           |              |
| pocketbase  | open source db in 1 file | 8093      | 8090           |              |
| vaultwarden | password manager         | 8087      | 80             |              |

## Home Automation

`make home-automation`

| service       | description                                                                                         | host port | container port | host network |
| ------------- | --------------------------------------------------------------------------------------------------- | --------- | -------------- | ------------ |
| homeassistant | home automation software that acts as a central hub for managing and controlling smart home devices | 8123      | 8123           | ✓            |
| nodered       | used as trigger and push for home assistant devices                                                 | 1880      | 1880           | ✓            |
| scrypted      | home automation server with a focus on camera streaming                                             | 10443     | 10443          | ✓            |

## Media Server

`make media-server`

| service        | description                             | host port                    | container port               | host network |
| -------------- | --------------------------------------- | ---------------------------- | ---------------------------- | ------------ |
| audiobookshelf | audiobook and podcast server            | 13378                        | 80                           |              |
| bazarr         | subtitles manager                       | 6767                         | 6767                         |              |
| plex           | media server                            | 32400                        | 32400                        |              |
| prowlarr       | indexer manager                         | 9696                         | 9696                         |              |
| qbittorrent    | torrent downloader                      | 8090, 59999 (tcp/udp, peers) | 8090, 59999 (tcp/udp, peers) |              |
| radarr         | movies PVR                              | 7878                         | 7878                         |              |
| seerr          | content requester                       | 5055                         | 5055                         |              |
| sonarr         | tv shows PVR                            | 8989                         | 8989                         |              |
| tautulli       | monitor and analytics for plex/jellyfin | 8181                         | 8181                         |              |

## System Monitoring

`make system-monitor`

| service      | description                                     | host port | container port | host network |
| ------------ | ----------------------------------------------- | --------- | -------------- | ------------ |
| beszel       | lightweight server monitoring                   | 8091      | 8090           |              |
| beszel-agent | beszel agent                                    | 45876     | 45876          |              |
| dozzle       | real-time docker log viewer                     | 8092      | 8080           |              |
| grafana      | analytics & monitoring web interface            | 3000      | 3000           |              |
| influxdb     | time series database                            | 8086      | 8086           |              |
| loki         | log aggregation system                          | 3100      | 3100           |              |
| scrutiny     | S.M.A.R.T. disk monitoring                      | 8085      | 8080           |              |
| telegraf     | server agent for collecting & reporting metrics | N/A       | N/A            |              |

## System Utils

`make system-utils`

| service           | description                                                          | host port   | container port | host network |
| ----------------- | -------------------------------------------------------------------- | ----------- | -------------- | ------------ |
| adguard           | network wide ad blocking, dns and dhcp server                        | 8053        | 8053           | ✓            |
| cloudflare-ddns   | client used to update dynamic DNS entries for accounts               | N/A         | N/A            |              |
| cloudflare-tunnel | cloudflare tunnel for secure remote access                           | N/A         | N/A            | ✓            |
| postgres          | db used by speedtest-tracker (no port exposed)                       | N/A         | N/A            |              |
| speedtest-tracker | wan speed test tracker                                               | 8083        | 80             |              |
| tinyauth          | secure your apps with a login screen                                 | 3003        | 3003           | ✓            |
| traefik           | HTTP reverse proxy and load balancer                                 | 80/443/8080 | 80/443/8080    | ✓            |
| wud               | whatsupdocker, update the running version of your containerized apps | 3004        | 3000           |              |
