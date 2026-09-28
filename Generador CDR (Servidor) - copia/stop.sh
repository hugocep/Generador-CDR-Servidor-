#!/bin/sh
if pkill -f "server.py"; then echo "Servidor detenido."; else echo "No estaba corriendo."; fi
