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
echo "  All containers should now be running"
echo "  - Elasticsearch: http://localhost:9200"
echo "  - Jupyter Notebook: http://localhost:8888"
echo "  - Inside Jupyter/Spark, use 'elasticsearch' as the hostname to connect to Elasticsearch"
echo "========================================================" 