function discord_on_message(cid, msg) {
  switch(msg.content.split(" ")[0]) {
    case "!add":
      var parts = msg.content
        .split(" ")
        .slice(1)
        .map(function(e) { return parseInt(e) })
      var total = parts.reduce(function(t, e) { return t + e })
      discord_create_message(msg.channel_id, total.toString())
      break;
    case "!javascript":
      discord_create_message(msg.channel_id, "js is a great language")
  }
}
