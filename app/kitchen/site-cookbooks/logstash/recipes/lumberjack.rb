# Lumberjack TLS certificate
ssl_cert  = node["secrets"]["data"]["ssl"]["lumberjack"]["certificate"]
directory ssl_cert["path"] do
  recursive true
end
file File.join(ssl_cert["path"], ssl_cert["name"]) do
  content ssl_cert["data"]
end

# Lumberjack TLS key
ssl_key   = node["secrets"]["data"]["ssl"]["lumberjack"]["key"]
directory ssl_key["path"] do
  recursive true
end
file File.join(ssl_key["path"], ssl_key["name"]) do
  content ssl_key["data"]
end
