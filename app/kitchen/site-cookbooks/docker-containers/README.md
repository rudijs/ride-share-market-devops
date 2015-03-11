# docker-containers-cookbook

TODO: Enter the cookbook description here.

## Supported Platforms

TODO: List your supported platforms.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['docker-containers']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### docker-containers::default

Include `docker-containers` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[docker-containers::default]"
  ]
}
```

## License and Authors

Author:: Ride Share Market (<systemsadmin@ridesharemarket.com>)
