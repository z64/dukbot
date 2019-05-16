# dukbot

Proof of concept illustrating a Crystal Discord bot with modifiable runtime
behavior via a hot-reloadable JavaScript file. Uses the embeddable Duktape
JS engine. Quack!

## Try it

1. Replace `Owner` uin64 value with your own ID
2. Run `shards build` to fetch dependencies and build to `bin/dukbot`
3. Set `DUKBOT_TOKEN` and run `bin/dukbot`
4. Run some commands, change the `bot.js` file, and run `!reload`
