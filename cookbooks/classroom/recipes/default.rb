workstations = search(:node, "ohai_time:* AND role:workstation")
targets = search(:node, "ohai_time:* AND role:target")

package "apache2"

service "apache2" do
  action [:start,:enable]
end

template "/var/www/index.html" do
  source "index.html.erb"
  mode 00644
  backup 0
  variables(
    :workstations => workstations,
    :targets => targets
  )
end
