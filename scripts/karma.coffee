# Description:
#   Tell people hubot's new name if they use the old one
#
# Commands:
#   @username++ - Add a karma point for said user
#   hubot leaderboard - Show karma points for all users. Also understands "scoreboard"
#
module.exports = (robot) ->
  robot.brain.data.karma ?= {}


  # listen for @username++ or @username-- (and now also just "username++/--")
  robot.hear /(@)?[a-z0-9]*(?:[\+]{2}|[\-]{2})/i, (msg) ->

    # store @username(++|--), convert to string and normalize
    user = msg.match[0].toLowerCase()

    # store @username w/o increment
    username = user.replace(/(?:[\+]{2}|[\-]{2})/, '')

    # strip @ symbol
    username = username.replace(/^@/,'')

    # store discretely for each month
    date = new Date()
    date_key = date.getFullYear() + '-' + date.getMonth()
    username_key = username + '_' + date_key

    # don't let losers vote for themselves
    if username == msg.message.user.mention_name || username == msg.message.user.name
      response = "Only losers vote for themselves"
    else if !username? || username == '' || username == ' ' || username[username.length - 1] == ' '
      # response = "Username is blank, aborting"
      response = undefined
    else
      # month_name = date.toLocaleString('en-us', { month: "long" })
      month_names = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
      month_name = month_names[date.getMonth()]

      # store increment value
      increment = parseInt(user[user.length-1] + 1)
      robot.brain.data.karma[username_key] ?= 0
      score = robot.brain.data.karma[username_key] += increment

      response = "I've updated #{username} to #{score} for #{month_name}!"

    if !!response
      msg.send response


  # leaderboard, output as /code so we don't notify everyone everytime
  robot.respond /(leaderboard|scoreboard)/i, (msg) ->
    list = ''
    counter = 0
    for user of robot.brain.data.karma
      list_item = ''
      sanitized_user = user.replace(/^@/,'')

      if counter < Object.keys(robot.brain.data.karma).length - 1
        list_item = "#{sanitized_user}: #{robot.brain.data.karma[user]}\n"
      else
        list_item = "#{sanitized_user}: #{robot.brain.data.karma[user]}"

      counter++

      list = list + list_item

    msg.send "Karma:\n#{list}"
