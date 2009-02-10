require File.dirname(__FILE__) + '/test_helper.rb'


require "tempfile"

class TestBundlesInfo < Test::Unit::TestCase

  attr_accessor :tmpFile
  
  def setup
    @tmpFile = Tempfile.new('bundles.info').path
    
    File.open(@tmpFile, "w+") {|f|
      f.puts "com.ibm.icu.source,3.8.1.v20080530,plugins/com.ibm.icu.source_3.8.1.v20080530.jar,-1,false"
      f.puts "org.eclipse.debug.ui,3.5.0.v20090128-1600,plugins/org.eclipse.debug.ui_3.5.0.v20090128-1600.jar,4,false"
    }
  end
  
  def test_load_and_save
    info = BundlesInfo.new(File.dirname(@tmpFile), File.basename(@tmpFile))
    assert info.bundles.size == 2
    assert info.bundles.first.name == "com.ibm.icu.source"
    
    # Change a bundle, save and see if there is a difference:
    info.bundles[1].lazy_start = false
    info.save
    
    File.open(@tmpFile) {|f|
      f.each_line do |line|
        elts = line.split(",")
        assert elts[4] == "true" if elts[0] == "org.eclipse.debug.ui"
      end    
    }
  end
  
  
end
