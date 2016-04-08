# Hubot Slack - N42 Corp

## Build

```shell
docker build -t n42corp/hubot-slack .
```

## Run

```shell
docker run -d \
  --name hubot-slack \
  -e HUBOT_SLACK_TOKEN=xxx \
  -e HUBOT_SLACK_EXIT_ON_DISCONNECT=true \
  -e ANNIE_TOKEN=xxx \
  -e ANNIE_ACCOUNT_ID_IOS=xxx \
  -e ANNIE_ACCOUNT_ID_ANDROID=xxx \
  -e ANNIE_APP_ID_IOS=xxx \
  -e ANNIE_APP_ID_ANDROID=xxx \
  -e ANNIE_COUNTRIES=KR \
  n42corp/hubot-slack
```

## Usage

```
snow help
```

채널에 초대해서 말 걸었을때만 응답 함. 다이렉트 메시지에는 응답하지 않음.
