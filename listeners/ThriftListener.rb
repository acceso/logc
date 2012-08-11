# vim: sw=2 sts=2 et ts=2


require 'router'



class ThriftListenerCB < EM::Connection

  def route( msg )
    @routerhandler.route( @channel, msg )
  end

  def receive_data( data )
    request = StringIO.new data
    response = StringIO.new
    transport = Thrift::IOStreamTransport.new request, response

    protocol = Thrift::BinaryProtocol.new transport

    @processor.process protocol, protocol
  end


  def initialize( routerhandler, channel, timeout )
    @routerhandler = routerhandler
    @channel = channel

    @processor = Router::Processor.new( self )

    self.comm_inactivity_timeout = timeout
  end

end



class ThriftListener

  def initialize( routerhandler, channel, ip, port = nil, timeout = 5 )
    EM::start_server( ip, port, ThriftListenerCB, routerhandler, channel, timeout )
  end

end



