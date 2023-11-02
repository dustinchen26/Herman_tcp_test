# Install dependencies
```
sudo apt install iperf3 gnuplot jq
```

## Usage
```bash
# ./test.sh -B <host_ip> -p <server_port> -c <server_ip> -C <tcp congestion> -l <loop times> -t <test second>

./test.sh -B 192.168.99.82 -p 5201 -c 192.168.99.246 -C cubic -l 2 -t 3
```