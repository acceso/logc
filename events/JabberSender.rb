#!/usr/bin/ruby -w
# -*- coding: utf-8 -*-

# vim: sw=2 sts=2 et ts=2


require 'xmpp4r/client'


#Jabber::debug = true


class JabberSender


  def got_msg( jb_msg )
    return unless jb_msg.type == :chat

    msg = Msg.new

    msg.tstamp = Time.now.getutc.to_f
    msg.channel = @channel
    msg.body = jb_msg.body

    @routerhandler.route( @channel, msg )
  end


  def send( msg )

      @recipients.each do |r|
        jb_msg = Jabber::Message.new( r, "#{msg.body}" )
        jb_msg.type = 'chat'

        @jb.send( jb_msg )
      end

  end


  def reconnect
    @jb.connect
    @jb.auth( @passwd )
    @jb.send( Jabber::Presence.new )
  end


  def initialize( routerhandler, channel, jid, passwd, recipients )
    @routerhandler = routerhandler
    @channel = channel
    @jid = jid
    @passwd = passwd
    @recipients = recipients

    @jb = Jabber::Client.new( @jid )

    self.reconnect( )

    @jb.on_exception { sleep 9; self.reconnect( ) }

    @jb.add_message_callback do |m|
      self.got_msg( m )
    end

    @routerhandler.route_add( channel, self )

  end


end




