FROM jupyter/all-spark-notebook:latest

USER root

# Install Apache Toree for Scala kernel
RUN pip install toree && \
    jupyter toree install --sys-prefix && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Set up Spark environment variables
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.9.5-src.zip

# Create a test notebook to verify Spark with Scala
RUN mkdir -p /home/$NB_USER/examples
COPY spark-scala-test.ipynb /home/$NB_USER/examples/
RUN chown -R $NB_USER:users /home/$NB_USER/examples

USER $NB_USER

# Verify Scala and Spark versions
RUN echo "Scala version: $(scala -version 2>&1 | grep -oP '(?<=version )[^:]+(?=\s--)')" && \
    echo "Spark version: $(spark-submit --version 2>&1 | grep -oP '(?<=version )[0-9.]+' | head -1)"

WORKDIR /home/$NB_USER/work 