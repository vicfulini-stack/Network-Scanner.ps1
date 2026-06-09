# Scanner de Rede Local Automatizado (Ping Sweep)

Este é um script desenvolvido em PowerShell projetado para automatizar a auditoria e o mapeamento de redes locais (LAN). Ele identifica dinamicamente a interface de rede ativa do sistema operacional, calcula o escopo da sub-rede correspondente e executa uma varredura em paralelo (*Ping Sweep*) para descobrir quais dispositivos estão conectados e respondendo.

##  Funcionalidades

* **Descoberta Dinâmica:** Identifica o IP local da máquina sem a necessidade de passar parâmetros fixos (*hardcoded*).
* **Processamento em Paralelo:** Utiliza recursos nativos do PowerShell (`ForEach-Object -Parallel`) para testar os 254 hosts da sub-rede simultaneamente, reduzindo o tempo de varredura para poucos segundos.
* **Isolamento de Redes Virtuais:** Ignora automaticamente adaptadores de loopback ou de máquinas virtuais (como VirtualBox, VMware e WSL).
* **Saída Organizada:** Exibe os resultados diretamente no terminal em formato de tabela limpa.

##  Pré-requisitos

* **Sistema Operacional:** Windows 10 / 11 ou Windows Server.
* **PowerShell v7+** (Recomendado para suporte total ao parâmetro `-Parallel`).

## Como Executar

1. Abra o **PowerShell** (de preferência como Administrador).
2. Caso o Windows bloqueie a execução de scripts locais por diretivas de segurança, libere temporariamente na sua sessão com o comando:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope Process