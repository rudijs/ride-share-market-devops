Encryption
==========

##Overview

Sensitive data like passwords, ssh keys and application API keys are stored in git are encrypted.

Encrypted data is stored in [Chef Encrypted Data Bags](http://docs.chef.io/data_bags.html)

##Encryption

When the Chef Client runs it will decrypt the data on the fly and use it.
 
In order for you to encrypt the data and for Chef to decrypt the data a shared password is required.

The shared password is stored in KeePass, it is copied into the git repo for use (it will be git ignored and not committed).

## Setup

- Create new file: `kitchen/.chef/chef_secret_key.txt`
- Copy the password from KeePass `Chef/chef_secret_key.txt` into `kitchen/.chef/chef_secret_key.txt`

## Chef-Solo Use

At the start of a chef solo client run this secret key is uploaded to the target server.

At the end of chef solo client run the secret key is removed from the target server.

## Chef-Client (Chef Server) Use

When the remote server is bootstrapped the *chef_secret_key.txt* is uploaded to the server and left in place there.

Each regular Chef Client run will read the key and decrypt data_bags as required.

Without the *chef_secret_key.txt* in place the Chef Client run will fail.

## Developer Use

Lets say you have data to encrypt that will be committed into git and Chef will use when it runs.

Plain text data to be encrypted is always in JSON format.

This plain text JSON data is copied from KeePass (where it is stored encrypted) into this repo.

Git will ignore the sensitive plain text data - it will not be committed plain text to github.

This plain text data needs to be encrypted then stored in the git repo.

- First make sure you've created the `kitchen/.chef/chef_secret_key.txt` file as described above.
- Copy from KeePass `Chef/secrets.json` into `kitchen/.chef/secrets.json`
- Encrypt the plain text json to an encrypted data bag, run command:
- `./lib/chef_encrypt_secrets.rb`
- The encrypted data bag is now safe to commit to git.
- The plain text json will be ignored, you can safely delete it and copy again from keepass as required.
- Important: Please ensure KeePass is updated with the current data that is encrypted.

## SSL and SSH Key Management

These keys need to be store *in a single line* in JSON file format.

We need to convert a multi line file to a single line.

- Prepare a multi line SSL or SSH key for encrypted JSON.
- Example SSL key to a single line of text:
- `tr "\n" ":" < rsm-logstash-forwarder.crt | sed -e 's/:/\\n/g'`
