#!/bin/bash

# Script to start Jupyter notebook with Apache Spark and Scala support

# Function to add a package to requirements.txt if it doesn't exist
add_package() {
  if ! grep -q "^$1" requirements.txt; then
    echo "$1" >> requirements.txt
    echo "Added $1 to requirements.txt"
  else
    echo "Package $1 already exists in requirements.txt"
  fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --add-package)
      if [ -n "$2" ]; then
        # Create requirements.txt if it doesn't exist
        if [ ! -f "requirements.txt" ]; then
          echo "# Python packages required for ML-Citation-Graph project" > requirements.txt
          echo "# Add other required packages below" >> requirements.txt
        fi
        add_package "$2"
        shift 2
      else
        echo "Error: --add-package requires a package name"
        exit 1
      fi
      ;;
    --list-packages)
      if [ -f "requirements.txt" ]; then
        echo "Packages in requirements.txt:"
        grep -v "^#" requirements.txt | grep -v "^$" | sed 's/^/  - /'
      else
        echo "requirements.txt does not exist yet."
      fi
      exit 0
      ;;
    --help)
      echo "Usage: $0 [options]"
      echo "Options:"
      echo "  --add-package <package>  Add a package to requirements.txt"
      echo "  --list-packages          List all packages in requirements.txt"
      echo "  --help                   Show this help message"
      exit 0
      ;;
    *)
      break
      ;;
  esac
done

# Check if requirements.txt exists, create if it doesn't
if [ ! -f "requirements.txt" ]; then
  echo "# Python packages required for ML-Citation-Graph project" > requirements.txt
  echo "feedparser>=6.0.0" >> requirements.txt
  echo "# Add other required packages below" >> requirements.txt
  echo "Created requirements.txt with initial packages"
else
  echo "Using existing requirements.txt file with these packages:"
  grep -v "^#" requirements.txt | grep -v "^$" | sed 's/^/  - /'
  echo ""
  echo "Tip: To add more packages, use: $0 --add-package <package_name>"
fi

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
  
  # Run the container with requirements.txt
  echo "Starting the container..."
  echo "Installing packages from requirements.txt..."
  docker run -it --rm \
    -p 8888:8888 \
    -v "$PWD":/home/jovyan/work \
    --entrypoint /bin/bash $IMAGE -c "pip install --quiet -r /home/jovyan/work/requirements.txt && start.sh jupyter lab"

elif [ "$option_choice" = "2" ]; then
  # Build custom image
  echo "Building custom Spark+Scala image..."
  
  # Create a Dockerfile if it doesn't exist
  if [ ! -f "Dockerfile" ]; then
    echo "Creating a Dockerfile..."
    cat > Dockerfile << EOL
FROM jupyter/all-spark-notebook:latest

USER root

# Install Python packages from requirements.txt
COPY requirements.txt /tmp/
RUN pip install --quiet -r /tmp/requirements.txt

USER \${NB_UID}
EOL
  else
    # Update existing Dockerfile to ensure requirements.txt is used
    if ! grep -q "requirements.txt" Dockerfile; then
      echo "Updating Dockerfile to use requirements.txt..."
      sed -i '' '/USER root/a\\
# Install Python packages from requirements.txt\\
COPY requirements.txt /tmp/\\
RUN pip install --quiet -r /tmp/requirements.txt\\
' Dockerfile
    fi
  fi
  
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
  
  # Run the container with requirements.txt
  echo "Starting the container..."
  echo "Installing packages from requirements.txt..."
  docker run -it --rm \
    -p 8888:8888 \
    -v "$PWD":/home/jovyan/work \
    --entrypoint /bin/bash $IMAGE -c "pip install --quiet -r /home/jovyan/work/requirements.txt && /usr/local/bin/start.sh jupyter lab"

else
  echo "Invalid choice. Using default jupyter/all-spark-notebook"
  IMAGE="jupyter/all-spark-notebook"
  
  # Pull the latest image
  echo "Pulling the latest $IMAGE image..."
  docker pull $IMAGE
  
  # Run the container with requirements.txt
  echo "Starting the container..."
  echo "Installing packages from requirements.txt..."
  docker run -it --rm \
    -p 8888:8888 \
    -v "$PWD":/home/jovyan/work \
    --entrypoint /bin/bash $IMAGE -c "pip install --quiet -r /home/jovyan/work/requirements.txt && start.sh jupyter lab"
fi 