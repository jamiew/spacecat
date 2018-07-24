![Our noble hero](http://i0.kym-cdn.com/entries/icons/facebook/000/003/458/space_arp.jpg "What you see when you die")

**Spacecat** is a [Hubot](https://hubot.github.com/)-based Slack bot used by the teams at @vhxtv, @vimeo and @kickstarter

## Active Scripts

* `karma` script -- "username++"/"username--" and "spacecat leaderboard"
* `stock` script -- "spacecat stock TSLA"
* `urban` script -- "spacecat define capitalism"
* `dice` script -- "spacecat roll 1d20"
* "developer excuse", "designer excuse"
* "deal with it"
* "it's a trap"
* [hubot-ipfs](https://github.com/jamiew/hubot-ipfs) -- "pin QmIPFSHASH..."; "ipfs help" for all commands

It used to do other things, but now it does fewer things

## Configuration

* `HUBOT_SLACK_TOKEN`
* `HUBOT_HEROKU_KEEPALIVE` if using on Heroku. Make sure to setup the sleek/wake scheduler, see their docs

## Running

```
HUBOT_SLACK_TOKEN=xxxx bin/hubot
```

Or use `foreman` to run the Procfile

## Contributors

* [@jamiew](https://github.com/jamiew)
* [@charlietran](https://github.com/charlietran)
* your name here
* pull requests welcome

## License

MIT

