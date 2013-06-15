#
# Cookbook Name:: x2go
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# add the x2go PPA; grab key from keyserver, also add source repo
apt_repository "x2go" do
  uri "http://packages.x2go.org/debian"
  distribution "wheezy"
  components ["main"]
  keyserver "keys.gnupg.net"
  key "E1F958385BFE2B6E"
  deb_src true
end
package "x2goserver" do 
  action :install
end
package "chromium" do
  action :install
end
