# How to Setup the FoundationDB Cluster

For each node:
```bash
# Download FoundationDB client + server
wget https://github.com/apple/foundationdb/releases/download/6.3.23/foundationdb-clients_6.3.23-1_amd64.deb
wget https://github.com/apple/foundationdb/releases/download/6.3.23/foundationdb-server_6.3.23-1_amd64.deb
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
scp [ip]:/etc/foundationdb/fdb.cluster /etc/foundationdb/fdb.cluster
sudo service foundationdb restart
```

Configure database on any node
```bash
fdbcli
fdb> configure new double ssd
fdb> coordinators auto
``` 



Then:
* Make one node public: `sudo python3 /usr/lib/foundationdb/make_public.py`
* For all other nodes:
    * Copy from first node cluster file `scp [ip]:/etc/foundationdb/fdb.cluster /etc/foundationdb/fdb.cluster`
    * Restart local fdb instance `
* On any node, configure database `fdb> configure new double ssd`