# MongoDB Benchmark

# Setup cluster

```bash
sudo apt-get install gnupg curl
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt-get update

sudo apt-get install -y mongodb-org=7.0.11 mongodb-org-database=7.0.11 mongodb-org-server=7.0.11 mongodb-mongosh=2.2.10 mongodb-org-mongos=7.0.11 mongodb-org-tools=7.0.11

sudo mkdir -p /mnt/log/mongodb /mnt/data/mongodb
sudo chown -R mongodb /mnt/log
sudo chown -R mongodb /mnt/data


wget https://raw.githubusercontent.com/greenBene/transactional-ycsb-benchmark/main/database-setups/mongodb/mongod.conf
wget https://raw.githubusercontent.com/greenBene/transactional-ycsb-benchmark/main/database-setups/mongodb/disable-transparent-huge-pages.service


sudo mv ./mongod.conf /etc/mongod.conf
sudo mv ./disable-transparent-huge-pages.service /etc/systemd/system/disable-transparent-huge-pages.service
sudo systemctl daemon-reload
sudo systemctl start disable-transparent-huge-pages
sudo systemctl enable disable-transparent-huge-pages
```

For each node
```bash
sudo nano /etc/mongod.conf # add local IP to net.bindIp: 
sudo nano /etc/sysctl.conf # add "vm.max_map_count = 262144" to end of file
sudo sysctl -p

sudo systemctl restart mongod
```


In one node, execute the following to setup the replication set. Update the host ips accordingly.
```bash
mongosh <<EOF
  var cfg = {
    _id: "rs0",
    members: [
        { _id: 0, host: "10.0.2.6" },
        { _id: 1, host: "10.0.2.5" }
    ]
    };
  rs.initiate(cfg);
EOF
```

## Setup YCSB

```bash
# Preape local YCSB and compile for foundationdb
git clone https://github.com/greenBene/YCSB.git
cd ./YCSB
sudo apt-get update
sudo apt install -y default-jdk
sudo apt-get install -y maven
mvn -e -Psource-run -pl site.ycsb:mongodb-binding -am clean package
```

## Run YCSB
```bash
./bin/ycsb.sh load mongodb -s -P workloads/workloadt -threads 10 -p mongodb.url=mongodb://10.0.2.6:27017/ycsb
./bin/ycsb.sh run mongodb -s -P workloads/workloadt -threads 10 -p mongodb.url=mongodb://10.0.2.6:27017/ycsb
```