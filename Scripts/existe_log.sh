#!/bin/bash

# Define o caminho do arquivo de log do Suricata
LOGFILE=/var/log/suricata/eve.json

# Verifica se o arquivo existe e é legível
if [ -f $LOGFILE ] && [ -r $LOGFILE ]; then
# Usa awk para filtrar e contar os eventos de alerta e bloqueio
ALERTS=$(awk '/"event_type":"alert"/ {count++} END {print count}' $LOGFILE)
DROPS=$(awk '/"event_type":"drop"/ {count++} END {print count}' $LOGFILE)

# Imprime os valores separados por um espaço
echo "$ALERTS $DROPS"
else
# Imprime uma mensagem de erro se o arquivo não for encontrado ou não for legível
echo "Erro: arquivo de log do Suricata não encontrado ou não legível"
fi
