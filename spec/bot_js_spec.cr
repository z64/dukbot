require "./spec_helper"
require "duktape/runtime"

class Call
  property channel_id : UInt64? = nil
  property message : String? = nil
end

LastCall = Call.new

duk_rt = Duktape::Runtime.new do |sbx|
  sbx.push_global_proc("discord_create_message", 2) do |ptr|
    env = Duktape::Sandbox.new(ptr)
    LastCall.channel_id = env.require_string(0).to_u64
    LastCall.message = env.require_string(1)
    env.call_success
  end
end

duk_rt.eval(File.read("src/bot.js"))

describe "bot.js" do
  it "!add" do
    duk_rt.call("discord_on_message", {"content" => "!add 1 2 3", "channel_id" => "1"})
    LastCall.channel_id.should eq 1
    LastCall.message.should eq "6"
  end

  it "!javascript" do
    duk_rt.call("discord_on_message", {"content" => "!javascript", "channel_id" => "1"})
    LastCall.channel_id.should eq 1
    LastCall.message.should eq "js is a great language"
  end
end
