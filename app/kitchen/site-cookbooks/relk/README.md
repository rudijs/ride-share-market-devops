# relk-cookbook

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
    <td><tt>['relk']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### relk::default

Include `relk` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[relk::default]"
  ]
}
```

## License and Authors

Author:: Ride Share Market (<systemsadmin@ridesharemarket.com>)
