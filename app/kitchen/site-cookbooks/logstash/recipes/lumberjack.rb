ssl_keys_path = %w(/etc/pki/tls/certs/logstash-forwarder /etc/pki/tls/private/logstash-forwarder)

ssl_keys_path.each {|path|
  directory path do
    recursive true
  end
}

ssl_cert  = node["secrets"]["data"]["ssl"]["lumberjack"]["certificate"]
ssl_key   = node["secrets"]["data"]["ssl"]["lumberjack"]["key"]

file ssl_cert["name"] do
  content ssl_cert["data"]
end

file ssl_key["name"] do
  content ssl_key["data"]
end
