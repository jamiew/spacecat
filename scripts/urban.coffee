# Description:
#   Define terms via Urban Dictionary
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot define <term>     - Searches Urban Dictionary and returns definition
#   hubot urban me <term>   - Searches Urban Dictionary and returns definition
#
# Author:
#   Travis Jeffery (@travisjeffery)
#   Jamie Wilkinson (@jamiew)

module.exports = (robot) ->
  robot.respond /(define|urban)( me)? (.*)/i, (msg) ->
    urbanDict msg, msg.match[3], (entry) ->
      msg.send "#{entry.definition}. Example: \"#{entry.example}\""

urbanDict = (msg, query, callback) ->
  msg.http("http://api.urbandictionary.com/v0/define?term=#{escape(query)}")
    .get() (err, res, body) ->
      # console.log body
      callback(JSON.parse(body).list[0])

