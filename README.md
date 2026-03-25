# Server

Edit the `.env` file with the proper values

Run `make <target>` to create the desired containers or `make all` to deploy everything

## .env file

Create an .env file with the following values:

```shell
# user and groups id
TIMEZONE=
UID=
GID=
DOCKER_GID=

# paths to config directory, transcode, media and download
CONFIG=
TRANSCODE=
MEDIA=
DOWNLOADS=

# domain name for forwarding
DOMAIN=
HOST_IP=

# apikeys
PLEX_CLAIM=
WATCHTOWER_APIKEY=
INFLUXDB_TOKEN=
KARAKEEP_SECRET=
SPEEDTEST_APIKEY=
BESZEL_KEY=

# cloudflare
CLOUDFLARE_TUNNEL_TOKEN=
CLOUDFLARE_API_KEY=
CLOUDFLARE_EMAIL=

# tinyauth
TINYAUTH_USERS=

# loki
LOKI_PASSWORD=
```

## Applications

`make applications`

| service  | description           | port |
| -------- | --------------------- | ---- |
| homepage | application dashboard | 3001 |
| karakeep | bookmarks manager     | 3002 |

## Home Automation

`make home-automation`

| service       | description                                                                                         | port  |
| ------------- | --------------------------------------------------------------------------------------------------- | ----- |
| homeassistant | home automation software that acts as a central hub for managing and controlling smart home devices | 8123  |
| nodered       | used as trigger and push for home assistant devices                                                 | 1880  |
| scrypted      | home automation server with a focus on camera streaming                                             | 10443 |

## Media Server

`make media-server`

| service          | description                             | port  |
| ---------------- | --------------------------------------- | ----- |
| audiobookshelf   | audiobook and podcast server            | 13378 |
| bazarr           | subtitles manager                       | 6767  |
| jellyfin         | media server                            | 8096  |
| plex             | media server                            | 32400 |
| prowlarr         | indexer manager                         | 9696  |
| qbittorrent      | torrent downloader                      | 8090  |
| radarr           | movies PVR                              | 7878  |
| seerr            | content requester                       | 5055  |
| sonarr           | tv shows PVR                            | 8989  |
| tautulli         | monitor and analytics for plex/jellyfin | 8181  |

## System Monitoring

`make system-monitor`

| service      | description                                     | port  |
| ------------ | ----------------------------------------------- | ----- |
| beszel       | lightweight server monitoring                   | 8091  |
| beszel-agent | beszel agent                                    | 45876 |
| dozzle       | real-time docker log viewer                     | 8092  |
| grafana      | analytics & monitoring web interface            | 3000  |
| influxdb     | time series database                            | 8086  |
| loki         | log aggregation system                          | 3100  |
| scrutiny     | S.M.A.R.T. disk monitoring                      | 8085  |
| telegraf     | server agent for collecting & reporting metrics | N/A   |

## System Utils

`make system-utils`

| service           | description                                            | port        |
| ----------------- | ------------------------------------------------------ | ----------- |
| cloudflare-ddns   | client used to update dynamic DNS entries for accounts | N/A         |
| cloudflare-tunnel | cloudflare tunnel for secure remote access             | N/A         |
| pihole            | network wide ad blocking, dns and dhcp server          | 8053        |
| portainer         | container management                                   | 9000/9443   |
| postgres          | db used by speedtest-tracker                           | N/A         |
| speedtest-tracker | wan speed test tracker                                 | 8083        |
| tinyauth          | secure your apps with a login screen                   | 3003        |
| traefik           | HTTP reverse proxy and load balancer                   | 80/443/8080 |
| watchtower        | update the running version of your containerized apps  | 8084        |

### Retention

After installing influxdb, run `make create-retention DUR=<duration>` to set the retention duration (ns|u|µ|ms|s|m|h|d|w) for the telegraf database
