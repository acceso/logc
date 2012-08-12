# vim: sw=2 sts=2 et ts=2



class ThriftSender

  def send( msg )
    #p @channel + " routing msg: " + msg.body
    # mm TODO: should be proxied or relayed??
    msg.channel = @channel

    @client.route( msg )
  end

  def initialize( routerhandler, channel, ip, port, timeout = nil )
    @channel = channel

    @transport = Thrift::BufferedTransport.new( Thrift::Socket.new( ip, port, timeout ) )
    @client = Router::Client.new( Thrift::BinaryProtocol.new( @transport ) )
    @transport.open

    routerhandler.route_add( channel, self )
  end

  # TODO: this is probably wrong..
#  def finalize( id )
#    @transport.close
#  end

end



