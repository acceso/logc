# vim: sw=2 sts=2 et ts=2



class UdpSenderH < EM::Connection

  def receive_data( data )
    msg = Msg.new

    msg.tstamp = Time.now.getutc.to_f
    msg.channel = @channel
    msg.body = data

    @routerhandler.route( @channel, msg )
  end

  attr_accessor :snd_host, :snd_port

  def send( msg )
    p msg.channel + " routing msg: " + msg.body

    send_datagram( msg.body, @snd_host, @snd_port )
  end

end


class UdpSender

  def initialize( routerhandler, channel, ip, port )
    @channel = channel

    c = EM::open_datagram_socket( "127.0.0.1", 0, UdpSenderH )
    c.snd_host = ip
    c.snd_port = port

    routerhandler.route_add( channel, c )
  end

end



