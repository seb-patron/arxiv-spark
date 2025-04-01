# arXiv Data Analysis with Spark and Elasticsearch

This project provides tools and infrastructure for analyzing arXiv scientific papers using Apache Spark and Elasticsearch. It serves as a platform for exploring the rich dataset of academic papers, their metadata, and citation networks available through arXiv.

## About the Project

The arXiv-Elasticsearch project allows researchers and data scientists to:

- Work with large-scale arXiv metadata and full-text data
- Build and analyze citation networks between papers
- Index papers for efficient search and retrieval
- Apply machine learning and NLP techniques to academic content
- Visualize relationships between papers, authors, and research domains

## Getting Started

### Prerequisites

- Docker and Docker Compose
- At least 8GB of RAM allocated to Docker
- Approximately 5GB of disk space for Elasticsearch and container images

### Starting the Environment

To start both Elasticsearch and Jupyter/Spark containers with proper networking:

```bash
./start-containers.sh
```

This script:
1. Creates a custom Docker network called `arxiv-elastic-net`
2. Starts the Elasticsearch container connected to this network
3. Starts the Jupyter/Spark container connected to the same network

Alternatively, you can start just the Elasticsearch container:

```bash
./start-elasticsearch.sh
```

Or launch just the Jupyter notebook environment:

```bash
./start-spark-notebook.sh
```

## Current Notebooks

The repository currently includes these example notebooks, with more to be added:

- **index-papers-with-refs-to-elasticsearch-Copy1.ipynb**: One approach to indexing arXiv papers with citation information
- **preprocess-references.ipynb**: Preprocessing pipeline for arXiv reference data
- **arxiv-k-means.ipynb**: Experimental clustering of papers using k-means

## Data

This project works with arXiv metadata and references. The data files are not included in the repository due to their size but can be downloaded from:
- [arXiv Metadata](https://www.kaggle.com/datasets/Cornell-University/arxiv) - Comprehensive metadata for arXiv papers
- Citation networks can be extracted from paper PDFs using the preprocessing notebooks

## Working with Elasticsearch

When using the Elasticsearch connector in your notebooks, use the following configuration:

```python
# Python example using Spark-Elasticsearch connector
es_write_conf = {
    "es.nodes": "elasticsearch",  # Use container name as hostname
    "es.port": "9200",
    "es.resource": "your_index",
    "es.nodes.wan.only": "true"
}

# Write DataFrame to Elasticsearch
df.write.format("org.elasticsearch.spark.sql").options(**es_write_conf).mode("append").save()
```

### Testing the Connection

To verify that the Jupyter container can connect to Elasticsearch, run the following code in a notebook:

```python
import requests
response = requests.get("http://elasticsearch:9200")
print(response.json())
```

## Troubleshooting

If you encounter connectivity issues:

1. Make sure both containers are running on the same network:
   ```bash
   docker network inspect arxiv-elastic-net
   ```

2. Check that Elasticsearch is running:
   ```bash
   curl http://localhost:9200
   ```

3. Check the container IP addresses:
   ```bash
   docker inspect elasticsearch | grep IPAddress
   docker inspect jupyter-spark | grep IPAddress
   ```

## Project Structure

```
arXiv-Elasticsearch/
├── data/                  # Data files (gitignored)
├── notebooks/             # Jupyter notebooks for analysis
├── src/                   # Source code for modules/packages
├── Dockerfile             # Custom Docker configuration
├── start-containers.sh    # Script to start all containers
├── start-elasticsearch.sh # Script to start Elasticsearch
├── start-spark-notebook.sh # Script to start Jupyter/Spark
└── README.md              # This documentation
```

## Acknowledgements

This project is based on the [Spark Project Starter](https://github.com/seb-patron/spark-project-starter) template, which provides a quick and easy way to start a new Apache Spark project with support for both Scala and Python.
