FROM alpine:latest@sha256:8c03bb07a531c53ad7d0f6e7041b64d81f99c6e493cb39abba56d956b40eacbc

MAINTAINER joshhsoj1902

RUN apk add --no-cache rsync openssh

ADD rsyncd.conf /etc/rsyncd.conf

RUN mkdir /srv/games \
 && touch /var/log/rsyncd.log \
 && (crontab -u root -l; echo "3 45 * * * /usr/bin/rsync --archive --compress --update --verbose --delete sync://rsync.opengamepanel.org/ogp_game_installer/ /srv/games" ) \
  | crontab -u root -

VOLUME ["games:/srv/games/"]

#currently this is meant to be ran as 2 containers, and it doesn't auto download the games on first launch.
#I should script this instead
CMD ["crond", "-f"]
CMD ["rsync", "--no-detach", "--daemon"]
