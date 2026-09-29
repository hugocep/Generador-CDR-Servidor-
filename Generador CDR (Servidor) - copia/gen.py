# -*- coding: utf-8 -*-
# gen.py - Logica de generacion de CDRs (lado servidor).
# Traduccion 1:1 del generador ya validado. Compatible con Python 3.4+.
# NO usa f-strings ni modulos nuevos, para correr en Python viejo.

import datetime

DEF_B = "5547786921"
MSC_MX = "5294100000980"

def _p2(x):
    return str(x).zfill(2)

def hms_to_sec(h):
    p = [int(x) for x in (h or "0:0:0").split(":")]
    while len(p) < 3:
        p.append(0)
    return p[0] * 3600 + p[1] * 60 + p[2]

def sec_to_hms(s):
    s = ((s % 86400) + 86400) % 86400
    return _p2(s // 3600) + ":" + _p2((s // 60) % 60) + ":" + _p2(s % 60)

def fmt_dt(f, h):
    d, m, y = f.split("/")
    a, b, c = h.split(":")
    return "{}{}{}{}{}{}".format(y, _p2(m), _p2(d), _p2(a), _p2(b), _p2(c))

def dur_seg(hi, hf):
    def t(x):
        a, b, c = [int(z) for z in x.split(":")]
        return a * 3600 + b * 60 + c
    d = t(hf) - t(hi)
    return d + 86400 if d < 0 else d

def linea_b(i):
    return "00" + (i.get("cc_b") or "52") + (i.get("linea_b") or DEF_B)

def gen_datos(i, oid, fn):
    f = [""] * 142
    def s(p, v):
        f[p - 1] = str(v)
    tot = int(str(i.get("vol_kb") or "0")) * 1024
    up = tot // 2
    dn = tot - up
    dt = fmt_dt(i["fecha"], i["hini"])
    s(1, oid); s(6, "0"); s(8, "3"); s(9, "1"); s(13, dt); s(14, "0")
    s(15, "0052" + i.get("linea", "")); s(17, "1"); s(18, "0"); s(19, "0")
    s(24, tot); s(25, up); s(26, dn); s(60, i.get("rating_group", "")); s(77, i.get("plmnid", ""))
    s(92, dt); s(98, tot); s(99, "1"); s(100, tot); s(101, "1"); s(103, fn); s(104, "1")
    s(110, i.get("imsi", "")); s(133, i.get("plmnid", ""))
    return "|".join(f)

def gen_voz(i, oid, fn):
    f = [""] * 65
    def s(p, v):
        f[p - 1] = str(v)
    A = "0052" + i.get("linea_a", "")
    B = linea_b(i)
    dt = fmt_dt(i["fecha"], i["hini"])
    du = dur_seg(i["hini"], i["hfin"])
    msc = i.get("msc") or MSC_MX
    ent = (i.get("tipo") or "SALIENTE") == "ENTRANTE"
    s(1, "91"); s(2, "0"); s(3, B if ent else A); s(4, A if ent else B); s(7, dt); s(8, "0")
    s(9, A if ent else B); s(10, A if ent else B); s(11, "1" if ent else "0")
    if ent:
        s(15, msc)
    else:
        s(13, msc)
    s(17, A if ent else B); s(19, "0"); s(23, "0"); s(24, i.get("imsi", "")); s(28, dt)
    s(29, du); s(30, "0"); s(31, du); s(32, "-1"); s(33, "0"); s(34, "0"); s(35, oid)
    s(41, "0"); s(42, "2"); s(43, "2"); s(44, "0"); s(45, "2"); s(46, "2"); s(47, "2")
    s(52, fn); s(53, "1")
    if i.get("vlr"):
        s(54, i["vlr"])
    return "|".join(f)

def gen_sms(i, oid, fn):
    f = [""] * 60
    def s(p, v):
        f[p - 1] = str(v)
    A = "0052" + i.get("linea_a", "")
    B = linea_b(i)
    dt = fmt_dt(i["fecha"], i["hini"])
    ent = (i.get("tipo") or "SALIENTE") == "ENTRANTE"
    s(1, "3"); s(2, "1"); s(5, "174"); s(8, B if ent else A); s(9, A if ent else B)
    s(10, A); s(11, "2" if ent else "1"); s(12, "0"); s(17, "0"); s(18, "0"); s(19, dt); s(23, "0")
    s(36, A); s(37, oid); s(42, "2"); s(43, "2"); s(44, "2"); s(45, "2"); s(46, A if ent else B)
    s(47, fn); s(48, "1")
    if i.get("vlr"):
        s(6, i["vlr"])
    s(53, i.get("imsi", "")); s(56, i.get("msc") or MSC_MX)
    # MOD 29-09-2026 SMS ENTRANTE en roaming: el pais lo da donde esta el cliente (red visitada),
    # no el numero que manda. Esa ubicacion va en el campo 58 (MSC de la red visitada), el 56
    # queda vacio y 51/52 en 1, igual que new_sms_nacional_campos.sh. Antes el 58 quedaba vacio
    # y en CRM salia Mexico por defecto.
    if ent and (i.get("vlr") or i.get("msc")):
        s(56, ""); s(58, i.get("msc") or MSC_MX); s(51, "1"); s(52, "1")
    return "|".join(f)

def gen_date():
    d = datetime.datetime.now()
    return "{:04d}{:02d}{:02d}".format(d.year, d.month, d.day)

def gen_time():
    d = datetime.datetime.now()
    return "{:02d}{:02d}{:02d}".format(d.hour, d.minute, d.second)

RUTAS = {
    "DATOS_NACIONAL": "/oniphdfs/rating/offcdr/input/cbs/data/scan_file",
    "DATOS_ROAMING": "/oniphdfs/rating/offcdr/input/cbs/data/scan_file",
    "VOZ_NACIONAL": "/oniphdfs/rating/offcdr/input/cbs/voice/scan_file",
    "VOZ_ROAMING": "/oniphdfs/rating/offcdr/input/cbs/voice/scan_file",
    "SMS_NACIONAL": "/oniphdfs/rating/offcdr/input/cbs/sms/scan_file",
    "SMS_ROAMING": "/oniphdfs/rating/offcdr/input/cbs/sms/scan_file",
}

def nuevo_estado():
    return {"seq": {}, "ocz": 205948, "och": 253616}

def next_seq(st, k, gd):
    r = st["seq"].get(k)
    n = (r["n"] + 1) if (r and r.get("date") == gd) else 1
    st["seq"][k] = {"date": gd, "n": n}
    return n

def next_oid(st, cdr):
    if cdr == "SMS":
        n = st.get("och", 253616); st["och"] = n + 1; return "OCH" + str(n)
    n = st.get("ocz", 205948); st["ocz"] = n + 1; return "OCZ" + str(n)

def generar_lote(st, req):
    tipo = req.get("tipo"); ambito = req.get("ambito"); v = req.get("v") or {}
    roam = (ambito == "ROAMING")
    N = max(1, int(req.get("nreg") or 1))
    inc = int(req.get("inc_sec") or 0)
    ops = (req.get("ops") or []) if roam else [{"pais": "Nacional"}]
    if not ops:
        raise ValueError("Roaming requiere al menos un operador")
    K = len(ops); per = N // K; rem = N - per * K
    op_seq = []; distrib = []
    for k in range(K):
        cnt = per + (1 if k >= K - rem else 0)
        distrib.append({"pais": ops[k].get("pais"), "cnt": cnt})
        for _j in range(cnt):
            op_seq.append(ops[k])
    gd = gen_date(); t0 = hms_to_sec(v.get("hini")); tm = gen_time()
    lines = []; first_oid = None; last_oid = None
    if tipo == "DATOS":
        seq = str(next_seq(st, "DATOS", gd)).zfill(6); fn = "GPRS_" + gd + tm + "_" + seq + ".unl"
        for idx in range(N):
            rec = dict(v)
            rec["vol_kb"] = req.get("vol_kb")
            rec["plmnid"] = (op_seq[idx].get("plmn") if roam else "334020")
            rec["hini"] = sec_to_hms(t0 + idx * inc)
            oid = next_oid(st, "DATOS")
            if idx == 0:
                first_oid = oid
            last_oid = oid
            lines.append(gen_datos(rec, oid, fn))
    elif tipo == "VOZ":
        dur = dur_seg(v.get("hini"), v.get("hfin"))
        seq = str(next_seq(st, "VOZ", gd)).zfill(6); fn = "w_abr_VMS_" + gd + tm + "_" + seq + ".unl"
        for idx in range(N):
            t = t0 + idx * inc
            rec = dict(v)
            rec["hini"] = sec_to_hms(t); rec["hfin"] = sec_to_hms(t + dur)
            if roam:
                rec["vlr"] = op_seq[idx].get("vlr"); rec["msc"] = op_seq[idx].get("msc")
            else:
                rec["vlr"] = ""; rec["msc"] = ""
            oid = next_oid(st, "VOZ")
            if idx == 0:
                first_oid = oid
            last_oid = oid
            lines.append(gen_voz(rec, oid, fn))
    else:
        seq = str(next_seq(st, "SMS", gd)).zfill(6); fn = "w_smo_SMSCobro_" + gd + tm + "_" + seq + ".unl"
        for idx in range(N):
            t = t0 + idx * inc
            rec = dict(v)
            rec["hini"] = sec_to_hms(t)
            if roam:
                rec["vlr"] = op_seq[idx].get("vlr"); rec["msc"] = op_seq[idx].get("msc")
            else:
                rec["vlr"] = ""; rec["msc"] = ""
            oid = next_oid(st, "SMS")
            if idx == 0:
                first_oid = oid
            last_oid = oid
            lines.append(gen_sms(rec, oid, fn))
    content = "\n".join(lines) + "\n"
    return {"filename": fn, "content": content, "firstOid": first_oid, "lastOid": last_oid,
            "ruta": RUTAS.get(tipo + "_" + ambito, ""), "count": N, "distrib": distrib}
