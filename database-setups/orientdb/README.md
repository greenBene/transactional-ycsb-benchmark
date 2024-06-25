# OrientDB Benchmark

## Setup the database
Run the following on the first node  
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
cp ./orientdb-server-config.xml ./orientdb-community-3.2.31/config/orientdb-server-config.xml
cp ./hazelcast.xml ./orientdb-community-3.2.31/config/hazelcast.xml

cd orientdb-community-3.2.31
./bin/dserver.sh 
```

Run the following on the second node
```bash
sudo mkdir -p /mnt/log/foundationdb /mnt/data
sudo chown azureadmin -R /mnt/log
sudo chown azureadmin -R /mnt/data

scp -r database-vm-0:./orientdb-community-3.2.31 ./

cd orientdb-community-3.2.31
nano ./config/orientdb-server-config.xml #Change nodeName parameter

./bin/dserver.sh 
```