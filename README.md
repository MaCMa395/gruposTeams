Programa que agrega y crea grupos en teams con usuarios masivamente

# 1) Importar modulos power Shell
Abrir terminal power Shell y poner lo siguiente

Install-Module -Name MicrosoftTeams -Force -AllowClobber

# 1.1) Cambiar políticas de script si se tiene error Get-ExecutionPolicy

Set-ExecutionPolicy RemoteSigned

# 2) crear archivos .csv base de datos
Crear y modificar los archivo:

** alumnoPorEquipo.csv

** equipo.csv

# 2.1) Ejemplo: equipo.csv
Archivo que crea equipos y agrega al administrador

Archivo `equipo.csv`:
```csv
DisplayName,Description,OwnerEmail
SistemasSoporte,Grupo de Prueba,santifev@unirem.edu.mx
SistemasPruebas,Grupo de prueba,adrimam@unirem.edu.mx
```

# 2.2) Ejemplo: alumnosPorEquipo.csv
Archivo que asigna alumnos a los grupos

Archivo `alumnosPorEquipo.csv`:
```csv
TeamName,Email
SistemasSoporte,adrimam@unirem.edu.mx
SistemasSoporte,marijia@unirem.edu.mx
SistemasPruebas,santifev@unirem.edu.mx
SistemasPruebas,marijia@unirem.edu.mx
```

# 3) Iniciar el programa

Abrir terminal power Shell en modo administrador y ejecutar AgregarAlumnosTeams.ps1

Ingresar correo y contraseña



