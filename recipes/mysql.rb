%w{mysql mysql-server mysql-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

service "mysqld" do
    action [ :enable, :start ]
    supports :status => true, :restart => true, :reload => true
end

execute "set root password" do
  command "mysqladmin -u root password #{node["mysql"]["root_password"]}"
  only_if "mysql -u root -e 'show databases;'"
end
