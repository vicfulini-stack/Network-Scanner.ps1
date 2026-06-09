<#
.SYNOPSIS
    Scanner de Rede Local Automatizado.
.DESCRIPTION
    Este script descobre automaticamente a interface de rede interna ativa, 
    calcula a faixa da sub-rede local e realiza uma varredura de ping (ping sweep) 
    para identificar os dispositivos que estão conectados e ativos.
.AUTHOR
    Victor / Vicfulini-stack
.LICENSE
    MIT
#>
#>

# 1. Identifica a interface de rede ativa e extrai o IP local dinamicamente
$activeNetwork = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { 
    $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*" -and $_.InterfaceAlias -notlike "*Loopback*" -and $_.InterfaceAlias -notlike "*Virtual*"
} | Select-Object -First 1

if (-not $activeNetwork) {
    Write-Error "Nenhum adaptador de rede ativo com IPv4 foi encontrado."
    Exit
}

$localIP = $activeNetwork.IPAddress

# 2. Extrai a base da sub-rede (Ex: Transforma 192.168.0.26 em 192.168.0.)
$subnetBase = $localIP -replace '\.\d+$', '.'

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "         SCANNER DE REDE AUTOMATIZADO             " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "[+] Seu IP Local: $localIP" -ForegroundColor Green
Write-Host "[+] Alvo da Varredura: ${subnetBase}1 até ${subnetBase}254" -ForegroundColor Yellow
Write-Host "[*] Escaneando a rede local... Por favor, aguarde.`n" -ForegroundColor White

# 3. Executa o Ping Sweep paralelo nos 254 hosts da sub-rede
$liveHosts = 1..254 | ForEach-Object -Parallel {
    $ip = "${using:subnetBase}$_"
    # Dispara um ping rápido (timeout de 120ms)
    if (Test-Connection -ComputerName $ip -Count 1 -TimeoutMilliSeconds 120 -Quiet) {
        [PSCustomObject]@{
            "IP Address" = $ip
            "Status"     = "Ativo"
        }
    }
} -ThrottleLimit 50

# 4. Exibe os resultados organizados em formato de tabela se houver hosts ativos
if ($liveHosts) {
    Write-Host "[+] Dispositivos ativos encontrados na rede:" -ForegroundColor Green
    $liveHosts | Format-Table -AutoSize
} else {
    Write-Host "[-] Nenhum dispositivo respondeu ao ping além da máquina local." -ForegroundColor Red
}

Write-Host "==================================================" -ForegroundColor Cyan