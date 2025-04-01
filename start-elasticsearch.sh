#!/bin/bash

# Script to start Elasticsearch container

echo "========================================================"
echo "  Starting Elasticsearch Container"
echo "========================================================"
echo ""

# Pull the Elasticsearch image
echo "Pulling Elasticsearch image..."
docker pull docker.elastic.co/elasticsearch/elasticsearch:8.8.2

# Check if container already exists
if [ "$(docker ps -a -q -f name=elasticsearch)" ]; then
  echo "Elasticsearch container already exists"
  
  # Check if it's running
  if [ "$(docker ps -q -f name=elasticsearch)" ]; then
    echo "Elasticsearch container is already running"
  else
    echo "Starting existing Elasticsearch container..."
    docker start elasticsearch
  fi
else
  # Run the Elasticsearch container
  echo "Creating and starting new Elasticsearch container..."
  docker run -d --name elasticsearch \
    -p 9200:9200 -p 9300:9300 \
    -e "discovery.type=single-node" \
    -e "xpack.security.enabled=false" \
    docker.elastic.co/elasticsearch/elasticsearch:8.8.2
fi

echo ""
echo "Elasticsearch should be accessible at: http://localhost:9200"
echo "========================================================" 