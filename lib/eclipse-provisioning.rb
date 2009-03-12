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
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require File.dirname(__FILE__) + '/eclipse-provisioning/bundles_info.rb'
require File.dirname(__FILE__) + '/eclipse-provisioning/eclipse_instance.rb'