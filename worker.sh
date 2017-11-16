#!/bin/bash

set -e

TARBALL=$1
SPARK_MASTER_URL=$2

if [ -z "$TARBALL" ]
then
    echo "Tarball not provided; exiting"
    exit -1
fi

if [ -z "$SPARK_MASTER_URL" ]
then
    echo "Spark master URL not provided; exiting"
    exit -1
fi

shift 2

echo "Unpacking $TARBALL..."
tar -xvzf $TARBALL

echo "Setting up paths"

PYTHON_DIR=$PWD/python
JAVA_DIR=$PWD/jdk1.8.0_151
SPARK_DIR=$PWD/spark-2.2.0-bin-hadoop2.7
export PATH=$PYTHON_DIR/bin:$PATH
export PATH=$JAVA_DIR/bin:$PATH
export PATH=$SPARK_DIR/bin:$SPARK_DIR/sbin:$PATH
export PYSPARK_PYTHON=python3

SPARK_NO_DAEMONIZE=1 start-slave.sh $SPARK_MASTER_URL $*

echo "Done"
