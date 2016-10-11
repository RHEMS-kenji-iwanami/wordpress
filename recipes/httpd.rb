%w{
  httpd
  php
  php-devel
  php-mysql
  mysql
}.each do |pkgname|
  package "#{pkgname}" do
    action :install
  end
end

service "httpd" do
  action [ :enable, :restart]
  supports :status => true, :restart => true, :reload => true
end
