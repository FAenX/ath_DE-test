FROM --platform=linux/amd64 spark:3.5.0-scala2.12-java17-ubuntu

# home
ARG SPARK_HOME=/opt/spark

# versions
ARG SPARK_VERSION=3.5.0
ARG HADOOP_VERSION=3.3.4
ARG AWS_SDK_VERSION=1.12.623
ARG SPARK_NLP_VERSION=5.2.0
ARG PYTHON_VERSION=3.11
ARG SPARK_LOG_DIR=/opt/spark/logs

# driver
ARG SPARK_DRIVER_MEMORY=16G

# executor
ARG SPARK_EXECUTOR_MEMORY=50G
ARG SPARK_EXECUTOR_CORES=16

# worker
ARG SPARK_WORKER_MEMORY=56G
ARG SPARK_WORKER_CORES=16
ARG SPARK_WORKER_PORT=7000
ARG SPARK_WORKER_LOG=/opt/spark/logs/spark-worker.out
ARG SPARK_WORKER_WEBUI_PORT=8080

# master
ARG SPARK_MASTER_LOG=/opt/spark/logs/spark-master.out
ARG SPARK_MASTER_WEBUI_PORT=8080
ARG SPARK_MASTER_PORT=7077

# Set Spark environment variables
ENV SPARK_MASTER_PORT=${SPARK_MASTER_PORT} \
    SPARK_MASTER_WEBUI_PORT=${SPARK_MASTER_WEBUI_PORT} \
    SPARK_LOG_DIR=${SPARK_LOG_DIR} \
    SPARK_MASTER_LOG=${SPARK_MASTER_LOG} \
    SPARK_WORKER_LOG=${SPARK_WORKER_LOG} \
    SPARK_WORKER_WEBUI_PORT=${SPARK_WORKER_WEBUI_PORT} \
    SPARK_WORKER_PORT=${SPARK_WORKER_PORT} \
    SPARK_WORKER_MEMORY=${SPARK_WORKER_MEMORY} \
    SPARK_DRIVER_MEMORY=${SPARK_DRIVER_MEMORY} \
    SPARK_EXECUTOR_MEMORY=${SPARK_EXECUTOR_MEMORY} \
    SPARK_WORKER_CORES=${SPARK_WORKER_CORES} \
    SPARK_EXECUTOR_CORES=${SPARK_EXECUTOR_CORES}

USER root

# Combine Commands
RUN apt-get update && \
    apt-get install -y \
        curl vim zip gcc make ssh net-tools ca-certificates \
        software-properties-common wget libssl-dev libffi-dev zlib1g-dev \
        unzip git libsqlite3-dev sqlite3 && \
    add-apt-repository ppa:deadsnakes/ppa && \
    add-apt-repository universe && \
    apt-get update && \
    apt-get install -y \
        python${PYTHON_VERSION} python${PYTHON_VERSION}-dev python${PYTHON_VERSION}-distutils python3-setuptools && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 100000 && \
    update-alternatives --config python3 && \
    curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py && \
    python3 get-pip.py


# Copy JAR files
RUN curl -L --output hadoop-aws-${HADOOP_VERSION}.jar  https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar && \
    curl -L --output aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_SDK_VERSION}/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar && \
    curl -L --output spark-nlp_2.12-${SPARK_NLP_VERSION}.jar  https://repo1.maven.org/maven2/com/johnsnowlabs/nlp/spark-nlp_2.12/${SPARK_NLP_VERSION}/spark-nlp_2.12-${SPARK_NLP_VERSION}.jar && \
    curl -L --output tensorflow-1.15.0.jar https://repo1.maven.org/maven2/org/tensorflow/tensorflow/1.15.0/tensorflow-1.15.0.jar && \
    curl -L --output ndarray-0.4.0.jar https://repo1.maven.org/maven2/org/tensorflow/ndarray/0.4.0/ndarray-0.4.0.jar && \
    curl -L --output tensorflow-core-platform-0.5.0.jar https://repo1.maven.org/maven2/org/tensorflow/tensorflow-core-platform/0.5.0/tensorflow-core-platform-0.5.0.jar && \
    curl -L --output delta-spark_2.12-3.0.0.jar https://repo1.maven.org/maven2/io/delta/delta-spark_2.12/3.0.0/delta-spark_2.12-3.0.0.jar && \
    curl -L --output delta-storage-3.0.0.jar  https://repo1.maven.org/maven2/io/delta/delta-storage/3.0.0/delta-storage-3.0.0.jar && \
    curl -L --output scala-library-2.12.4.jar https://repo1.maven.org/maven2/org/scala-lang/scala-library/2.12.4/scala-library-2.12.4.jar && \
    cp scala-library-2.12.4.jar ${SPARK_HOME}/jars/ && \
    cp delta-spark_2.12-3.0.0.jar ${SPARK_HOME}/jars/ && \
    cp delta-storage-3.0.0.jar ${SPARK_HOME}/jars/ && \
    cp tensorflow-core-platform-0.5.0.jar ${SPARK_HOME}/jars/ && \
    cp ndarray-0.4.0.jar ${SPARK_HOME}/jars/ && \
    cp tensorflow-1.15.0.jar ${SPARK_HOME}/jars/ && \
    cp spark-nlp_2.12-${SPARK_NLP_VERSION}.jar ${SPARK_HOME}/jars/ && \
    cp hadoop-aws-${HADOOP_VERSION}.jar ${SPARK_HOME}/jars/ && \
    cp aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar ${SPARK_HOME}/jars/

# Remove unnecessary files
RUN rm -rf hadoop-aws-${HADOOP_VERSION}.jar aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar spark-nlp_2.12-${SPARK_NLP_VERSION}.jar tensorflow-1.15.0.jar ndarray-0.4.0.jar tensorflow-core-platform-0.5.0.jar

# Set up spark directories
WORKDIR $SPARK_HOME
RUN mkdir -p $SPARK_LOG_DIR && \
    touch $SPARK_MASTER_LOG && \
    touch $SPARK_WORKER_LOG && \
    ln -sf /dev/stdout $SPARK_MASTER_LOG && \
    ln -sf /dev/stdout $SPARK_WORKER_LOG


# Set up user home and permissions
RUN adduser --disabled-password --gecos '' dev && \
    adduser dev sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    mkdir -p /home/dev/.ssh && \
    chown -R dev:dev /home/dev && \
    chown -R dev:dev /usr/local/ && \
    chown -R dev:dev $SPARK_HOME

# Set up user home and permissions
WORKDIR /home/dev

# Copy Python project files and install dependencies
COPY pyproject.toml poetry.lock ./

# Set up Python environment
ENV PATH="/usr/local/bin:${PATH}"
ENV PATH="/home/dev/.local/bin:${PATH}"
ENV PATH="/usr/local/bin/python3.11:${PATH}"

USER dev
