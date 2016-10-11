#
# Cookbook Name:: wordpress
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

include_recipe "wordpress::yum"
include_recipe "wordpress::httpd"
include_recipe "wordpress::mysql"
include_recipe "wordpress::wordpress"
