FROM alpine

MAINTAINER joshhsoj1902

RUN apk add --no-cache rsync openssh

ADD rsyncd.conf /etc/rsyncd.conf

RUN mkdir /srv/games \
 && touch /var/log/rsyncd.log \
 && (crontab -u root -l; echo "3 45 * * * /usr/bin/rsync --archive --compress --update --verbose --delete rsync://rsync.opengamepanel.org/ogp_game_installer/ /srv/games" ) \
  | crontab -u root -

VOLUME ["games:/srv/games/"]

CMD ["tail", "-f", "/var/log/rsyncd.log"]
CMD ["rsync", "--no-detach", "--daemon"]
