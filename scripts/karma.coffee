# Description:
#   Enables giving precious, precious karma to other users, and tracks a leaderboard that resets each month.
#
# Commands:
#   @username++ - Add a karma for said user
#   @username-- - Remove karma for said user
#   hubot karma - Show karma points for all users. You can also use "scoreboard" or leaderboard"
#

dateKey = () ->
  date = new Date()
  date.getFullYear() + '-' + date.getMonth()

monthName = () ->
  # month_name = date.toLocaleString('en-us', { month: "long" })
  date = new Date()
  month_names = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  month_names[date.getMonth()]

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

    # don't let losers vote for themselves
    if username == msg.message.user.mention_name || username == msg.message.user.name
      response = "Only losers vote for themselves"
    else if !username? || username == '' || username == ' ' || username[username.length - 1] == ' '
      # response = "Username is blank, aborting"
      response = undefined
    else
      # store value and respond with success
      increment = parseInt(user[user.length-1] + 1)

      robot.brain.data.karma[dateKey] ?= {}
      robot.brain.data.karma[dateKey][username] ?= 0
      score = robot.brain.data.karma[dateKey][username] += increment

      response = "I've updated #{username} to #{score} for #{monthName()}!"

    if !!response
      msg.send response


  # print out the karma leaderboard for this month
  robot.respond /(karma|scoreboard|leaderboard)/i, (msg) ->
    list = ''
    scores = robot.brain.data.karma[dateKey]
    sorted_users = Object.keys(scores).sort((a,b) => scores[a] - scores[b]).reverse()

    i = 1
    for user in sorted_users
      list_item = "##{i}. #{user}: #{scores[user]}\n"
      list = list + list_item
      i++

    msg.send "*Karma leaderboard for #{monthName()}*\n#{list}"

