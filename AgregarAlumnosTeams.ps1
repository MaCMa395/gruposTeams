# ==========================================
# SCRIPT TEAMS ESCOLAR - TIPO CLASE
# PowerShell 5 + Microsoft Graph
# ==========================================

# -------- CONFIGURACION --------
$csvEquipos  = ".\equipo.csv"
$csvAlumnos  = ".\alumnoPorEquipo.csv"
$canalesPredeterminados = @("Tareas", "Materiales")

# -------- MODULOS --------
Import-Module Microsoft.Graph.Teams
Import-Module Microsoft.Graph.Groups
Import-Module Microsoft.Graph.Users

# -------- CONEXION --------
Write-Host "Conectando a Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes `
    "Group.ReadWrite.All",
    "Team.Create",
    "TeamMember.ReadWrite.All",
    "Directory.ReadWrite.All"

# -------- CARGAR CSV EQUIPOS --------
$equipos = Import-Csv $csvEquipos
if (-not $equipos) {
    Write-Error "CSV de equipos vacio o invalido"
    exit
}

# -------- CARGAR CSV ALUMNOS --------
$alumnos = Import-Csv $csvAlumnos
if (-not $alumnos) {
    Write-Error "CSV de alumnos vacio o invalido"
    exit
}

# ==========================================
# CREAR EQUIPOS TIPO CLASE
# ==========================================
foreach ($equipo in $equipos) {

    $nombre     = $equipo.DisplayName.Trim()
    $desc       = $equipo.Description.Trim()
    $ownerEmail = $equipo.OwnerEmail.Trim()

    if (-not $nombre) { continue }

    Write-Host "`nProcesando clase: $nombre" -ForegroundColor Yellow

    try {
        # Verificar si ya existe
        $grupo = Get-MgGroup -Filter "displayName eq '$nombre'" -ErrorAction SilentlyContinue

        if ($grupo) {
            Write-Host "La clase ya existe" -ForegroundColor DarkYellow
            $teamId = $grupo.Id
        }
        else {
            $body = @{
                displayName = $nombre
                description = $desc
                "template@odata.bind" = "https://graph.microsoft.com/v1.0/teamsTemplates('educationClass')"
            }

            $team = New-MgTeam -BodyParameter $body
            $teamId = $team.Id

            Write-Host "Clase creada correctamente" -ForegroundColor Green
            Start-Sleep 20   # Tiempo necesario para provisionar
        }

        # -------- AGREGAR PROFESOR (OWNER) --------
        if ($ownerEmail) {
            $owner = Get-MgUser -UserId $ownerEmail -ErrorAction Stop
            Add-MgTeamMember `
                -TeamId $teamId `
                -UserId $owner.Id `
                -Roles "owner"

            Write-Host "Profesor agregado: $ownerEmail" -ForegroundColor Cyan
        }

        # -------- CREAR CANALES --------
        foreach ($canal in $canalesPredeterminados) {
            New-MgTeamChannel `
                -TeamId $teamId `
                -DisplayName $canal `
                -ErrorAction SilentlyContinue
        }

    } catch {
        Write-Warning "Error en la clase '$nombre': $($_.Exception.Message)"
    }
}

# ==========================================
# AGREGAR ALUMNOS A LAS CLASES
# ==========================================
foreach ($row in $alumnos) {

    $teamName = $row.TeamName.Trim()
    $email    = $row.Email.Trim()

    if (-not $teamName -or -not $email) { continue }

    try {
        $grupo = Get-MgGroup -Filter "displayName eq '$teamName'" -ErrorAction Stop
        $alumno = Get-MgUser -UserId $email -ErrorAction Stop

        Add-MgTeamMember `
            -TeamId $grupo.Id `
            -UserId $alumno.Id

        Write-Host "Alumno agregado: $email → $teamName" -ForegroundColor Green

    } catch {
        Write-Warning "No se pudo agregar $email a $teamName"
    }
}

Write-Host "`n✅ PROCESO COMPLETADO" -ForegroundColor Magenta


