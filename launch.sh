
set -e
set -x

PYTHON_DIR=$PWD/python
JAVA_DIR=$PWD/jdk1.8.0_151
SPARK_DIR=$PWD/spark-2.2.0-bin-hadoop2.7
export PATH=$PYTHON_DIR/bin:$PATH
export PATH=$JAVA_DIR/bin:$PATH
export PATH=$SPARK_DIR/bin:$SPARK_DIR/sbin:$PATH
export PYSPARK_PYTHON=python3

export SPARK_HOST=`hostname -i`
export SPARK_PORT=10001
export SPARK_MASTER_URL="spark://$SPARK_HOST:$SPARK_PORT"

start-master.sh -h $SPARK_HOST -p $SPARK_PORT

condor_submit worker.sub

echo "Waiting for master to start..."
sleep 5

curl http://localhost:8080/json/

condor_q

pyspark --master $SPARK_MASTER_URL --executor-cores 2 --executor-memory 2G --conf "spark.driver.port=10003"
