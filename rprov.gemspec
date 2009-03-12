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

spec = Gem::Specification.new do |s| 
  s.name = "rprov"
  s.version = "0.0.1"
  s.author = "Intalio, Inc"
  s.email = "github@intalio.com"
  s.homepage = "http://www.github.com/intalio/rprov"
  s.platform = $platform || RUBY_PLATFORM[/java/] || 'ruby'
  s.summary = "rprov is a tool for managing your Eclipse instance."
  s.files = Dir["bin/**/*", "lib/**/*", "tasks/**/*", "test/**/*", "spec/**/*", "features/**/*", "README", "license"]
  s.require_path = "lib"
  s.autorequire = "rake"
  s.test_files = FileList["{test}/**/*test.rb"].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "license"]
  
  # dependencies of buildr4eclipse
  s.add_dependency("manifest", "= 0.0.3")
    
  # development time dependencies
  s.add_development_dependency "ruby-debug"
  s.add_development_dependency 'rspec',                '1.1.12'
end
