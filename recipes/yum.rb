execute 'yum update' do
  command 'yum update'
  action :run
  ignore_failure true
end
