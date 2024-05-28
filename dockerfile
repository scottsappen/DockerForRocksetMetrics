# Use a base image with Apple Silicon support
FROM arm64v8/ubuntu:latest

# Set environment variables for input
ARG REGION
ARG APIKEY

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    tar \
    gzip \
    && rm -rf /var/lib/apt/lists/*

# Install Prometheus
RUN wget https://github.com/prometheus/prometheus/releases/download/v2.32.1/prometheus-2.32.1.linux-arm64.tar.gz \
    && tar xvf prometheus-2.32.1.linux-arm64.tar.gz \
    && mv prometheus-2.32.1.linux-arm64 /opt/prometheus \
    && ln -s /opt/prometheus/prometheus /usr/local/bin/prometheus \
    && ln -s /opt/prometheus/promtool /usr/local/bin/promtool

# Install Grafana
RUN wget https://dl.grafana.com/oss/release/grafana-8.3.3.linux-arm64.tar.gz \
    && tar xvf grafana-8.3.3.linux-arm64.tar.gz \
    && mv grafana-8.3.3 /opt/grafana \
    && ln -s /opt/grafana/bin/grafana-server /usr/local/bin/grafana-server \
    && ln -s /opt/grafana/bin/grafana-cli /usr/local/bin/grafana-cli

# Replace prometheus.yml with the provided URL
RUN wget -O /opt/prometheus/prometheus.yml https://github.com/rocksetlabs/monitoring_visualization/raw/main/prometheus/prometheus.yaml

# Update prometheus.yml with REGION and APIKEY in the specific section
RUN sed -i "/- job_name: demo/{n; n; n; n; n; n; n; s|username:.*|username: ${APIKEY}|; n; s|targets:.*|targets:\\n    - api.${REGION}.rockset.com|}" /opt/prometheus/prometheus.yml

# Expose necessary ports
EXPOSE 9090
EXPOSE 3000

# Start Prometheus and Grafana
CMD prometheus --config.file=/opt/prometheus/prometheus.yml --storage.tsdb.path=/opt/prometheus/data & grafana-server --homepath=/opt/grafana
