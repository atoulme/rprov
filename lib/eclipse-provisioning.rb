# Copyright (c) Intalio, Inc. 2009
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require File.dirname(__FILE__) + '/eclipse-provisioning/bundles_info.rb'
require File.dirname(__FILE__) + '/eclipse-provisioning/eclipse_instance.rb'

module EclipseProvisioning
  VERSION = '0.0.1'
end