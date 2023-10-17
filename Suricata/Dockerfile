FROM ubuntu

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y iproute2 && \
    apt-get install -y nano && \
    apt-get install -y software-properties-common && \ 
    add-apt-repository -y ppa:oisf/suricata-stable && \
    apt-get update && \
    apt-get install -y curl &&\
    apt-get install -y zabbix-agent && \
    apt-get install -y suricata  

  
    
COPY suricata.yaml /etc/suricata/suricata.yaml
COPY zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf
COPY ddos.rules /etc/suricata/rules/ddos.rules
CMD  tail -f /dev/null 
     
   
