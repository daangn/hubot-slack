# http://pgarbe.github.io/blog/2015/03/24/how-to-run-hubot-in-docker-on-aws-ec2-container-services-part-1/
# https://github.com/pgarbe/tatsu-hubot/blob/master/Dockerfile
FROM node:0.12.7

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

ADD hubot-scripts.json /hubot/
ADD external-scripts.json /hubot/
ADD scripts/appannie.coffee /hubot/scripts/

CMD bin/hubot -a slack
