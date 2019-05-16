function discord_on_message(msg) {
  var parts = msg.content.split(" ")
  switch(parts[0]) {
    case "!add":
      var total = parts.slice(1)
        .map(function(e) { return parseInt(e) })
        .reduce(function(t, e) { return t + e })
      discord_create_message(msg.channel_id, total.toString())
      break;
    case "!javascript":
      discord_create_message(msg.channel_id, "js is a great language")
  }
}
