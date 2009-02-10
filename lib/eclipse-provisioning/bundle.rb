# Copyright (c) Intalio, Inc. 2009
 
# A bundle class to represent an OSGi bundle
class Bundle

  #Keys used in the MANIFEST.MF file
  B_NAME = "Bundle-SymbolicName"
  B_REQUIRE = "Require-Bundle"
  B_VERSION = "Bundle-Version"
  B_DEP_VERSION = "bundle-version"
  B_RESOLUTION = "resolution"
  B_LAZY_START = "Bundle-ActivationPolicy"
  B_OLD_LAZY_START = "Eclipse-LazyStart"
  
  # Attributes of a bundle, derived from its manifest
  # The name is always the symbolic name
  # The version is either the exact version of the bundle or the range in which the bundle would be accepted.
  # The file is the location of the bundle on the disk
  # The optional tag is present on bundles resolved as dependencies, marked as optional.
  # The start level is deduced from the bundles.info file. Default is -1.
  # The lazy start is found in the bundles.info file
  attr_accessor :name, :version, :bundles, :file, :optional, :start_level, :lazy_start
  def initialize(name, version, file=nil, bundles=[], optional = false)
    @name = name
    @version = version
    @bundles = bundles
    @file = file
    @optional = optional
    @start_level = 4
  end

  # Creates itself by loading from the manifest file passed to it as a hash
  # Finds the name and version, and populates a list of dependencies.
  def self.fromManifest(manifest, jarFile) 
     bundles = []
#see http://aspsp.blogspot.com/2008/01/wheres-system-bundle-jar-file-cont.html for the system.bundle trick.
#key.strip: sometimes there is a space between the comma and the name of the bundle.
     manifest.first[B_REQUIRE].each_pair {|key, value| bundles << Bundle.new(key.strip, value[B_DEP_VERSION], nil, [], value[B_RESOLUTION] == "optional") unless "system.bundle" == key} unless manifest.first[B_REQUIRE].nil?
     bundle = Bundle.new(manifest.first[B_NAME].keys.first, manifest.first[B_VERSION].keys.first, jarFile, bundles)
     if !manifest.first[B_LAZY_START].nil? 
       # We look for the value of Bundle-ActivationPolicy: lazy or nothing usually. 
       # lazy may be spelled Lazy too apparently, so we downcase the string in case.
       bundle.lazy_start = "lazy" == manifest.first[B_LAZY_START].keys.first.strip.downcase
     else
       bundle.lazy_start = "true" == manifest.first[B_OLD_LAZY_START].keys.first.strip unless manifest.first[B_OLD_LAZY_START].nil?
     end
     if (bundle.lazy_start)
       bundle.start_level = 4
     else
       bundle.start_level = -1
     end
     return bundle
  end
  
  def ==(b)
    if b.nil? || !(b.is_a? Bundle)
      false
    else
      b.name == @name && b.version == @version
    end
  end
end