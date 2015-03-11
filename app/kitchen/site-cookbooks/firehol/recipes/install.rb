package "firehol"

service "firehol" do
    supports :restart => true, :reload => true
    action :nothing
    # subscribes :restart, "template[/etc/firehol/firehol.conf]", :immediately
end
