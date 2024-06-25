# Executing the Benchmark Experiments 

## General Prep
```bash
git clone https://github.com/greenBene/YCSB.git
cd ./YCSB
sudo apt-get update
sudo apt install default-jdk
sudo apt-get install maven




./bin/ycsb.sh load foundationdb -s -P workloads/workloadt -threads 10

```

## Foundation DB
```bash
# Compile
mvn -e -Psource-run -pl site.ycsb:foundationdb-binding -am clean package

# Get cluster file to reach it 
cp /etc/foundationdb/fdb.cluster ./

./bin/ycsb.sh load foundationdb -s -P workloads/workloadt -threads 10
```

## MongoDB
```bash
mvn -e -Psource-run -pl site.ycsb:mongodb-binding -am clean package
./bin/ycsb.sh load mongodb -s -P workloads/workloadt -threads 10
```

## OrientDB
```bash
mvn -e -Psource-run -pl site.ycsb:orientdb-binding -am clean package
./bin/ycsb.sh load orientdb -s -P workloads/workloadt -threads 10
```