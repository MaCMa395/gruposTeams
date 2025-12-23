# ================================
# SCRIPT TEAMS ESCOLAR (POWERHELL 5)
# ================================

Import-Module MicrosoftTeams
Write-Host "Conectando a Microsoft Teams..." -ForegroundColor Cyan
Connect-MicrosoftTeams

# ================================
# CARGAR CSV EQUIPOS (FORZANDO ENCABEZADOS)
# ================================
$rawEquipo = Get-Content "C:\Users\CV 4\Documents\gruposteams\equipo.csv"
if ($rawEquipo.Count -lt 2) {
    Write-Warning "El CSV de equipos esta vacio o mal formado."
    exit
}

$equipos = $rawEquipo |
    Select-Object -Skip 1 |
    ConvertFrom-Csv -Header "DisplayName","Description","OwnerEmail"

# ================================
# CARGAR CSV ALUMNOS
# ================================
$rawAlumnos = Get-Content "C:\Users\CV 4\Documents\gruposteams\alumnoPorEquipo.csv"
if ($rawAlumnos.Count -lt 2) {
    Write-Warning "El CSV de alumnos esta vacio o mal formado."
    exit
}

$alumnos = $rawAlumnos |
    Select-Object -Skip 1 |
    ConvertFrom-Csv -Header "TeamName","Email"

# ================================
# CANALES PREDETERMINADOS (SIN GENERAL)
# ================================
$canalesPredeterminados = @(
    "Tareas",
    "Materiales"
)

# ================================
# CREAR EQUIPOS Y ASIGNAR OWNERS
# ================================
foreach ($equipo in $equipos) {

    $nombre     = if ($equipo.DisplayName) { $equipo.DisplayName.Trim() } else { "" }
    $desc       = if ($equipo.Description) { $equipo.Description.Trim() } else { "" }
    $ownerEmail = if ($equipo.OwnerEmail)  { $equipo.OwnerEmail.Trim() }  else { "" }

    if (-not $nombre -or $nombre -eq "DisplayName") {
        Write-Warning "Fila invalida o encabezado detectado, se omite."
        continue
    }

    try {
        # Buscar equipos con el mismo nombre
        $coincidencias = Get-Team | Where-Object { $_.DisplayName -eq $nombre }
        if ($coincidencias.Count -gt 1) {
            Write-Warning "Hay varios equipos con el nombre '$nombre'. Se usara el primero."
        }

        $nuevoTeam = $coincidencias | Select-Object -First 1

        if ($nuevoTeam) {
            Write-Host "Equipo ya existe: $nombre" -ForegroundColor Yellow
        }
        else {
            $nuevoTeam = New-Team `
                -DisplayName $nombre `
                -Description $desc `
                -Visibility Private

            Write-Host "Equipo creado: $nombre" -ForegroundColor Green
        }

        # ================================
        # ASIGNAR OWNER (VALIDADO)
        # ================================
        if ($ownerEmail -and $ownerEmail -ne "OwnerEmail" -and $ownerEmail -match '^[^@\s]+@[^@\s]+\.[^@\s]+$') {
            $owners = Get-TeamUser -GroupId $nuevoTeam.GroupId -Role Owner
            if ($owners.User -notcontains $ownerEmail) {
                Add-TeamUser -GroupId $nuevoTeam.GroupId -User $ownerEmail -Role Owner
                Write-Host "Owner agregado: $ownerEmail" -ForegroundColor Cyan
            }
            else {
                Write-Host "Owner ya es miembro: $ownerEmail" -ForegroundColor Yellow
            }
        }
        else {
            Write-Warning "Owner invalido o vacio para el equipo '$nombre'. Se omite."
        }

        # ================================
        # CREAR CANALES PREDETERMINADOS
        # ================================
        $canalesExistentes = Get-TeamChannel -GroupId $nuevoTeam.GroupId

        foreach ($canal in $canalesPredeterminados) {
            if ($canalesExistentes.DisplayName -notcontains $canal) {
                New-TeamChannel -GroupId $nuevoTeam.GroupId -DisplayName $canal
                Write-Host "Canal creado: $canal en $nombre" -ForegroundColor Cyan
            }
        }

    } catch {
        Write-Warning "Error al procesar equipo '$nombre': $($_.Exception.Message)"
    }
}

# ================================
# AGREGAR ALUMNOS A LOS EQUIPOS
# ================================
foreach ($row in $alumnos) {

    $teamName = if ($row.TeamName) { $row.TeamName.Trim() } else { "" }
    $email    = if ($row.Email)    { $row.Email.Trim() }    else { "" }

    if (-not $email -or $email -eq "Email") {
        Write-Warning "Fila de alumno invalida o encabezado, se omite."
        continue
    }

    # Seleccionar un solo equipo aunque haya duplicados
    $coincidencias = Get-Team | Where-Object { $_.DisplayName -eq $teamName }
    if ($coincidencias.Count -gt 1) {
        Write-Warning "Hay varios equipos con el nombre '$teamName'. Se usara el primero."
    }
    $team = $coincidencias | Select-Object -First 1

    if (-not $team) {
        Write-Warning "Equipo no encontrado: $teamName"
        continue
    }

    try {
        $miembros = Get-TeamUser -GroupId $team.GroupId
        if ($miembros.User -notcontains $email) {
            Add-TeamUser -GroupId $team.GroupId -User $email
            Write-Host "Alumno agregado: $email al equipo $teamName" -ForegroundColor Green
        }
        else {
            Write-Host "Alumno ya es miembro: $email en $teamName" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Warning "Error al agregar '$email' en '$teamName': $($_.Exception.Message)"
    }
}

Write-Host "`nProceso completado!" -ForegroundColor Magenta

