# vim: sw=2 sts=2 et ts=2



class UdpListenerCB < EM::Connection

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



class UdpListener

  def initialize( routerhandler, channel, ip, port, timeout = 5 )
    EM::open_datagram_socket( ip, port, UdpListenerCB, routerhandler, channel, timeout )
  end

end



