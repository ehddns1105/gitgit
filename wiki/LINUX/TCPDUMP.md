ex)
tcpdump -nn tcp and "tcp[13] == 2" and "not port 10050" and "not port 10051" and "not port 19997" and "not src 10.11.10.115" and "not src 10.11.11.215" and "not src 10.11.1.110"

tcpdump -i ens5 port 53


``````
-n: 호스트 이름 및 포트 번호를 숫자로 표시
-nn: DNS 이름 변환 비활성화
 
tcpdump -i eth0 src 10.30.30.10 and "tcp[13] == 0x02" -w syndumpbin.log &
 
tcpdump -i eth0 src 10.30.30.10 and "tcp[13] == 0x02" > syndump.log &
 
tcpdump -i eth0 "tcp[13] == 0x02" -n -nn > syndump.log &
 
옵션 이렇게 줘서 쓰고있습니다.
-w 로 파일을 떨구면 wireshark에서 분석 가능한 bin파일로 떨어지고 
>로 redirection을 걸면 text파일로 떨어집니다.


tcp[13] == 0x02 -> SYN 패킷만
``````