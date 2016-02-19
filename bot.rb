class Bot
  def initialize(chan, client)
    @chan = chan
    @client = client
  end
  
  def send_msg(str)
    msg = Blather::Stanza::Message.new
    msg.to = "#{@chan}@chat.livecoding.tv"
    msg.body = str
    msg.type = 'groupchat'
    @client.write(msg)
  end
end
