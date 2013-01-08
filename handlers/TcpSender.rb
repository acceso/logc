# vim: sw=2 sts=2 et ts=2



class TcpSenderH < EM::Connection

  def receive_data( data )
    msg = Msg.new

    msg.tstamp = Time.now.getutc.to_f
    msg.channel = @channel
    msg.body = data

    @routerhandler.route( @channel, msg )
  end

  def send( msg )
    #p msg.channel + " routing msg: " + msg.body

    self.send_data( msg.body )
  end

end



class TcpSender

  def initialize( routerhandler, channel, ip, port, timeout = nil )
    @routerhandler = routerhandler
    @channel = channel

    c = EM::connect( ip, port, TcpSenderH )

    routerhandler.route_add( channel, c )
  end

end



