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

sanitizeUsername = (user) ->
  user.replace(/(?:[\+]{2}|[\-]{2})/, '').replace(/^@/,'')

module.exports = (robot) ->
  robot.brain.data.karma ?= {}

  # listen for @username++ or @username-- (and now also just "username++/--")
  robot.hear /(@)?[a-z0-9]*(?:[\+]{2}|[\-]{2})/ig, (msg) ->

    user_scores = {}

    for _match in msg.match
      match = _match.toLowerCase()

      username = sanitizeUsername(match)

      # don't let losers vote for themselves
      if username == msg.message.user.mention_name || username == msg.message.user.name
        response = "Only losers vote for themselves"
      else if !username? || username == '' || username == ' ' || username[username.length - 1] == ' '
        # response = "Username is blank, aborting"
        response = undefined
      else
        # store value and respond with success
        increment = parseInt(match[match.length-1] + 1)

        robot.brain.data.karma[dateKey] ?= {}
        robot.brain.data.karma[dateKey][username] ?= 0
        score = robot.brain.data.karma[dateKey][username] += increment
        user_scores[username] = score


    score_updates = []
    for username, score of user_scores
      score_updates.push "#{username} to #{score}"
    response = "I've updated " + score_updates.join(' and ') + " for #{monthName()}"

    if !!response
      msg.send response


  # print out the karma leaderboard for this month
  # TODO should this be limited to, say, the top 10 users?
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

