require 'minitest/spec'

describe_recipe 'deploy::mysql' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates a database for the application' do
    node[:deploy].each do |application, deploy|
      assert system("#{mysql_command(deploy)} -e 'SHOW DATABASES' | \
                    egrep -e '^#{deploy[:database][:database]}$'")
    end
  end

  def mysql_command(deploy)
    "/usr/bin/mysql -u #{deploy[:database][:username]} \
     #{node[:mysql][:server_root_password].blank? ? '' : "-p#{node[:mysql][:server_root_password]}"}"
  end
end
