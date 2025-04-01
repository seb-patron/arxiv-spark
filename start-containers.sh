#!/bin/bash

# Master script to start both Elasticsearch and Spark Notebook containers

echo "========================================================"
echo "  Starting All Containers"
echo "========================================================"
echo ""

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
echo "========================================================" 