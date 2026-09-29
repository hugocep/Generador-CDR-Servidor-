#!/bin/sh
cd "$(dirname "$0")"
PY=$(command -v python3 || command -v python)
if [ -z "$PY" ]; then echo "No hay python ni python3 en este servidor."; exit 1; fi
if pgrep -f "server.py" > /dev/null; then
  echo "Ya hay un servidor corriendo. Detenlo primero con ./stop.sh"
  exit 1
fi
nohup "$PY" server.py > gencdr.log 2>&1 &
sleep 1
echo "Servidor iniciado con: $PY"
echo "IP de este servidor: $(hostname -I 2>/dev/null | awk '{print $1}')"
echo "Los companeros entran a:  http://<esa-IP>:5000"
echo "Ver log:  tail -f gencdr.log     Detener:  ./stop.sh"
