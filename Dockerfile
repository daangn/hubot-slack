# http://pgarbe.github.io/blog/2015/03/24/how-to-run-hubot-in-docker-on-aws-ec2-container-services-part-1/
# https://github.com/pgarbe/tatsu-hubot/blob/master/Dockerfile
# http://qiita.com/yo-iida/items/c69fe7b6afb2c082b822
# http://blog.deprode.net/post/90132315787/slack-hubot%E3%82%92vps%E3%81%A7%E5%8B%95%E3%81%8B%E3%81%99
# http://bitwave.showcase-tv.com/hubot%E3%81%A8%E6%88%AF%E3%82%8C%E3%81%A6%E3%81%BF%E3%82%8B-%E7%95%AA%E5%A4%96%E7%B7%A8-hubot%E3%82%92%E3%83%87%E3%83%BC%E3%83%A2%E3%83%B3%E5%8C%96%E3%81%99%E3%82%8B/
# http://bluecake.info/app/vps%E3%81%ABhubot%E3%82%92%E5%85%A5%E3%82%8C%E3%81%A6slack%E3%81%8B%E3%82%89%E5%8B%95%E3%81%8B%E3%81%97%E3%81%A6%E3%81%BF%E3%81%9F/
# http://qiita.com/GENM/items/0248433575580c9263b5
# https://renoirboulanger.com/blog/2015/05/run-nodejs-process-forever-within-docker-container/
FROM node:5.10.1

RUN npm install -g coffee-script yo generator-hubot

# Create hubot user
RUN useradd -d /hubot -m -s /bin/bash -U hubot

# Log in as hubot user and change directory
USER    hubot
WORKDIR /hubot

# Install hubot
RUN yo hubot --owner="seapy <seapy@n42corp.com>" --name="Snow" --description="You Know Nothing, Jon Snow" --defaults

RUN npm install hubot-slack --save
RUN npm install hubot-google-translate --save

# Install forever for daemon
RUN npm install forever --save

USER root
ADD hubot-scripts.json /hubot/
ADD external-scripts.json /hubot/
ADD scripts/n42-appannie.coffee /hubot/scripts/
ADD run.sh /hubot/
RUN chown hubot.hubot *

USER hubot
RUN chmod 700 run.sh

CMD ./run.sh
