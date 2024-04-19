#!/bin/bash

echo -e "Top 10 DNS requests from nsodd1.. Please Wait"

# Parsing DNS Request
tcpdump -i enp2s0f0 port 53 and not src 61.100.13 -c 10000 -w temp_dnstop.pcap > /dev/null 2>&1      // 네트워크 랑 not src 부분 수정  // 61.100.13에서 들어오는 건 뺏음
sleep 1


dnstop temp_dnstop.pcap > temp.log
# Request Top 10
cat temp.log | head -n 12
sleep 1

rm -f temp_dnstop.pcap
rm -f temp.log
sleep 1
~