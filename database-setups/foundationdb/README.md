# How to Setup the FoundationDB Cluster

## Setup of Cluster
For each node:
```bash
# Download FoundationDB client + server
wget https://github.com/apple/foundationdb/releases/download/6.3.23/foundationdb-clients_6.3.23-1_amd64.deb
wget https://github.com/apple/foundationdb/releases/download/6.3.23/foundationdb-server_6.3.23-1_amd64.deb
wget https://raw.githubusercontent.com/greenBene/transactional-ycsb-benchmark/main/database-setups/foundationdb/foundationdb.conf
sudo dpkg -i foundationdb-clients_6.3.23-1_amd64.deb foundationdb-server_6.3.23-1_amd64.deb
sudo mkdir -p /mnt/log/foundationdb /mnt/data
sudo chown -R foundationdb /mnt/log
sudo chown -R foundationdb /mnt/data
sudo cp ./foundationdb.conf /etc/foundationdb/foundationdb.conf
```


Make one node public: 
```bash
sudo python3 /usr/lib/foundationdb/make_public.py
```


For all other nodes, copy cluste file from first node and restart local instance
```bash
sudo sudo scp azureadmin@database-vm-0:/etc/foundationdb/fdb.cluster /etc/foundationdb/fdb.cluster
sudo service foundationdb restart
```

Configure database on any node
```bash
fdbcli
fdb> configure new double ssd
fdb> coordinators auto
``` 

## Setup of Benchmark Executor 

```bash
# Install fdb-client
wget https://github.com/apple/foundationdb/releases/download/6.3.23/foundationdb-clients_6.3.23-1_amd64.deb
sudo dpkg -i foundationdb-clients_6.3.23-1_amd64.deb

# Preape local YCSB and compile for foundationdb
git clone https://github.com/greenBene/YCSB.git
cd ./YCSB
sudo apt-get update
sudo apt install -y default-jdk
sudo apt-get install -y maven
mvn -e -Psource-run -pl site.ycsb:foundationdb-binding -am clean package

# Setup connection to foundationdbcluster
scp azureadmin@database-vm-0:/etc/foundationdb/fdb.cluster ./

```

## Running Benchmark

```bash
# Loading dataset
./bin/ycsb.sh load foundationdb -s -P workloads/workloadt -threads 10

# Running benchmark
./bin/ycsb.sh run foundationdb -s -P workloads/workloadt -threads 10
# TODO: Add different run configurations
```