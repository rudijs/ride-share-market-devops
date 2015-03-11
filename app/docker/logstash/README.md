## Dev box

sudo docker build -t rudijs/logstash-rsm:0.0.1 .

sudo docker tag rudijs/logstash-rsm:0.0.1 192.168.33.10:5000/rudijs/logstash-rsm:0.0.1

sudo docker push 192.168.33.10:5000/rudijs/logstash-rsm:0.0.1

## VM box

sudo docker pull 192.168.33.10:5000/rudijs/logstash-rsm:0.0.1

sudo docker run -d --restart always -d --name logstash-rsm -v /srv/ride-share-market-data/log:/srv/ride-share-market-data/log 192.168.33.10:5000/rudijs/logstash-rsm:0.0.1
