#!/bin/bash

# Master script to start both Elasticsearch and Spark Notebook containers

echo "========================================================"
echo "  Starting All Containers"
echo "========================================================"
echo ""

# Create a custom network if it doesn't exist
if ! docker network inspect arxiv-elastic-net >/dev/null 2>&1; then
  echo "Creating custom Docker network: arxiv-elastic-net..."
  docker network create arxiv-elastic-net
else
  echo "Using existing Docker network: arxiv-elastic-net"
fi

# Set network name as environment variable so child scripts can use it
export DOCKER_NETWORK_NAME="arxiv-elastic-net"

# Make sure the scripts are executable
chmod +x ./start-elasticsearch.sh
chmod +x ./start-spark-notebook.sh

# First start Elasticsearch
echo "Starting Elasticsearch container..."
./start-elasticsearch.sh

echo ""
echo "========================================================"
echo ""

# Then start Spark Notebook
echo "Starting Spark Notebook container..."
./start-spark-notebook.sh

echo ""
echo "========================================================"

# Verify network connectivity (ensure both containers are on the network)
echo "Verifying network setup..."
if docker ps | grep -q "elasticsearch" && docker ps | grep -q "jupyter-spark"; then
  # Both containers are running, now check if they're on the network
  if ! docker network inspect arxiv-elastic-net | grep -q "\"Name\": \"elasticsearch\""; then
    echo "Warning: Elasticsearch container is not on the network. Connecting it now..."
    docker network connect arxiv-elastic-net elasticsearch
  fi
  
  if ! docker network inspect arxiv-elastic-net | grep -q "\"Name\": \"jupyter-spark\""; then
    echo "Warning: Jupyter Spark container is not on the network. Connecting it now..."
    docker network connect arxiv-elastic-net jupyter-spark
  fi
  
  # Test connection from Jupyter to Elasticsearch
  echo "Testing connection from Jupyter to Elasticsearch..."
  if docker exec -it jupyter-spark curl -s elasticsearch:9200 > /dev/null; then
    echo "✅ Connection test successful! Containers can communicate with each other."
  else
    echo "❌ Connection test failed. Please check your Docker network configuration."
  fi
else
  echo "One or both containers are not running. Cannot verify network setup."
fi

echo "  All containers should now be running"
echo "  - Elasticsearch: http://localhost:9200"
echo "  - Jupyter Notebook: http://localhost:8888"
echo "  - Inside Jupyter/Spark, use 'elasticsearch' as the hostname to connect to Elasticsearch"
echo "========================================================" 