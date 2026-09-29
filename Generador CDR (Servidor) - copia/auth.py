# -*- coding: utf-8 -*-
# auth.py - Hash de contrasenas y tokens de sesion firmados.
# Compatible con Python 2.7.5 y Python 3 (NO usa pbkdf2_hmac ni compare_digest,
# que no existen en 2.7.5). Solo hashlib/hmac/base64/os/binascii/time.

import os
import hmac
import time
import base64
import hashlib
import binascii

DEFAULT_ITERS = 50000

def _consteq(a, b):
    # Comparacion en tiempo (casi) constante, sin depender de hmac.compare_digest
    if len(a) != len(b):
        return False
    r = 0
    for x, y in zip(a, b):
        r |= ord(x) ^ ord(y)
    return r == 0

def hash_password(password, salt_hex=None, iters=DEFAULT_ITERS):
    if salt_hex is None:
        salt_hex = binascii.hexlify(os.urandom(16)).decode("ascii")
    data = (salt_hex + password).encode("utf-8")
    h = hashlib.sha256(data).digest()
    i = 0
    while i < iters:
        h = hashlib.sha256(h + data).digest()
        i += 1
    return {"v": 1, "salt": salt_hex, "hash": binascii.hexlify(h).decode("ascii"),
            "iters": iters, "must_change": False}

def verify_password(password, record):
    try:
        salt_hex = record.get("salt")
        iters = int(record.get("iters", DEFAULT_ITERS))
        want = record.get("hash", "")
        got = hash_password(password, salt_hex, iters)["hash"]
        return _consteq(got, want)
    except Exception:
        return False

# --------------------------- TOKENS FIRMADOS ---------------------------
def load_secret(path):
    try:
        fh = open(path, "rb")
        try:
            raw = fh.read().strip()
        finally:
            fh.close()
        if raw:
            return raw
    except Exception:
        pass
    raw = binascii.hexlify(os.urandom(32))
    try:
        fh = open(path, "wb")
        try:
            fh.write(raw)
        finally:
            fh.close()
        try:
            os.chmod(path, 0o600)
        except Exception:
            pass
    except Exception:
        pass
    return raw

def _b64e(b):
    return base64.urlsafe_b64encode(b).decode("ascii")

def _b64d(s):
    return base64.urlsafe_b64decode(s.encode("ascii"))

def make_token(secret, user, ttl_seconds):
    exp = int(time.time()) + int(ttl_seconds)
    payload = (user + "|" + str(exp)).encode("utf-8")
    b64 = _b64e(payload)
    sig = hmac.new(secret, b64.encode("ascii"), hashlib.sha256).hexdigest()
    return b64 + "." + sig

def check_token(secret, token):
    try:
        if not token or "." not in token:
            return None
        b64, sig = token.split(".", 1)
        good = hmac.new(secret, b64.encode("ascii"), hashlib.sha256).hexdigest()
        if not _consteq(good, sig):
            return None
        payload = _b64d(b64).decode("utf-8")
        user, exp = payload.rsplit("|", 1)
        if int(exp) < int(time.time()):
            return None
        return user
    except Exception:
        return None
