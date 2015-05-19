class HipchatService

  attr_accessor :client
  attr_accessor :room_id

  def initialize
    self.client = HipChat::Client.new(ENV["HIPCHAT_API_KEY"])
    self.room_id= ENV["HIPCHAT_ROOM_ID"]
  end

  def default_room
    client[room_id]
  end

  def send_message(params={})
    params = {
      notify:false,
      color:'yellow',
      message_format:'text'
    }.merge(params)

    default_room.send('Stripe',params[:text], params.tap { |c| c.delete(:text)} )
  end

end
