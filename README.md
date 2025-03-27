# Spark Project Starter

This repository provides a quick and easy way to start a new Apache Spark project with support for both Scala and Python. It includes a script to launch a Jupyter notebook environment with all the necessary components pre-configured.

## Getting Started

### Clone the Repository

To use this starter for a new project:

```bash
# Clone the repository
git clone https://github.com/seb-patron/spark-project-starter.git my-spark-project

# Navigate to your new project directory
cd my-spark-project

# Optional: Remove the git history to start fresh
rm -rf .git
git init
```

### Launch the Jupyter Notebook Environment

Run the following command to start the Jupyter notebook server:

```bash
./start-spark-notebook.sh
```

The script will prompt you to choose between:

1. **Use jupyter/all-spark-notebook** (simplest option, default)
2. **Build custom image** with both Spark and Scala pre-configured
3. **Use almondsh/almond** (for Scala focus)

## Available Options

### Option 1: jupyter/all-spark-notebook (Default)

This is the simplest option and uses the official Jupyter Docker image with Apache Spark pre-installed.

**Includes:**
- Jupyter Lab/Notebook
- Apache Spark 3.5.0 with Hadoop 3
- Python 3 kernel
- R kernel

**Does not include:**
- Scala kernel (needs to be installed manually if needed)

If you need to use Scala with Spark, you'll need to install the Apache Toree kernel after starting the container. See the [Adding Scala to jupyter/all-spark-notebook](#manually-adding-scala-to-jupyterall-spark-notebook) section below.

### Option 2: Custom Spark+Scala Image

This option builds a custom Docker image that includes:

- Jupyter Lab/Notebook
- Apache Spark 3.5.0 with Hadoop 3
- Scala kernel (Apache Toree) pre-configured to work with Spark
- Python and R kernels

This custom image solves the problem of having to manually configure Spark and Scala to work together, giving you a seamless experience for working with Spark in both Scala and Python.

### Option 3: almondsh/almond (Scala Focus)

This option uses a specialized Docker image for Scala development in Jupyter.

**Includes:**
- Jupyter Lab/Notebook
- Multiple Scala kernels:
  - Scala 2.12
  - Scala 2.13
  - Scala 3.6
- Python 3 kernel

**Does not include:**
- Apache Spark (needs to be installed manually if needed)

This option is best if you're primarily focused on learning Scala rather than Spark.

## Example Notebooks

This repository includes example notebooks to help you get started:

- `spark-scala-example.ipynb`: Demonstrates Spark operations using Scala
- `spark-python-example.ipynb`: Demonstrates Spark operations using Python (PySpark)

These notebooks include examples of:
- Creating and manipulating DataFrames
- Performing transformations and actions
- Using SQL queries with Spark
- Working with RDDs
- Implementing word count algorithms

## Recommended Scala Version for Spark

If you're using Scala with Apache Spark, here are some recommendations:

- **Scala 2.12**: This is the most compatible version for Spark 3.x. Most Spark 3.x versions (including 3.5.0 in the jupyter/all-spark-notebook image) are built against Scala 2.12.
- **Scala 2.13**: Supported in newer Spark versions, but may have some compatibility issues with certain libraries.
- **Scala 3.x**: Still gaining adoption in the Spark ecosystem. Not recommended for beginners unless you specifically need Scala 3 features.

For beginners, **Scala 2.12** is recommended as it has the best compatibility with Spark and the widest range of available libraries and examples.

## Manually Adding Scala to jupyter/all-spark-notebook

If you're using the jupyter/all-spark-notebook image (Option 1) and need Scala support:

1. Start the container with `./start-spark-notebook.sh` and select option 1
2. Open a terminal in Jupyter Lab
3. Run the following commands:
   ```bash
   pip install toree
   jupyter toree install --user
   ```
4. Restart the Jupyter kernel

## Manually Adding Spark to almondsh/almond

If you're using the almondsh/almond image (Option 3) and need Spark support:

1. Start the container with `./start-spark-notebook.sh` and select option 3
2. Open a terminal in Jupyter Lab
3. Install Spark dependencies (this is more complex and may require creating a custom Docker image)

## Troubleshooting

### Port Already in Use

If you see an error like "port is already allocated", you may have another container running. Stop it with:

```bash
docker ps
docker stop <container_id>
```

### Kernel Not Available

If a kernel isn't showing up in Jupyter Lab:

1. Open a terminal in Jupyter Lab
2. Run: `jupyter kernelspec list` to see available kernels
3. If needed, install the appropriate kernel

## Project Structure

When starting a new Spark project, consider organizing your files like this:

```
my-spark-project/
├── data/                  # Data files
├── notebooks/             # Jupyter notebooks
│   ├── exploration/       # Exploratory analysis
│   └── production/        # Production-ready notebooks
├── src/                   # Source code for modules/packages
│   ├── python/            # Python modules
│   └── scala/             # Scala modules
├── tests/                 # Test files
├── Dockerfile             # Custom Docker configuration
├── README.md              # Project documentation
└── start-spark-notebook.sh # Script to start the environment
```

## Additional Resources

- [Apache Spark Documentation](https://spark.apache.org/docs/latest/)
- [Scala Documentation](https://docs.scala-lang.org/)
- [PySpark Documentation](https://spark.apache.org/docs/latest/api/python/index.html)
- [Apache Toree Documentation](https://toree.apache.org/)
- [Almond - Scala Kernel for Jupyter](https://almond.sh/)
- [Jupyter Docker Stacks Documentation](https://jupyter-docker-stacks.readthedocs.io/)
