# Description:
#   Get the latest messages from each food truck in Stockholm Foodtrucks (stockholmfoodtrucks.nu)
#
# Configuration:
#   None
#
# Dependencies:
#   "cheerio": "1.13.x"
#
# Commands:
#   hubot foodtrucks|food trucks - Gets you the latest messages from Stockholm's foodtrucks
#
# Author:
#   Nevon

cheerio = require "cheerio"
url = "http://stockholmfoodtrucks.nu/"

module.exports = (robot) ->
  robot.respond /foodtrucks|food\strucks/i, (msg) ->
    robot.http(url).get() (err, response, body) ->
      if not err and response.statusCode is 200
        $ = cheerio.load(body)
        trucks = []
        today = new Date()
        $(".truck").each (k, v) ->
          postDate = new Date($(".date", $(v)).attr("title"))

          # Only display posts from today
          if postDate.setHours(0,0,0,0) is today.setHours(0,0,0,0)
            trucks.push({
              "name" : $(".truck-name a", $(v)).text(),
              "post" : $(".post:first-child .content", $(v)).text()
              })

        if trucks.length > 0
          response = "Foodtrucks:\n\n"
          response += "***** #{truck.name} *****\n  #{truck.post}\n\n" for truck in trucks
        else
          response = "Sorry, but I couldn't find any food trucks"
      else
        response = "Sorry, but I couldn't find any food trucks"

      msg.reply response
