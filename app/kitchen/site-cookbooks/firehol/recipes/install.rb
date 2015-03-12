package "firehol"

service "firehol" do
    supports :restart => true, :reload => true
    action :nothing
end
