require "discordcr"
require "duktape/runtime"

Owner       = 120571255635181568_u64
REST_CLIENT = Discord::Client.new(ENV["DUKBOT_TOKEN"])
client = REST_CLIENT

duk_rt = Duktape::Runtime.new do |sbx|
  sbx.push_global_proc("discord_create_message", 2) do |ptr|
    env = Duktape::Sandbox.new(ptr)
    cid = env.require_string(0).to_u64
    msg = env.require_string(1)
    REST_CLIENT.create_message(cid, msg)
    env.call_success
  end
end

script = File.read("src/bot.js")
duk_rt.eval(script)

client.on_message_create do |payload|
  case {payload.content, payload.author.id}
  when {"!ping", Owner}
    client.create_message(payload.channel_id, "pong")
  when {"!reload", Owner}
    script = File.read("src/bot.js")
    duk_rt.eval(script)
    client.create_message(payload.channel_id, "script reloaded")
  else
    duk_rt.call(
      "discord_on_message",
      payload.channel_id.to_s,
      {
        "content"    => payload.content,
        "channel_id" => payload.channel_id.to_s,
        "author"     => {
          "id"            => payload.author.id.to_s,
          "username"      => payload.author.username,
          "discriminator" => payload.author.discriminator,
          "avatar"        => payload.author.avatar,
        },
      }
    )
  end
end

client.run
