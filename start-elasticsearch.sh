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
  
  # Make sure container is connected to the network (regardless if it was just started or already running)
  if [ ! -z "${DOCKER_NETWORK_NAME}" ]; then
    # Check if already connected to the network
    if ! docker network inspect ${DOCKER_NETWORK_NAME} | grep -q "\"Name\": \"elasticsearch\""; then
      echo "Connecting Elasticsearch container to network ${DOCKER_NETWORK_NAME}..."
      docker network connect ${DOCKER_NETWORK_NAME} elasticsearch
    else
      echo "Elasticsearch container is already connected to network ${DOCKER_NETWORK_NAME}"
    fi
  fi
  
else
  # Run the Elasticsearch container
  echo "Creating and starting new Elasticsearch container..."
  
  # Use the network from the parent script if available
  NETWORK_OPTION=""
  if [ ! -z "${DOCKER_NETWORK_NAME}" ]; then
    NETWORK_OPTION="--network ${DOCKER_NETWORK_NAME}"
    echo "Using Docker network: ${DOCKER_NETWORK_NAME}"
  fi
  
  docker run -d --name elasticsearch \
    ${NETWORK_OPTION} \
    -p 9200:9200 -p 9300:9300 \
    -e "discovery.type=single-node" \
    -e "xpack.security.enabled=false" \
    docker.elastic.co/elasticsearch/elasticsearch:8.8.2
fi

echo ""
echo "Elasticsearch should be accessible at: http://localhost:9200"
if [ ! -z "${DOCKER_NETWORK_NAME}" ]; then
  echo "From other containers on network ${DOCKER_NETWORK_NAME}, Elasticsearch is accessible at: elasticsearch:9200"
fi
echo "========================================================" 