#!/usr/bin/ruby -w
# -*- coding: utf-8 -*-

# vim: sw=2 sts=2 et ts=2


require 'eventmachine'



class SmtpSender


  def send( msg )

    EM::Protocols::SmtpClient.send(
      :domain   => 'tronco',
      :host     => @host,
      :port     => '25',
      :starttls => false,
      :from     => @from,
      :to       => @recipients,
      :header   => { "Subject" => @subject },
      :body     => msg.body
    )

  end


  def initialize( routerhandler, channel, host, subject, from, recipients )
    @routerhandler = routerhandler
    @channel = channel
    @host = host
    @subject = subject
    @from = from
    @recipients = recipients

    routerhandler.route_add( channel, self )

  end


end




