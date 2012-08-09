
# vim: sw=2 sts=2 et ts=2



class RouterHandler

  def route( channel, msg )
    @routes.each do |r|

      next unless channel     =~ r["channel"]
      next unless msg.body    =~ r["body"]

      @objs[ r["route"] ].send( msg  )


      r["flags"] = "" unless r["flags"]

      return unless r["flags"] =~ /c/

    end
  end


  def route_add( channel, obj )
    @objs[channel] = obj
  end


  def initialize( routes )

    @objs = { }
    @routes = routes

  end

end



