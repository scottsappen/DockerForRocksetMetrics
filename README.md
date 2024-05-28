# DockerForRocksetMetrics
A simple docker container to run Prometheus and Grafana to access your Rockset REST metrics endpoint!    

## Assumptions
The assumption is that you have Docker[https://www.docker.com/products/docker-desktop/] installed. For instance, this runs on a Macbook silicon fine, but you can run it wherever Docker is supported.

## Steps
Step 1. Download this dockerfile and save it in a directory  
-> [dockerfile source code](dockerfile)

Step 2.
Navigate to that directory  
`cd <wherever your dockerfile is>`

Build the container  
Remember to replace your REGION and APIKEY accordingly  
`docker build --build-arg REGION=usw2a1 --build-arg APIKEY=yourRocksetAPIkeyhere -t grafana-prometheus .`

Run the container  
`docker run -p 9090:9090 -p 3000:3000 grafana-prometheus`

Access prometheus and grafana  
Prometheus - running on `http://localhost:9090/`  
Grafana - running on `http://localhost:3000/`

## Interactive Mode
If you have trouble getting prometheus to run, you can always use interactive mode to debug it.  
At the end of your dockerfile do this instead of the provided CMD  
`CMD /bin/bash`

Build the file (same build steps above) and run it in interactive mode  
`docker run -it -p 9090:9090 -p 3000:3000 grafana-prometheus`

you can run these programs to troubleshoot them locally like looking at promethus config  
e.g. `/opt/prometheus/prometheus.yml`

`prometheus --config.file=/opt/prometheus/prometheus.yml --storage.tsdb.path=/opt/prometheus/data`

`grafana-server --homepath=/opt/grafana`
