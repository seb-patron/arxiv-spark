#!/bin/bash

# Script to stop and remove Spark and Elasticsearch containers

echo "========================================================"
echo "  Shutting Down Containers"
echo "========================================================"
echo ""

# Find and stop all Jupyter/Spark containers
echo "Stopping Jupyter/Spark containers..."
jupyter_containers=$(docker ps -q --filter "ancestor=jupyter/all-spark-notebook" --filter "ancestor=spark-scala-notebook" --filter "ancestor=almondsh/almond")
if [ -n "$jupyter_containers" ]; then
  docker stop $jupyter_containers
  echo "Jupyter/Spark containers stopped"
else
  echo "No running Jupyter/Spark containers found"
fi

# Stop Elasticsearch container if running
echo "Stopping Elasticsearch container..."
if [ "$(docker ps -q -f name=elasticsearch)" ]; then
  docker stop elasticsearch
  echo "Elasticsearch container stopped"
else
  echo "No running Elasticsearch container found"
fi

echo ""
echo "All containers have been stopped"
echo "========================================================" 