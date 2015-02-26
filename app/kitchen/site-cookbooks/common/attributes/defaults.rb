default['postfix']['main']['myhostname'] = node['set_fqdn']
default['postfix']['main']['mydomain'] = node['postfix']['main']['mydomain']
default['postfix']['main']['mydestination'] = [node['set_fqdn'], node['postfix']['main']['hostname'], 'localhost.localdomain', 'localhost'].compact