## Chef server usage notes

###Reset all chef server cookbooks - delete all, then upload all

- Delete all cookbooks
- `knife cookbook bulk delete ".*" -p`
- Upload all cookbooks
- `knife cookbook upload --all`
