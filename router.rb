#!/usr/bin/ruby -w
# -*- coding: utf-8 -*-

# vim: sw=2 sts=2 et ts=2


require 'pp'

$LOAD_PATH.unshift \
  File.dirname( __FILE__ ) + "/lib/", 
  File.dirname( __FILE__ ) + "/spec/"

require 'eventmachine'
require 'yaml'
require 'router'

[ "listeners", "events", "handlers" ].each do |d|
  Dir[ File.dirname( __FILE__ ) + '/' + d + '/*.rb' ].each do |f|
    require f
  end
end

require 'RouterHandler'



d = YAML.load_file( "router.yaml" )


router = RouterHandler.new( d["routes"] )


EM::run {

  d["channels"].each do |channel,v|
    Kernel.const_get( v["class"] ).new( router, channel, *v["params"] )
  end

}



