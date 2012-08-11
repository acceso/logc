# vim: sw=2 sts=2 et ts=2



class RouterHandler

  def route( channel, msg )
    @routes.each do |r|

      next unless channel     =~ r["channel"]
      next unless msg.body    =~ r["body"]

      return unless @objs[ r["route"] ].respond_to? "send"

      #p "Routing: " + r['route'] + ": " + msg.channel + " -> " + r["route"]
      @objs[ r['route'] ].send( msg )


      r["flags"] = "" unless r["flags"]

      return unless r["flags"] =~ /c/

    end
  end


  def route_add( channel, obj )
    #p "Add route: " + channel + " send to: " + obj.class.to_s
    @objs[channel] = obj
  end


  def initialize( routes )
    @objs = { }
    @routes = routes
  end

end



