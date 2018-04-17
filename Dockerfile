FROM alpine:latest@sha256:7df6db5aa61ae9480f52f0b3a06a140ab98d427f86d8d5de0bedab9b8df6b1c0

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
