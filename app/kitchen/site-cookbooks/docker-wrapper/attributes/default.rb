default['docker']['restart'] = nil
default['docker']['options'] = "--insecure-registry #{node["network"]["interfaces"]["eth1"]["addresses"].keys[1]}:5000"
