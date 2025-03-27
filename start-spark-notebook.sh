#!/bin/bash

# Script to start Jupyter notebook with Apache Spark and Scala support

# Print banner
echo "========================================================"
echo "  Starting Jupyter Notebook with Spark and Scala"
echo "========================================================"
echo ""
echo "This script provides several options:"
echo ""
echo "1) Use jupyter/all-spark-notebook (simplest option)"
echo "   - Includes Spark, Python, and R"
echo "   - Requires manual Scala setup if needed"
echo ""
echo "2) Build custom image with Spark and Scala pre-configured"
echo "   - Includes Spark, Scala, Python, and R"
echo "   - Everything works together out of the box"
echo ""
echo "3) Use almondsh/almond (for Scala focus)"
echo "   - Includes multiple Scala kernels"
echo "   - Requires manual Spark setup if needed"
echo ""
echo "Access the notebook at: http://localhost:8888"
echo "(A token will be provided in the console output)"
echo ""
echo "Press Ctrl+C to stop the container when finished"
echo "========================================================"
echo ""

# Ask which option to use
echo "Choose an option:"
echo "1) Use jupyter/all-spark-notebook (simplest option)"
echo "2) Build custom image with Spark and Scala pre-configured"
echo "3) Use almondsh/almond (for Scala focus)"
read -p "Enter choice [1]: " option_choice

# Set default if no choice is made
option_choice=${option_choice:-1}

if [ "$option_choice" = "1" ]; then
  # Use jupyter/all-spark-notebook
  IMAGE="jupyter/all-spark-notebook"
  echo "Using jupyter/all-spark-notebook image"
  echo "NOTE: You'll need to manually install the Scala kernel if needed. See README.md for instructions."
  
  # Pull the latest image
  echo "Pulling the latest $IMAGE image..."
  docker pull $IMAGE
  
  # Run the container
  echo "Starting the container..."
  docker run -it --rm \
    -p 8888:8888 \
    -v "$PWD":/home/jovyan/work \
    $IMAGE

elif [ "$option_choice" = "2" ]; then
  # Build custom image
  echo "Building custom Spark+Scala image..."
  docker build -t spark-scala-notebook .
  
  # Run the custom container
  echo "Starting the container with custom image..."
  docker run -it --rm \
    -p 8888:8888 \
    -v "$PWD":/home/jovyan/work \
    spark-scala-notebook

elif [ "$option_choice" = "3" ]; then
  # Use almondsh/almond
  IMAGE="almondsh/almond:latest"
  echo "Using almondsh/almond image for better Scala support"
  echo "NOTE: You'll need to manually install Spark if needed. See README.md for instructions."
  
  # Pull the latest image
  echo "Pulling the latest $IMAGE image..."
  docker pull $IMAGE
  
  # Run the container
  echo "Starting the container..."
  docker run -it --rm \
    -p 8888:8888 \
    -v "$PWD":/home/jovyan/work \
    $IMAGE

else
  echo "Invalid choice. Using default jupyter/all-spark-notebook"
  IMAGE="jupyter/all-spark-notebook"
  
  # Pull the latest image
  echo "Pulling the latest $IMAGE image..."
  docker pull $IMAGE
  
  # Run the container
  echo "Starting the container..."
  docker run -it --rm \
    -p 8888:8888 \
    -v "$PWD":/home/jovyan/work \
    $IMAGE
fi 