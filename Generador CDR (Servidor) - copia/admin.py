# -*- coding: utf-8 -*-
# admin.py - Alta y manejo de cuentas y lineas del Generador de CDRs.
# Corre en el servidor:  python admin.py <comando> [args]
# Compatible con Python 2.7 y 3.

from __future__ import print_function
import os
import sys
import csv
import json
import auth

DIR = os.path.dirname(os.path.abspath(__file__))
ACCOUNTS_FILE = os.path.join(DIR, "accounts.json")
LINES_FILE = os.path.join(DIR, "lines.json")
DEFAULT_PASSWORD = "TELCEL"
DEFAULT_TEAM = "UPC"

def _load(path):
    try:
        fh = open(path)
        try:
            return json.load(fh)
        finally:
            fh.close()
    except Exception:
        return {}

def _save(path, obj, ascii_only=True):
    fh = open(path, "w")
    try:
        if ascii_only:
            json.dump(obj, fh, indent=2)
        else:
            json.dump(obj, fh, ensure_ascii=False, indent=1)
    finally:
        fh.close()
    try:
        os.chmod(path, 0o600)
    except Exception:
        pass

def _pop_team(args):
    team = DEFAULT_TEAM
    out = []
    i = 0
    while i < len(args):
        a = args[i]
        if a in ("--team", "-t") and i + 1 < len(args):
            team = args[i + 1]; i += 2; continue
        out.append(a); i += 1
    return team, out

def uso():
    print("Uso:")
    print("  python admin.py add [--team EQUIPO] <empleado> [empleado ...]")
    print("                                    Alta con clave " + DEFAULT_PASSWORD + " (cambio obligatorio).")
    print("                                    --team por defecto: " + DEFAULT_TEAM)
    print("  python admin.py list              Lista de usuarios (con su equipo)")
    print("  python admin.py reset [--team EQ] <empleado> ...   Regresa la clave a " + DEFAULT_PASSWORD)
    print("  python admin.py del   <empleado> ...   Elimina cuenta(s)")
    print("  python admin.py passwd <empleado> <clave>          Fija una clave concreta")
    print("  python admin.py setteam <empleado> <EQUIPO>        Cambia el equipo de una cuenta")
    print("  python admin.py teams             Equipos y cuantas lineas tiene cada uno")
    print("  python admin.py importlines <EQUIPO> <archivo.json|.csv>")
    print("                                    Carga lineas base a un equipo (msisdn,imsi,usuario,oferta)")

def cmd_add(args, reset=False):
    team, emps = _pop_team(args)
    if not emps:
        print("Falta el numero de empleado."); return
    acc = _load(ACCOUNTS_FILE)
    for u in emps:
        u = u.strip()
        if not u:
            continue
        if (u in acc) and not reset:
            print("  ya existe, se omite: " + u); continue
        rec = auth.hash_password(DEFAULT_PASSWORD)
        rec["must_change"] = True
        rec["team"] = team
        acc[u] = rec
        print(("  reset: " if reset else "  alta:  ") + u + "  (equipo " + team + ", clave " + DEFAULT_PASSWORD + ")")
    _save(ACCOUNTS_FILE, acc)

def cmd_list():
    acc = _load(ACCOUNTS_FILE)
    if not acc:
        print("(sin cuentas)"); return
    print("%-14s %-12s %s" % ("USUARIO", "EQUIPO", "ESTADO"))
    for u in sorted(acc.keys()):
        rec = acc[u]
        if isinstance(rec, dict):
            team = rec.get("team", DEFAULT_TEAM)
            est = "pendiente de cambiar clave" if rec.get("must_change") else "activa"
        else:
            team = DEFAULT_TEAM; est = "clave en texto plano (se hashea al entrar)"
        print("%-14s %-12s %s" % (u, team, est))
    print("Total: %d" % len(acc))

def cmd_del(args):
    if not args:
        print("Falta el numero de empleado."); return
    acc = _load(ACCOUNTS_FILE)
    for u in args:
        u = u.strip()
        if u in acc:
            del acc[u]; print("  eliminado: " + u)
        else:
            print("  no existe: " + u)
    _save(ACCOUNTS_FILE, acc)

def cmd_passwd(args):
    if len(args) < 2:
        print("Uso: python admin.py passwd <empleado> <clave>"); return
    u = args[0].strip(); clave = args[1]
    acc = _load(ACCOUNTS_FILE)
    old = acc.get(u)
    team = old.get("team", DEFAULT_TEAM) if isinstance(old, dict) else DEFAULT_TEAM
    rec = auth.hash_password(clave)
    rec["must_change"] = False
    rec["team"] = team
    acc[u] = rec
    _save(ACCOUNTS_FILE, acc)
    print("  clave fijada para: " + u + " (equipo " + team + ")")

def cmd_setteam(args):
    if len(args) < 2:
        print("Uso: python admin.py setteam <empleado> <EQUIPO>"); return
    u = args[0].strip(); team = args[1].strip()
    acc = _load(ACCOUNTS_FILE)
    if u not in acc:
        print("  no existe: " + u); return
    if not isinstance(acc[u], dict):
        acc[u] = auth.hash_password(str(acc[u])); acc[u]["must_change"] = False
    acc[u]["team"] = team
    _save(ACCOUNTS_FILE, acc)
    print("  " + u + " -> equipo " + team)

def cmd_teams():
    data = _load(LINES_FILE)
    if not data:
        print("(sin lineas cargadas)"); return
    for t in sorted(data.keys()):
        print("  %-14s %d lineas" % (t, len(data[t])))

def _read_lines_file(path):
    if path.lower().endswith(".json"):
        raw = json.load(open(path))
        rows = raw if isinstance(raw, list) else raw.get(list(raw.keys())[0], [])
    else:
        rows = []
        fh = open(path)
        try:
            rd = csv.DictReader(fh)
            for r in rd:
                rows.append(r)
        finally:
            fh.close()
    out = []
    for r in rows:
        m = str(r.get("msisdn", "") or "").strip()
        if not m:
            continue
        out.append({"msisdn": m, "imsi": str(r.get("imsi", "") or "").strip(),
                    "usuario": str(r.get("usuario", "") or "").strip(),
                    "oferta": str(r.get("oferta", "") or "").strip()})
    return out

def cmd_importlines(args):
    if len(args) < 2:
        print("Uso: python admin.py importlines <EQUIPO> <archivo.json|.csv>"); return
    team = args[0].strip(); path = args[1]
    if not os.path.exists(path):
        print("  no existe el archivo: " + path); return
    nuevas = _read_lines_file(path)
    data = _load(LINES_FILE)
    by = {}
    for x in data.get(team, []):
        by[str(x.get("msisdn"))] = x
    add = 0; upd = 0
    for n in nuevas:
        k = n["msisdn"]
        if k in by:
            by[k].update(n); upd += 1
        else:
            by[k] = n; add += 1
    data[team] = list(by.values())
    _save(LINES_FILE, data, ascii_only=False)
    print("  equipo %s: %d nuevas, %d actualizadas (total %d)" % (team, add, upd, len(data[team])))

if __name__ == "__main__":
    if len(sys.argv) < 2:
        uso(); sys.exit(0)
    cmd = sys.argv[1].lower(); rest = sys.argv[2:]
    if cmd == "add":
        cmd_add(rest)
    elif cmd == "reset":
        cmd_add(rest, reset=True)
    elif cmd == "list":
        cmd_list()
    elif cmd in ("del", "delete", "rm"):
        cmd_del(rest)
    elif cmd == "passwd":
        cmd_passwd(rest)
    elif cmd == "setteam":
        cmd_setteam(rest)
    elif cmd == "teams":
        cmd_teams()
    elif cmd == "importlines":
        cmd_importlines(rest)
    else:
        uso()
