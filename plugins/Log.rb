#!/usr/bin/ruby -w
# -*- coding: utf-8 -*-

# vim: sw=2 sts=2 et ts=2


require 'logger'



class Log

  def send( msg )

    msg.body.each_line do |l|
      @logobj.info( msg.tstamp.to_s + " " + msg.channel + " " + l.chomp )
    end

  end


  def initialize( routerhandler, channel, logfile, rotate = 'monthly', size = '' )

    @logobj = Logger.new( logfile, rotate, size )

    # This is a hack. If the module structure changes, this will break.
    @logobj.datetime_format = ""
    @logobj.formatter = proc { |severity, datetime, progname, msg|
      "%s\n" % [ msg ]
    }

    routerhandler.route_add( channel, self )

  end


end




