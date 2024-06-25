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

sudo mv ./mongod.conf /etc/mongo.conf
```

For each node
* Add the local ip in `/etc/mongod.conf` to `net.bindIp:`. 
* Restart the service via `sudo systemctl restart mongod`


In one node, execute the following to setup the replication set
```bash
mongosh <<EOF
  var cfg = {
    _id: "rs0",
    members: [
        { _id: 0, host: "10.0.2.4" },
        { _id: 1, host: "10.0.2.5" }
    ]
    };
  rs.initiate(cfg);
EOF
```