node.default["udemyDemo"]["companyName"] = "meine bude"
node.default["udemyDemo"]["productlist"] = [ "product 1", "schön", "besser", "musste koofen"]

package "webserver" do
  action :install
  case node[:platform_family]
    when "rhel"
      package_name "httpd"
    when "debian"
      package_name "apache2"
  end
end

service "webserver" do
  action [:start, :enable]
  case node[:platform_family]
    when "rhel"
      service_name "httpd"
    when "debian"
      service_name "apache2"
  end
end

file '/var/www/html/index.html' do
  content '<h1>hello world</h1>'
  mode '0755'
  owner 'www-data'
  group 'www-data'
end

template '/var/www/html/mycompany.html' do
  source 'mycompany.html.erb'
  mode '0755'
  owner 'www-data'
  group 'www-data'
  variables ({
   :companyname => node["udemyDemo"]["companyName"],
   :productlist => node["udemyDemo"]["productlist"],
   :premium => false
  })
end

cookbook_file '/var/www/html/webpage.html' do
  source 'webpage.html'
end
