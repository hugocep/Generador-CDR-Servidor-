# -*- coding: utf-8 -*-
# server.py - Generador de CDRs, version servidor.
# Compatible con Python 2.7 Y Python 3.4+  (solo libreria estandar).
# Correr:   nohup python server.py > gencdr.log 2>&1 &

from __future__ import print_function
import os
import io
import json

try:  # Python 3
    from http.server import BaseHTTPRequestHandler, HTTPServer
    from socketserver import ThreadingMixIn
except ImportError:  # Python 2
    from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
    from SocketServer import ThreadingMixIn

from ftplib import FTP
import threading
import gen
import auth

# ----------------------------- CONFIGURACION -----------------------------
HOST = "0.0.0.0"
PORT = 5000
FTP_CFG = {"host": "10.59.210.4", "port": 22021, "user": "crmhdfs", "password": "Huawei12#$"}
TTL_SECONDS = 12 * 3600          # sesion valida 12 horas
DEFAULT_PASSWORD = "TELCEL"      # clave inicial de cuentas nuevas
MIN_PASSWORD_LEN = 6

DIR = os.path.dirname(os.path.abspath(__file__))
ACCOUNTS_FILE = os.path.join(DIR, "accounts.json")
STATE_FILE = os.path.join(DIR, "state.json")
SECRET_FILE = os.path.join(DIR, "secret.key")
CLIENT_HTML = os.path.join(DIR, "client.html")

SECRET = auth.load_secret(SECRET_FILE)

# ----------------------------- ESTADO / CUENTAS -----------------------------
def load_state():
    try:
        fh = open(STATE_FILE)
        try:
            return json.load(fh)
        finally:
            fh.close()
    except Exception:
        return gen.nuevo_estado()

def save_state(st):
    try:
        fh = open(STATE_FILE, "w")
        try:
            json.dump(st, fh)
        finally:
            fh.close()
    except Exception as e:
        print("No se pudo guardar state.json: " + str(e))

STATE = load_state()

def load_accounts():
    try:
        fh = open(ACCOUNTS_FILE)
        try:
            return json.load(fh)
        finally:
            fh.close()
    except Exception:
        return {}

def save_accounts(acc):
    try:
        fh = open(ACCOUNTS_FILE, "w")
        try:
            json.dump(acc, fh, indent=2)
        finally:
            fh.close()
        try:
            os.chmod(ACCOUNTS_FILE, 0o600)
        except Exception:
            pass
        return True
    except Exception as e:
        print("No se pudo guardar accounts.json: " + str(e))
        return False

LASTCDR = {}   # user -> {filename, content, ruta}

LINES_FILE = os.path.join(DIR, "lines.json")
DEFAULT_TEAM = "UPC"          # equipo por defecto (el de Hugo)
_LOCK = threading.Lock()

def load_lines():
    try:
        fh = open(LINES_FILE)
        try:
            return json.load(fh)
        finally:
            fh.close()
    except Exception:
        return {}

def save_lines(obj):
    try:
        fh = open(LINES_FILE, "w")
        try:
            json.dump(obj, fh, ensure_ascii=False, indent=1)
        finally:
            fh.close()
        return True
    except Exception as e:
        print("No se pudo guardar lines.json: " + str(e))
        return False

def team_of(acc, user):
    rec = acc.get(user)
    if isinstance(rec, dict) and rec.get("team"):
        return rec.get("team")
    return DEFAULT_TEAM

def _record_for(acc, user):
    # Acepta formato viejo (texto plano) y nuevo (dict hasheado)
    rec = acc.get(user)
    return rec

# ----------------------------- FTP -----------------------------
def to_bytes(s):
    if isinstance(s, bytes):
        return s
    return s.encode("utf-8")

def inyectar_ftp(filename, content, ruta):
    ftp = FTP()
    ftp.connect(FTP_CFG["host"], FTP_CFG["port"], 25)
    try:
        ftp.login(FTP_CFG["user"], FTP_CFG["password"])
        ftp.cwd(ruta)
        ftp.storbinary("STOR " + filename, io.BytesIO(to_bytes(content)))
        return {"ok": True, "msg": "Inyectado: " + ruta + "/" + filename}
    finally:
        try:
            ftp.quit()
        except Exception:
            try:
                ftp.close()
            except Exception:
                pass

# ----------------------------- SERVIDOR HTTP -----------------------------
class Handler(BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def _hdr(self, name, default=None):
        h = self.headers
        try:
            v = h.get(name)
            if v is not None:
                return v
        except Exception:
            pass
        try:
            v = h.getheader(name)
            if v is not None:
                return v
        except Exception:
            pass
        return default

    def _send(self, code, body, ctype="application/json; charset=utf-8"):
        b = to_bytes(body)
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(b)))
        self.end_headers()
        try:
            self.wfile.write(b)
        except Exception:
            pass

    def _json(self, code, obj):
        self._send(code, json.dumps(obj))

    def _body(self):
        try:
            n = int(self._hdr("Content-Length") or 0)
            raw = self.rfile.read(n) if n > 0 else b""
            return json.loads(raw.decode("utf-8")) if raw else {}
        except Exception:
            return {}

    def _user(self):
        return auth.check_token(SECRET, self._hdr("x-token") or "")

    def do_GET(self):
        path = self.path.split("?")[0]
        if path in ("/", "/login", "/index.html"):
            try:
                fh = open(CLIENT_HTML, "rb")
                try:
                    html = fh.read()
                finally:
                    fh.close()
            except Exception:
                return self._send(500, "Falta client.html junto a server.py", "text/plain; charset=utf-8")
            return self._send(200, html, "text/html; charset=utf-8")
        if path == "/favicon.ico":
            self.send_response(204)
            self.end_headers()
            return
        if path == "/api/me":
            return self._me()
        if path == "/api/lines":
            u = self._user()
            if not u:
                return self._json(401, {"ok": False, "error": "Sesion invalida."})
            acc = load_accounts()
            team = team_of(acc, u)
            return self._json(200, {"ok": True, "team": team, "lines": load_lines().get(team, [])})
        self._send(404, "No encontrado", "text/plain; charset=utf-8")

    def _me(self):
        u = self._user()
        if not u:
            return self._json(200, {"ok": False})
        acc = load_accounts()
        rec = _record_for(acc, u)
        if rec is None:
            return self._json(200, {"ok": False})
        mc = bool(rec.get("must_change")) if isinstance(rec, dict) else False
        return self._json(200, {"ok": True, "user": u, "must_change": mc})

    def do_POST(self):
        path = self.path.split("?")[0]

        if path == "/api/login":
            b = self._body()
            u = str(b.get("user") or "").strip()
            p = str(b.get("pass") or "")
            acc = load_accounts()
            rec = _record_for(acc, u)
            ok = False
            must_change = False
            if rec is not None:
                if isinstance(rec, dict):
                    ok = auth.verify_password(p, rec)
                    must_change = bool(rec.get("must_change"))
                else:
                    # cuenta vieja en texto plano -> migrar a hash al vuelo
                    if str(rec) == p:
                        ok = True
                        acc[u] = auth.hash_password(p)
                        acc[u]["must_change"] = False
                        save_accounts(acc)
            if not ok:
                return self._json(200, {"ok": False, "error": "Usuario o contrasena incorrectos."})
            token = auth.make_token(SECRET, u, TTL_SECONDS)
            return self._json(200, {"ok": True, "token": token, "user": u, "must_change": must_change})

        if path == "/api/me":
            return self._me()

        if path == "/api/change_password":
            u = self._user()
            if not u:
                return self._json(401, {"ok": False, "error": "Sesion invalida, vuelve a entrar."})
            b = self._body()
            newp = str(b.get("new_pass") or "")
            if len(newp) < MIN_PASSWORD_LEN:
                return self._json(200, {"ok": False, "error": "La contrasena debe tener al menos %d caracteres." % MIN_PASSWORD_LEN})
            if newp.upper() == DEFAULT_PASSWORD.upper():
                return self._json(200, {"ok": False, "error": "Elige una contrasena distinta a la inicial."})
            acc = load_accounts()
            old = _record_for(acc, u)
            if old is None:
                return self._json(200, {"ok": False, "error": "Usuario no existe."})
            newrec = auth.hash_password(newp)
            newrec["must_change"] = False
            if isinstance(old, dict) and old.get("team"):
                newrec["team"] = old.get("team")
            acc[u] = newrec
            if not save_accounts(acc):
                return self._json(200, {"ok": False, "error": "No se pudo guardar la nueva contrasena."})
            return self._json(200, {"ok": True})

        if path == "/api/generar":
            u = self._user()
            if not u:
                return self._json(401, {"ok": False, "error": "Sesion invalida, vuelve a entrar."})
            acc = load_accounts()
            rec = _record_for(acc, u)
            if isinstance(rec, dict) and rec.get("must_change"):
                return self._json(403, {"ok": False, "error": "Debes cambiar tu contrasena primero."})
            b = self._body()
            try:
                r = gen.generar_lote(STATE, b)
            except Exception as e:
                return self._json(200, {"ok": False, "error": str(e)})
            save_state(STATE)
            LASTCDR[u] = {"filename": r["filename"], "content": r["content"], "ruta": r["ruta"]}
            plines = r["content"].strip().split("\n")[:3]
            preview = "\n".join(plines)
            if r["count"] > 3:
                preview = preview + "\n... (" + str(r["count"]) + " registros en total)"
            r2 = dict(r)
            r2["ok"] = True
            r2["preview"] = preview
            return self._json(200, r2)

        if path == "/api/inyectar":
            u = self._user()
            if not u:
                return self._json(401, {"ok": False, "error": "Sesion invalida, vuelve a entrar."})
            lc = LASTCDR.get(u)
            if not lc:
                return self._json(200, {"ok": False, "error": "Primero genera un CDR."})
            try:
                out = inyectar_ftp(lc["filename"], lc["content"], lc["ruta"])
                return self._json(200, out)
            except Exception as e:
                return self._json(200, {"ok": False, "error": "Fallo la inyeccion FTP: " + str(e)})

        if path == "/api/lines_save":
            u = self._user()
            if not u:
                return self._json(401, {"ok": False, "error": "Sesion invalida."})
            b = self._body()
            msisdn = str(b.get("msisdn") or "").strip()
            imsi = str(b.get("imsi") or "").strip()
            usuario = str(b.get("usuario") or "").strip()
            oferta = str(b.get("oferta") or "").strip()
            if not msisdn.isdigit() or len(msisdn) < 10:
                return self._json(200, {"ok": False, "error": "MSISDN invalido (al menos 10 digitos)."})
            if imsi and (not imsi.isdigit() or len(imsi) != 15):
                return self._json(200, {"ok": False, "error": "IMSI invalido (deben ser 15 digitos)."})
            acc = load_accounts()
            team = team_of(acc, u)
            with _LOCK:
                data = load_lines()
                lst = [x for x in data.get(team, []) if str(x.get("msisdn")) != msisdn]
                lst.insert(0, {"msisdn": msisdn, "imsi": imsi, "usuario": usuario, "oferta": oferta, "_mine": True})
                data[team] = lst
                save_lines(data)
                out = data[team]
            return self._json(200, {"ok": True, "lines": out})

        if path == "/api/lines_del":
            u = self._user()
            if not u:
                return self._json(401, {"ok": False, "error": "Sesion invalida."})
            b = self._body()
            msisdn = str(b.get("msisdn") or "").strip()
            acc = load_accounts()
            team = team_of(acc, u)
            with _LOCK:
                data = load_lines()
                lst = data.get(team, [])
                target = None
                for x in lst:
                    if str(x.get("msisdn")) == msisdn:
                        target = x
                        break
                if target is None:
                    return self._json(200, {"ok": False, "error": "No existe esa linea."})
                if not (target.get("_mine") or target.get("added")):
                    return self._json(200, {"ok": False, "error": "Esa linea es de la lista base del equipo; se administra desde admin.py."})
                data[team] = [x for x in lst if str(x.get("msisdn")) != msisdn]
                save_lines(data)
                out = data[team]
            return self._json(200, {"ok": True, "lines": out})

        if path == "/api/logout":
            return self._json(200, {"ok": True})

        self._json(404, {"ok": False, "error": "No encontrado"})


class ThreadingServer(ThreadingMixIn, HTTPServer):
    daemon_threads = True
    allow_reuse_address = True


if __name__ == "__main__":
    print("==================================================")
    print("  Generador de CDRs - SERVIDOR")
    print("  Escuchando en http://%s:%d" % (HOST, PORT))
    print("  Acceso:  http://<IP-de-este-servidor>:%d/login" % PORT)
    print("  Cuentas: python admin.py   (registrar empleados)")
    print("  Detener: Ctrl+C")
    print("==================================================")
    srv = ThreadingServer((HOST, PORT), Handler)
    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        print("\nServidor detenido.")
