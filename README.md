Programa que agrega y crea grupos en teams con usuarios masivamente

# importar modulos en power Shell

Abrir terminal power Shell y poner lo siguiente

Install-Module -Name MicrosoftTeams -Force -AllowClobber

para validar si el alumno existe antes de agregar instalar modulo
Install-Module MSOnline -Force

#Conectarse a Microsoft teams
Import-Module MicrosoftTeams
Connect-MicrosoftTeams   //ingresar usuario y contraseña

conectarse al modulo MSOnline 
Connect-MsolService

#cambioar políticas de script si se tiene error
Get-ExecutionPolicy

Set-ExecutionPolicy RemoteSigned

# crear base de datos
Crear archivo equipos.csv en la misma carpeta que este archivo mismo nivel


Ejemplo:

equipos.csv
DisplayName,Description,OwnerEmail
Matematicas 1°A,Clase de Matemáticas 1°A,profesor1@colegio.edu
Historia 2°B,Clase de Historia 2°B,profesor2@colegio.edu
Ingles 3°C,Clase de Inglés 3°C,profesor3@colegio.edu

alumnosPorEquipo.csv
TeamName,Email
Matematicas 1°A,alumno1@colegio.edu
Matematicas 1°A,alumno2@colegio.edu
Historia 2°B,alumno3@colegio.edu
Historia 2°B,alumno4@colegio.edu
Ingles 3°C,alumno5@colegio.edu

#modificar archivo AgregarAlumnosTeams.pas1
modificar el idGrupo  2025-1-bg101-materia

