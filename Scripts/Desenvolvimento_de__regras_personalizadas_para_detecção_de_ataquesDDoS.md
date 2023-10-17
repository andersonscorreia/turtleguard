Atividade: Criação de regras personalizadas para detecção de ataques DDoS 
Descrição: Desenvolvimento de regras específicas para a detecção de ataques DDoS 
Responsável: Diego de Lima
Resultados esperados: Conjunto de regras personalizadas para detecção de ataques DDoS


# Desenvolvimento de regras personalizadas para detecção de ataques DDoS

A segurança cibernética é uma prioridade para empresas e organizações que precisam garantir a disponibilidade e a integridade de seus sistemas e serviços online. Um dos tipos de ataque mais frequentes e nocivos é o DDoS (Distributed Denial of Service), que tem como objetivo sobrecarregar os recursos de rede e servidor, impedindo o acesso dos usuários legítimos.

Para se defender de ataques DDoS, é fundamental adotar medidas de detecção e mitigação apropriadas. Uma das formas de reforçar sua segurança é usar o iptables, um firewall muito usado no mundo Linux, para aplicar regras específicas de detecção de ataques DDoS.

As regras a seguir foram elaboradas com base em boas práticas e podem ser ajustadas conforme as necessidades e requisitos do seu ambiente. Elas visam limitar a taxa de pacotes ICMP, conexões TCP, pacotes UDP e conexões HTTP, auxiliando a identificar e mitigar ataques DDoS de maneira mais eficiente.


### 1. Regra: Detecção de tráfego anormal de UDP com alto volume
   - Descrição: Esta regra visa identificar o tráfego UDP com um volume anormalmente alto, que pode ser um indicativo de um ataque DDoS.
   - Condição: source_ip: any, destination_port: any, protocol: UDP, packet_count > X (valor a ser definido com base no ambiente)


   Limitar a taxa de pacotes UDP:
```bash
iptables -A INPUT -p udp -m hashlimit --hashlimit-above 10/sec --hashlimit-mode srcip --hashlimit-name udp_attack -j DROP
iptables -A INPUT -p udp -j ACCEPT
```
   Essas regras limitam a taxa de pacotes UDP recebidos para 10 por segundo por IP e descartam os pacotes excedentes.


### 2. Regra: Detecção de conexões HTTP GET excessivas
   - Descrição: Essa regra tem como objetivo identificar múltiplas solicitações GET HTTP vindas de um mesmo endereço IP em um curto período de tempo, o que pode indicar um ataque DDoS.
   - Condição: source_ip: any, destination_port: 80, protocol: TCP, http_method: GET, connection_count > Y (valor a ser definido com base no ambiente)

   Limitar a taxa de conexões TCP:
```bash
iptables -A INPUT -p tcp --syn -m connlimit --connlimit-above 20 -j DROP
iptables -A INPUT -p tcp --syn -m recent --name tcp_attack --update --seconds 60 --hitcount 10 -j DROP
iptables -A INPUT -p tcp --syn -m recent --name tcp_attack --set -j ACCEPT
```
   Essas regras limitam a taxa de conexões TCP recebidas por segundo e por IP. A primeira regra descarta as conexões que excedem 20 por segundo, a segunda descarta as conexões que excedem 10 por minuto de um mesmo IP e a terceira aceita as conexões dentro dos limites definidos.

   Limitar a taxa de conexões HTTP:
```bash
iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 50 -j DROP
iptables -A INPUT -p tcp --dport 80 -m recent --name http_attack --update --seconds 60 --hitcount 20 -j DROP
iptables -A INPUT -p tcp --dport 80 -m recent --name http_attack --set -j ACCEPT
```
   Essas regras limitam a taxa de conexões HTTP recebidas no porto 80 por segundo e por IP. A primeira regra descarta as conexões que excedem 50 por segundo, a segunda descarta as conexões que excedem 20 por minuto de um mesmo IP e a terceira aceita as conexões dentro dos limites definidos.


### 3. Regra: Detecção de pacotes ICMP flood
   - Descrição: Esta regra procura por uma alta taxa de pacotes ICMP (Internet Control Message Protocol) enviados a partir de um único IP, indicando uma possível inundação ICMP.
   - Condição: source_ip: any, destination_port: any, protocol: ICMP, packet_count > Z (valor a ser definido com base no ambiente)


   Limitar a taxa de pacotes ICMP:
```bash
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
iptables -A INPUT -p icmp -j DROP
```
   Essas regras limitam a taxa de pacotes ICMP (ping) recebidos para um por segundo e descartam os pacotes excedentes.
 

Embora existam exemplos simples de regras disponíveis, é importante lembrar que elas serão ajustadas durante o projeto conforme as necessidades e políticas de segurança. Certifique-se de adaptar as portas, os limites de taxa e os nomes de IP conforme apropriado para o ambiente. Além disso, é sempre recomendado testar cuidadosamente as regras antes de aplicá-las em um ambiente de produção.


#  Codigo para aplicação das regras.
```bash
#!/bin/bash


# Excluir todas as regras de firewall
iptables -F


# Limitar a taxa de pacotes ICMP
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
# Aceita um pacote ICMP (ping) a cada segundo e descarta os excedentes
iptables -A INPUT -p icmp -j DROP


# Limitar a taxa de conexões TCP
# Descarta as conexões TCP que excedem 20 por segundo
iptables -A INPUT -p tcp --syn -m connlimit --connlimit-above 20 -j DROP
# Descarta as conexões TCP que excedem 10 por minuto de um mesmo IP
iptables -A INPUT -p tcp --syn -m recent --name tcp_attack --update --seconds 60 --hitcount 10 -j DROP
# Aceita as conexões TCP dentro dos limites definidos
iptables -A INPUT -p tcp --syn -m recent --name tcp_attack --set -j ACCEPT




# Limitar a taxa de pacotes UDP
# Descarta os pacotes UDP que excedem 10 por segundo por IP
iptables -A INPUT -p udp -m hashlimit --hashlimit-above 10/sec --hashlimit-mode srcip --hashlimit-name udp_attack -j DROP
# Aceita os pacotes UDP dentro do limite definido
iptables -A INPUT -p udp -j ACCEPT



# Limitar a taxa de conexões HTTP
# Descarta as conexões HTTP que excedem 50 por segundo
iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 50 -j DROP
# Descarta as conexões HTTP que excedem 20 por minuto de um mesmo IP
iptables -A INPUT -p tcp --dport 80 -m recent --name http_attack --update --seconds 60 --hitcount 20 -j DROP
# Aceita as conexões HTTP dentro dos limites definidos
iptables -A INPUT -p tcp --dport 80 -m recent --name http_attack --set -j ACCEPT




# Salvar as regras
# Salva as regras no arquivo de configuração do iptables
#iptables-save > /etc/iptables/rules.v4
```

Certifique-se de adaptar as regras de acordo com suas necessidades e políticas de segurança. Lembre-se de salvar o script em um arquivo com extensão ".sh" (**por exemplo, ddos_rules.sh**), dar permissão de execução ao script (**chmod +x ddos_rules.sh**) e executá-lo como root (**sudo ./ddos_rules.sh**). 



# Fontes consultadas

Material didático do docente Teobaldo Adelino Dantas de Medeiros, da disciplina Administração Avançada de Serviços de Rede.
