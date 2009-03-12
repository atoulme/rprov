###############################################################################
# Copyright (c) 2009 Intalio, Inc.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#     Intalio, Inc. - initial API and implementation
###############################################################################

require File.join(File.dirname(__FILE__), "/bundle.rb")

module Rprov
  
  # A specific module to read the bundles.info file format
  # That format uses a CSV like format:
  # plugin symbolic name,version,Eclipse instance relative location,start level (4 default),lazy start
  # An example here:
  # com.ibm.icu.source,3.8.1.v20080530,plugins/com.ibm.icu.source_3.8.1.v20080530.jar,-1,false 
  class BundlesInfo

    DEFAULT_FILE_LOCATION = "configuration/org.eclipse.equinox.simpleconfigurator/bundles.info"
    # bundles: the array of bundles loaded from the bundles.info file
    # instance location: the location of the Eclipse instance
    # file_location: the location of the file in the Eclipse instance. 
    # We default to configuration/org.eclipse.equinox.simpleconfigurator/bundles.info
    attr_reader :bundles, :instance_location, :file_location

    def initialize(location, file_location = DEFAULT_FILE_LOCATION)
      @location = location
      @file_location = file_location
      @bundles = []
      load
    end

    protected
    # Load the bundles from the bundles.info file
    # Called on initialization
    def load
      File.open("#{@location}/#{@file_location}").each_line {|line|
        next if line.match /^#.*/
        line_as_a = line.split(",") 
        bundle = Bundle.new(line_as_a[0], line_as_a[1], line_as_a[2])
        bundle.lazy_start = "false" == line_as_a[4]
        bundle.start_level = line_as_a[3]
        @bundles << bundle
      }
    end

    public

    # Saves the bundles to the bundles.info file registered.
    def save  
      f = File.open("#{@location}/#{@file_location}", "w+")
      begin
        f.puts "# Generated using eclipse-provisioning "
        bundles.each do |bundle|
          f.puts "#{bundle.name},#{bundle.version},#{bundle.file},#{bundle.start_level},#{!bundle.lazy_start}"
        end
      rescue
        f.close
      end
    end
  end

end