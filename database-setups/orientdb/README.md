# OrientDB Benchmark

## Setup the database
### Setup for first node
```bash
sudo apt-get update
sudo apt install -y default-jdk
wget https://repo1.maven.org/maven2/com/orientechnologies/orientdb-community/3.2.31/orientdb-community-3.2.31.tar.gz
tar -xf orientdb-community-3.2.31.tar.gz

sudo mkdir -p /mnt/log/foundationdb /mnt/data
sudo chown azureadmin -R /mnt/log
sudo chown azureadmin -R /mnt/data

wget https://raw.githubusercontent.com/greenBene/transactional-ycsb-benchmark/main/database-setups/orientdb/orientdb-server-config.xml
wget https://raw.githubusercontent.com/greenBene/transactional-ycsb-benchmark/main/database-setups/orientdb/hazelcast.xml
mv ./orientdb-server-config.xml ./orientdb-community-3.2.31/config/orientdb-server-config.xml
mv ./hazelcast.xml ./orientdb-community-3.2.31/config/hazelcast.xml

cd orientdb-community-3.2.31
export ORIENTDB_OPTS_MEMORY="-Xms7G -Xmx7G"
./bin/dserver.sh 
```

## Setup for further nodes
```bash
sudo apt-get update
sudo apt install -y default-jdk

sudo mkdir -p /mnt/log/foundationdb /mnt/data
sudo chown azureadmin -R /mnt/log
sudo chown azureadmin -R /mnt/data

scp -r database-vm-0:./orientdb-community-3.2.31 ./

cd orientdb-community-3.2.31
nano ./config/orientdb-server-config.xml #Change nodeName parameter
export ORIENTDB_OPTS_MEMORY="-Xms7G -Xmx7G"
./bin/dserver.sh 
```


## Setup Benchmark Executor
### Install Dependencies
```bash
sudo apt-get update
sudo apt install -y default-jdk
wget https://repo1.maven.org/maven2/com/orientechnologies/orientdb-community/3.2.31/orientdb-community-3.2.31.tar.gz
tar -xf orientdb-community-3.2.31.tar.gz

git clone https://github.com/greenBene/YCSB.git
cd ./YCSB
sudo apt-get install -y maven
mvn -e -Psource-run -pl site.ycsb:orientdb-binding -am clean package
```

### Setup testing database

```bash
./bin/console

orientdb> CONNECT remote:database-vm-0 root rootpwd
orientdb> CREATE DATABASE remote:database-vm-0/test root rootpwd PLOCAL
orientdb> DROP DATABASE test
```

### Running Benchmark

```bash
./bin/ycsb.sh load orientdb -s -P workloads/workloadt  -p orientdb.url=remote:database-vm-0/test -p orientdb.server.user=root -p orientdb.server.password=rootpwd -p orientdb.user=root -p orientdb.password=rootpwd
./bin/ycsb.sh run orientdb -s -P workloads/workloadt  -p orientdb.url=remote:database-vm-0/test -p orientdb.server.user=root -p orientdb.server.password=rootpwd -p orientdb.user=root -p orientdb.password=rootpwd -threads 10
```