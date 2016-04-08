#!/bin/bash

node_modules/forever/bin/forever start -c coffee node_modules/.bin/hubot --adapter slack
node_modules/forever/bin/forever --fifo logs 0
