# Generador de CDRs (voz y SMS)

Scripts que usa la página del servidor para inyectar CDRs de voz y SMS, y un `.exe` para probarlos en la PC antes de subirlos.

```
servidor/new_voz_nacional_campos.sh   script de voz (corregido)   -> se sube al servidor
servidor/new_sms_nacional_campos.sh   script de SMS (corregido)   -> se sube al servidor
servidor/legacy/                      versiones interactivas anteriores (sin cambios, solo referencia)
dist/GeneradorCDR.exe                 generador para Windows (misma lógica que los scripts corregidos)
cdrgen/                               código fuente del .exe (Go)
pruebas/probar.sh                     pruebas automáticas
```

## Qué se corrigió (28-09-2026)

Cada cambio en los scripts está marcado con `#MOD 28-09-2026`.

### Voz: las llamadas en roaming no se inyectaban

Probado con el script original:

- B `0031612345678` y destino `-`: termina con **"Verifique el Destino"** y no genera nada.
- B `31612345678` (sin `00`): termina con **"Verifique el numero de B"**.
- B `0031612345678` con un grupo como destino (`EUROPA`): sí genera, pero con el VLR de Telcel (`5294100000980`), o sea como si el cliente estuviera en México. **El script de voz no tenía forma de indicar roaming.**
- B internacional con un estado como destino: el script se quedaba **ciclado** para siempre.

Corrección:

1. Ahora el script acepta el **VLR como parámetro 13**, igual que SMS:
   - saliente: el VLR va en el **campo 13**
   - entrante: el VLR va en el **campo 15**
   - si el parámetro 13 viene vacío o `-`, todo queda como antes (VLR de Telcel).
2. Si B es internacional (`0031...`, `+31...` o `31...`), se genera como Internacional con ese número y el destino ya no es obligatorio.

### SMS: SMS entrante en roaming aparecía con país origen México

Probado con el script original:

- B aleatorio y destino `-` (con VLR de Alemania): el script entraba a "Opcion incorrecta", seguía con variables vacías y ponía como remitente (campo 8) **el propio número del cliente** (`0052...`), por eso en CRM salía **México**.
- B `0031612345678` y destino `-`: termina con **"Verifique el Destino"** y no genera nada.
- Solo salía bien eligiendo un grupo país como destino (`DEU`, `EUROPA`...), y Países Bajos no estaba en la lista.

Corrección:

1. Con B internacional el campo 8 (remitente) queda con ese número (`0031612345678`) sin importar el destino. También se quitó un caso donde se le podía agregar `0052` a un número internacional.
2. Con B aleatorio y destino `-` ahora se genera un número nacional aleatorio (ya no el del cliente). Para que el origen sea otro país hay que capturar el número B o elegir un grupo país como destino (`DEU`, `NLD`...).
3. El VLR capturado con `+` o `00` (`+31653131232`) no se tomaba como roaming (quedaba como si estuviera en México). Ahora se limpia.

### En ambos scripts

- **Número B**: se aceptan `+31 6 1234 5678`, `0031612345678` y `31612345678` (de 11 a 15 dígitos sin `00` se toma como internacional). Se quitan espacios y guiones. En marcación CORTA el número se deja igual.
- **Destino `-`** ahora significa "sin destino" (igual que vacío).
- Se agregó el destino **`NLD` (Países Bajos)** al archivo `datos/origen_nacional_destino_internacional.txt` si no existe.
- **Año máximo**: la fecha no aceptaba años mayores a **2026**. En enero de 2027 todo iba a fallar. Ahora el máximo es el año actual + 1.
- **Scripts ciclados**: cuando un parámetro era inválido, el script se quedaba esperando que alguien escribiera algo y nunca terminaba. Ahora termina con `ERROR: parametro invalido...` y código de salida 1.
- Tipo de marcación o de consumo inválidos: antes seguía y generaba un CDR con campos vacíos; ahora termina con mensaje.
- Voz: hora inicio/fin `-` (aleatoria) se ciclaba; ahora funciona.
- Voz: si en `id_matrices_gprs.txt` no existe `OCZ_` se agrega `OCZ_0` (antes se ciclaba).

Los casos que ya funcionaban dan **exactamente la misma salida** que antes (ver *Pruebas*).

## Qué tiene que mandar la página

El orden de parámetros no cambió. Lo único nuevo es el **parámetro 13 de voz (VLR)**: si la página hoy manda 12 parámetros a voz, hay que agregarle el VLR al final, igual que ya se hace en SMS.

Voz (`new_voz_nacional_campos.sh`):

| # | Parámetro | Ejemplo |
|---|-----------|---------|
| 1 | Fecha DD/MM/YYYY | `28/09/2026` |
| 2 | Cantidad de CDRs | `1` |
| 3 | Número A (10 dígitos) | `5512345678` |
| 4 | IMSI (15 dígitos) | `334020123456789` |
| 5 | Número B (`-` = aleatorio) | `0031612345678` |
| 6 | Destino / estado (`-` = sin destino) | `-` |
| 7 | `ENTRANTE` / `SALIENTE` / `PATROCINADA` | `SALIENTE` |
| 8 | Hora inicio (`-` = aleatoria) | `10:00:00` |
| 9 | Hora fin (`-` = aleatoria) | `10:05:00` |
| 10 | ID matriz (`-` = automático) | `-` |
| 11 | `NORMAL` / `CORTA` / `PORCOBRAR` / `VIDEOLLAMADA` | `NORMAL` |
| 12 | Nuevo archivo `y`/`n` | `n` |
| 13 | **VLR roaming** (`-` = en México) | `31653131232` |

SMS (`new_sms_nacional_campos.sh`): fecha, cantidad, A, IMSI, B, destino, `ENTRANTE`/`SALIENTE`, hora, ID matriz, `NORMAL`/`CORTA`/`PORCOBRAR`, nuevo archivo, `RP`/`-`, VLR.

Ejemplos de los casos reportados:

```bash
# Llamada estando en Países Bajos a un número de Países Bajos
bash new_voz_nacional_campos.sh 28/09/2026 1 5512345678 334020123456789 0031612345678 - SALIENTE 10:00:00 10:05:00 - NORMAL n 31653131232

# SMS entrante de Países Bajos estando en Alemania
bash new_sms_nacional_campos.sh 28/09/2026 1 5512345678 334020123456789 0031612345678 - ENTRANTE 10:00:00 - NORMAL n - 491770610000
```

(Los VLR `31653131232` y `491770610000` son solo de ejemplo; use los VLR reales de cada país.)

## Uso del .exe en la PC

1. Copie `dist/GeneradorCDR.exe` a una carpeta propia (por ejemplo `C:\GeneradorCDR\`).
2. Copie de la carpeta `datos/` del servidor los archivos **`headers.txt`** y **`new_headers.txt`** a `C:\GeneradorCDR\datos\`. Sin ellos se usa una lista mínima de prueba y los números B nacionales no se van a validar igual que en el servidor.
3. Doble clic en `GeneradorCDR.exe`. Se abre una ventana negra (déjela abierta) y la página en el navegador.
4. Capture los datos y presione **Generar CDR**. La página muestra:
   - un resumen con el país del número origen/destino y del VLR,
   - el CDR campo por campo,
   - el **comando equivalente** para correr en el servidor,
   - los archivos generados en `C:\GeneradorCDR\CDR\...` (mismo nombre y formato que en el servidor).

También se puede usar desde `cmd` con los mismos parámetros que los scripts:

```
GeneradorCDR.exe voz 28/09/2026 1 5512345678 334020123456789 0031612345678 - SALIENTE 10:00:00 10:05:00 - NORMAL n 31653131232
GeneradorCDR.exe sms 28/09/2026 1 5512345678 334020123456789 0031612345678 - ENTRANTE 10:00:00 - NORMAL n - 491770610000
```

Windows puede mostrar "Windows protegió su PC" porque el .exe no está firmado: *Más información* → *Ejecutar de todas formas*.

## Subir al servidor

1. Respalde los scripts actuales del servidor.
2. Copie `servidor/new_voz_nacional_campos.sh` y `servidor/new_sms_nacional_campos.sh` a la misma carpeta donde están hoy (la que tiene `datos/` y `CDR/`).
3. Si la página no manda el VLR a voz, agréguelo como parámetro 13.
4. Si los copia desde Windows, verifique que los scripts sigan con saltos de línea Unix (`dos2unix new_*.sh`).

## Pruebas

```bash
bash pruebas/probar.sh
```

Revisa los casos de roaming, compara contra el script original que los casos que ya funcionaban den la misma salida, y compara el .exe (Go) contra los scripts bash corregidos. Los números de `pruebas/datos_prueba/` son ficticios.

Para recompilar el .exe (requiere Go 1.22+):

```bash
cd cdrgen && GOOS=windows GOARCH=amd64 go build -trimpath -ldflags "-s -w" -o ../dist/GeneradorCDR.exe .
```
