Programa que agrega y crea grupos en teams con usuarios masivamente

# 1) Importar modulos power Shell
Abrir terminal power Shell y poner lo siguiente

```bash
# Instalar modulo necesario
Install-Module -Name MicrosoftTeams -Force -AllowClobber
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
Archivo que crea equipos y agrega al administrador

Archivo `equipo.csv`:
```csv
DisplayName,Description,OwnerEmail
NombreGrupo,Descripcion General,ejemplo@ejemplo.com
NombreGrupo2,Descripcion General,ejemplo@ejemplo.com
```

# 2.2) Ejemplo: alumnosPorEquipo.csv
Archivo que asigna alumnos a los grupos

Archivo `alumnosPorEquipo.csv`:
```csv
TeamName,Email
NombreGrupo1,ejemplo1@ejemplo.com
NombreGrupo1,ejemplo2@ejemplo.com
NonbreGrupo2,ejemplo1@ejemplo.com
NombreGrupo2,ejemplo2@ejemplo.com
```

# 3) Iniciar el programa

Abrir terminal power Shell en modo administrador y ejecutar AgregarAlumnosTeams.ps1

Ingresar correo y contraseña



