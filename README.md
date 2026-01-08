Programa que agrega y crea grupos en teams con usuarios masivamente

# 1) Importar modulos power Shell
Abrir terminal power Shell y poner lo siguiente

```bash
# Instalar modulo necesario
Install-Module -Name MicrosoftTeams -Force -AllowClobber
Install-Module Microsoft.Graph -AllowClobber
```

# 1.1) Cambiar políticas de script si se tiene error Get-ExecutionPolicy

```bash
# Quitar bloqueo de ejecucion de script
Set-ExecutionPolicy RemoteSigned
```

# 2) crear archivos .csv base de datos
Crear y modificar los archivo:

** alumnoPorEquipo.csv

** equipo.csv

# 2.1) Ejemplo: equipo.csv
Archivo que crea equipos clase y agrega al administrador

Archivo `equipo.csv`:
```csv
DisplayName,Description,OwnerEmail
1A Matemáticas,Clase de Matemáticas 1A,profesor1@tucolegio.edu
1A Español,Clase de Español 1A,profesor2@tucolegio.edu
1A Ciencias,Clase de Ciencias 1A,profesor3@tucolegio.edu
2B Matemáticas,Clase de Matemáticas 2B,profesor4@tucolegio.edu
```

# 2.2) Ejemplo: alumnosPorEquipo.csv
Archivo que asigna alumnos a los grupos

Archivo `alumnosPorEquipo.csv`:
```csv
TeamName,Email
1A Matemáticas,alumno1@tucolegio.edu
1A Matemáticas,alumno2@tucolegio.edu
1A Matemáticas,alumno3@tucolegio.edu
1A Español,alumno4@tucolegio.edu
1A Español,alumno5@tucolegio.edu
1A Ciencias,alumno6@tucolegio.edu
2B Matemáticas,alumno7@tucolegio.edu
```

# 3) Iniciar el programa

Abrir terminal power Shell en modo administrador y ejecutar AgregarAlumnosTeams.ps1

Ingresar correo y contraseña



