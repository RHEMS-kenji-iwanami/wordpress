# -*- coding: utf-8 -*-
#
# Cookbook Name:: wordpress01
# Recipe:: default
#
# Copyright 2015, Maho Takara
#

remote_file '/root/latest-ja.tar.gz' do
  source 'http://ja.wordpress.org/latest-ja.tar.gz'
  owner 'root'
  group 'root'
  mode '0444'
  action :create
end


script "install_wordpress" do
  interpreter "bash"
  user        "root"
  cwd         "/root"
  code <<-EOL
    mkdir -p \"#{node['http']['doc_root']}\"
    tar xzvf latest-ja.tar.gz
    mv wordpress \"#{node['http']['doc_root']}\"
  EOL
  action :run
end


db_name       = node["mysql"]["db_name"]
user_name     = node["mysql"]["user"]["name"]
user_password = node["mysql"]["user"]["password"]

template "#{node['http']['doc_root']}/wordpress/wp-config.php" do
  owner "root"
  group "root"
  mode 0644
  source "wp-config.php.erb"
  variables({
    :db_name => db_name,
    :username => user_name,
    :password => user_password,
  })
  action :create
end

execute "mysql-create-user" do
    command "/usr/bin/mysql -u root --password=\"#{node['mysql']['user']['password']}\"  < /tmp/grants.sql"
    action :nothing
end
 
template "/tmp/grants.sql" do
    owner "root"
    group "root"
    mode "0600"
    variables(
        :user     => node['mysql']['user']['name'],
        :password => node['mysql']['user']['password'],
        :database => node['mysql']['db_name']
    )
    notifies :run, "execute[mysql-create-user]", :immediately
end

execute "mysql-create-database" do
    command "/usr/bin/mysqladmin -u root --password=\"#{node['mysql']['user']['password']}\" create #{node['mysql']['db_name']}"
end

template "/etc/httpd/conf.d/vhost.conf" do
  owner "root"
  group "root"
  mode 0644
  source "vhost.conf.erb"
  variables({
    :DocumentRoot => node['http']['doc_root'],
    :servername => node['http']['server_name'],
  })
  action :create
end
