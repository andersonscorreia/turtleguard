#!/bin/bash
LOG_FILE="/var/log/suricata/fast.log"  # Caminho para o arquivo de log do Suricata

# Função para obter o valor de um item de monitoramento
get_item_value() {
  local item_key="$1"
  local item_value

  # Executar o comando para extrair o valor do item de monitoramento do arquivo de log
  case "$item_key" in
    http.flood_in)
      item_value=$(grep -c "Possivel HTTP flood de entrada" "$LOG_FILE")
      ;;
    http.flood_out)
      item_value=$(grep -c "Possivel HTTP flood de saida" "$LOG_FILE")
      ;;
    udp.flood_in)
      item_value=$(grep -c "Possivel UDP flood de entrada" "$LOG_FILE")
      ;;
    udp.flood_out)
      item_value=$(grep -c "Possivel UDP flood de saida" "$LOG_FILE")
      ;;
    syn.flood_in)
      item_value=$(grep -c "Possivel SYN flood de entrada" "$LOG_FILE")
      ;;
    syn.flood_out)
      item_value=$(grep -c "Possivel SYN flood de saida" "$LOG_FILE")
      ;;
    icmp.flood_in)
      item_value=$(grep -c "Possivel ICMP flood de entrada" "$LOG_FILE")
      ;;
    icmp.flood_out)
      item_value=$(grep -c "Possivel ICMP flood de saida" "$LOG_FILE")
      ;;
    *)
      echo "Unsupported item key: $item_key" >&2
      exit 1
      ;;
  esac

     
  echo "$item_value"
}



# Loop através dos itens de monitoramento e retornar os valores ao Zabbix
while read -r item_key; do
  item_value=$(get_item_value "$item_key")
  echo "$item_value"
done
