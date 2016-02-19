#!/usr/bin/env ruby

require 'rubygems'
require 'blather/client'
require_relative 'plugin.rb'
require_relative 'bot.rb'
require 'dotenv'

# Load files in plugins folder
Dir["plugins/*.rb"].each {|file| require File.join(File.dirname(__FILE__), file) }
puts "Registered plugins: #{LCTVPlugin.each_c(&:to_s).join(', ')}"

Dotenv.load

require 'blather/client/dsl'

module MUC
  CHAN = ENV.fetch('CHAN')
  extend Blather::DSL
  BOT = Bot.new(CHAN, client)
  
  when_ready do
    join "#{CHAN}@chat.livecoding.tv", ENV.fetch('LOGIN')
    pres = Blather::Stanza::Presence::Status.new
    pres.to = "docc@chat.livecoding.tv/#{ENV.fetch('LOGIN')}"
    pres.state = :chat

    client.write(pres)
  end

  message :groupchat?, :body, proc { |m| m.from != jid.stripped }, delay: nil do |m|
    LCTVPlugin.each do |p|
      p.process(m) and BOT.send_msg(p.msg)
    end
  end
end

MUC.setup "#{ENV.fetch('LOGIN')}@livecoding.tv", ENV.fetch('PASS')
EM.run { MUC.run }
