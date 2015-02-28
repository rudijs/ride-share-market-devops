remote_file "/opt/#{node["kibana"]["src_filename"]}.#{node["kibana"]["src_filename_type"]}" do
  source node["kibana"]["src_url"]
  action :create_if_missing
end

bash 'Extract Kibana Archive' do
  cwd "/opt"
  code <<-EOH
    tar xzf "#{node["kibana"]["src_filename"]}.#{node["kibana"]["src_filename_type"]}"
    chown -R #{node["kibana"]["user"]} #{node["kibana"]["src_filename"]}
    ln -s #{node["kibana"]["src_filename"]} #{node["kibana"]["extract_path"]}
  EOH
  not_if { ::File.exists?("/opt/#{node["kibana"]["src_filename"]}") }
end
