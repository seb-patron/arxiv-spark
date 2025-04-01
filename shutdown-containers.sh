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
  # Try to stop normally first
  docker stop elasticsearch || {
    echo "Normal stop failed, forcing removal of Elasticsearch container..."
    docker rm -f elasticsearch
  }
  echo "Elasticsearch container stopped"
else
  echo "No running Elasticsearch container found"
fi

# Remove the Docker network if it exists
echo "Removing Docker network..."
if docker network inspect arxiv-elastic-net >/dev/null 2>&1; then
  docker network rm arxiv-elastic-net || {
    echo "Could not remove network directly, trying to disconnect containers first..."
    for container in $(docker network inspect arxiv-elastic-net -f '{{range .Containers}}{{.Name}} {{end}}'); do
      docker network disconnect -f arxiv-elastic-net $container || true
    done
    docker network rm arxiv-elastic-net
  }
  echo "Docker network arxiv-elastic-net removed"
else
  echo "Docker network arxiv-elastic-net not found"
fi

echo ""
echo "All containers have been stopped and network removed"
echo "========================================================" 