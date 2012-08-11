# vim: sw=2 sts=2 et ts=2



class TcpListenerCB < EM::Connection

  def receive_data( data )
    msg = Msg.new

    msg.tstamp = Time.now.getutc.to_f
    msg.channel = @channel
    msg.body = data

    @routerhandler.route( @channel, msg )
  end


  def initialize( routerhandler, channel, timeout )
    @routerhandler = routerhandler
    @channel = channel

    self.comm_inactivity_timeout = timeout
  end

end



class TcpListener

  def initialize( routerhandler, channel, ip, port = nil, timeout = 5 )
    EM::start_server( ip, port, TcpListenerCB, routerhandler, channel, timeout )
  end

end



