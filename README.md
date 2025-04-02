# arXiv Data Analysis with Spark and Elasticsearch

This project demonstrates how to analyze and search the arXiv academic paper dataset using Apache Spark for distributed data processing and Elasticsearch for search capabilities. The project implements several data processing workflows to analyze, classify, and search arXiv papers.

## Project Overview

The arXiv dataset contains metadata for over 2.6 million scientific papers, including titles, abstracts, authors, categories, and more. This project provides a set of Jupyter notebooks that demonstrate:

1. Text processing and analysis of academic papers
2. Citation network analysis
3. Building machine learning models for paper classification and clustering
4. Creating a powerful search engine for academic papers using Elasticsearch

## Getting Started

### Prerequisites

- Docker and Docker Compose
- At least 8GB of RAM allocated to Docker
- Approximately 5GB of disk space for Elasticsearch

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

## Technologies Used

- **Apache Spark**: For distributed data processing and machine learning
- **Elasticsearch**: For building a scalable search engine
- **PySpark**: For data transformation and ML pipelines
- **Docker**: For containerization and deployment
- **Jupyter Notebooks**: For interactive analysis and visualization

## Data

The data files are not included in this repository. You can download them from these sources:

1. **arXiv Metadata**: Available on [Kaggle](https://www.kaggle.com/Cornell-University/arxiv)
2. **Citation Network Data**: Available from [Matt Bierbaum's arXiv public datasets](https://github.com/mattbierbaum/arxiv-public-datasets/releases/tag/v0.2.0)

Place the data files in the `data/` directory before running the notebooks.

## Current Notebooks

### 1. [preprocess-references.ipynb](notebooks/preprocess-references.ipynb)

A notebook focused on processing citation data from arXiv papers. It includes:

- Loading and examining the JSON structure of internal references data
- Converting the reference data to a more usable DataFrame format
- Exporting the processed citation network to Parquet format for efficient storage and retrieval
- Creating a clean, structured dataset for citation network analysis

### 2. [index-papers-with-refs-to-elasticsearch.ipynb](notebooks/index-papers-with-refs-to-elasticsearch.ipynb)

This notebook demonstrates how to process and index arXiv academic papers along with their citation networks into Elasticsearch. It includes:

- Loading and cleaning arXiv metadata (2.6+ million papers)
- Normalizing text fields and transforming categories into arrays
- Integrating citation network data to enhance paper metadata with citation information
- Text processing including tokenization and TF-IDF calculation
- Creating custom Elasticsearch mappings and analyzers for optimal search performance
- Building document similarity features using text vectorization
- Enabling complex queries that combine content similarity with citation network analysis
- Demonstrating bulk indexing optimizations for performance with millions of documents

### 3. [arxiv-supervised-classification.ipynb](notebooks/arxiv-supervised-classification.ipynb)

This notebook applies supervised machine learning techniques to classify arXiv papers based on title and abstract text. Key features include:

- Using PySpark's ML library for text processing and classification
- Implementing TF-IDF vectorization to transform text into numerical features
- Training a multinomial logistic regression model for multi-class classification
- Achieving approximately 62% accuracy across 100+ scientific categories
- Analyzing per-category performance with some categories (Computer Vision, Quantum Physics) showing strong accuracy (80-89%)
- Discussing limitations of single-label classification and suggesting multi-label approaches for future work

### 4. [arxiv-k-means.ipynb](notebooks/arxiv-k-means.ipynb)

This notebook explores unsupervised learning to discover clusters in the arXiv paper corpus. It covers:

- Applying K-means clustering to identify natural groupings in research papers
- Using TF-IDF vectorization and dimensionality reduction techniques
- Evaluating optimal clusters using the Elbow Method and silhouette scores
- Identifying limitations of K-means for academic papers (weak cluster separation, fuzzy boundaries)
- Comparing K-means with Latent Dirichlet Allocation (LDA) for topic modeling
- Implementing LDA to discover thematic topics across research papers
- Demonstrating how to integrate discovered topics into Elasticsearch for enhanced search capabilities

## Working with Elasticsearch

To connect to Elasticsearch from your notebooks, use the following configuration:

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("Arxiv-Index-into-Elasticsearch") \
    .master("local[*]") \
    .config("spark.jars.packages", "org.elasticsearch:elasticsearch-spark-30_2.12:8.8.2") \
    .getOrCreate()

# To write to Elasticsearch
df.write \
    .format("org.elasticsearch.spark.sql") \
    .option("es.nodes", "elasticsearch") \
    .option("es.port", "9200") \
    .option("es.resource", "index_name") \
    .option("es.mapping.id", "id") \
    .option("es.write.operation", "upsert") \
    .mode("append") \
    .save()
```

### Testing the Connection

To verify that the Jupyter container can connect to Elasticsearch, run the following code in a notebook:

```python
import requests
response = requests.get("http://elasticsearch:9200")
print(response.json())
```

## Troubleshooting

If you encounter connection issues between containers, try these solutions:

1. Verify that all services are running with `docker-compose ps`
2. Check Elasticsearch logs with `docker-compose logs elasticsearch`
3. Ensure that the Elasticsearch service is healthy before attempting connections
4. If using Docker Desktop, allocate sufficient memory (at least 4GB)
5. Make sure both containers are running on the same network:
   ```bash
   docker network inspect arxiv-elastic-net
   ```
6. Check the container IP addresses:
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
