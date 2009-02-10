# Copyright (c) Intalio, Inc. 2009

require File.dirname(__FILE__) + "/bundles_info.rb"
require "rubygems" unless defined? GEM
require "manifest"

# We will be messing up with .jar files that we will treat just like zip files.
require "zip/zip"
require "zip/zipfilesystem"

#The EclipseInstance class manages an Eclipse instance, with a list of the bundles it contains
# and the current configuration of Eclipse.
class EclipseInstance
  include Manifest # brings a method named read to interpret manifests into hashs.

  # bundles: the bundles of the eclipse instance loaded on startup
  # location: the location of the Eclipse instance
  attr_accessor :bundles, :location
  
  # info: a bundle info instance
  attr_reader :info
  
  def initialize(location, plugin_locations = ["dropins", "plugins"])
    @location = location
    @bundles = []
    plugin_locations.each do |p_loc|
      p_loc_complete = @location + File::SEPARATOR + p_loc
      warn "Folder #{p_loc_complete} not found!" if !File.exists? p_loc_complete 
      parse(p_loc_complete)  
    end
    
    @info = BundlesInfo.new(@location)
  end
  
  # Parses the directory and grabs the plugins, adding the created bundle objects to @bundles.
  def parse(dir)
    Dir.open(dir) do |plugins|
        plugins.entries.each do |plugin|
          absolute_plugin_path = "#{plugins.path}#{File::SEPARATOR}#{plugin}"
          if (/.*\.jar$/.match(plugin)) 
            zipfile = Zip::ZipFile.open(absolute_plugin_path)
            entry =  zipfile.find_entry("META-INF/MANIFEST.MF")
            if (entry != nil)
              manifest = read(zipfile.read("META-INF/MANIFEST.MF"))
              @bundles << Bundle.fromManifest(manifest, absolute_plugin_path) 
            end
            zipfile.close
          else
            # take care of the folder
            if (File.directory?(absolute_plugin_path) && !(plugin == "." || plugin == ".."))
              if (!File.exists? ["#{absolute_plugin_path}", "META-INF", "MANIFEST.MF"].join(File::SEPARATOR))
                #recursive approach: we have a folder wih no MANIFEST.MF, we should look into it.
                parse(absolute_plugin_path)
              else
                next if File.exists? "#{absolute_plugin_path}/feature.xml" # avoid parsing features.
                begin
                  manifest = read((file = File.open("#{absolute_plugin_path}/META-INF/MANIFEST.MF")).read)
                rescue
                  file.close
                end
                @bundles << Bundle.fromManifest(manifest, absolute_plugin_path)
              end
            end
          end
        end
     end
  end
  
  # Return the list of bundles that are installed in the Eclipse instance, ie the ones in the bundles.info file
  def installed
    return @bundles.select {|b| installed? b}
  end
  
  # Return the list of bundles that are marked as uninstalled, ie not present in the bundles.info file
  def uninstalled
    return @bundles.select {|b| !installed? b}
  end
  
  # Return the list of bundles that match the criteria passed as arguments
  def find(criteria = {:name => "", :version =>""})
    selected = @bundles
    if (criteria[:name])
      selected = @bundles.select {|b| b.name == criteria[:name]}
    end
    if (criteria[:version])
      selected = @bundles.select {|b| b.version == criteria[:version]}
    end
    selected
  end
  
  # Returns true if the bundle is installed, ie present in bundles.info
  def installed?(bundle)
    @info.bundles.include? bundle
  end  
end