# Metrics

Metrics are collected using Graphite and [StatsD](https://github.com/etsy/statsd/)

Javascript metrics data is sent to StatsD using [lynx](https://github.com/dscape/lynx)

## Testing

Manual metrics

    echo "node_test.int:1|c"  | nc -w 0 -u met01.dev.vbx.ridesharemarket.com 8125
    echo "node_test.int:-1|c" | nc -w 0 -u met01.dev.vbx.ridesharemarket.com 8125
    echo "node_test.some_service.task.time:500|ms" | nc -w 0 -u met01.dev.vbx.ridesharemarket.com 8125
    echo "gauge.one:100|g"    | nc -w 0 -u met01.dev.vbx.ridesharemarket.com 8125
    echo "set.one:10|s"       | nc -w 0 -u met01.dev.vbx.ridesharemarket.com 8125

