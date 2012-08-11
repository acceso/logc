# vim: sw=2 sts=2 et ts=2


require "eventmachine-tail"


class LogTailer < EventMachine::FileTail

  def receive_data( data )
    msg = Msg.new

    msg.tstamp = Time.now.getutc.to_f
    msg.channel = @channel
    msg.body = data

    @buffer.extract( data ).each do |l|
      msg.body = l
      @routerhandler.route( @channel, msg )
    end
  end


  def initialize( path, routerhandler, channel )
    super( path )

    @routerhandler = routerhandler
    @channel = channel

    @buffer = BufferedTokenizer.new
  end

end



class Tailer

  def initialize( routerhandler, channel, path, interval = 60, exclude = [] )
    EM::FileGlobWatchTail.new( path, LogTailer, interval, exclude, routerhandler, channel )
  end

end



