# Hubot Slack - N42 Corp

## Build

  docker build -t n42corp/hubot-slack .

## Run

  docker run -d \
    --name hubot-slack \
    -e HUBOT_SLACK_TOKEN=xxx \
    -e ANNIE_TOKEN=xxx \
    -e ANNIE_ACCOUNT_ID_IOS=xxx \
    -e ANNIE_ACCOUNT_ID_ANDROID=xxx \
    -e ANNIE_APP_ID_IOS=xxx \
    -e ANNIE_APP_ID_ANDROID=xxx \
    -e ANNIE_COUNTRIES=KR \
    n42corp/hubot-slack
