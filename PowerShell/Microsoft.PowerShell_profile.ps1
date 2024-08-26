# Get internet settings
$settings = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings';

function Set-Proxy {
    # Get proxy data from settings
    $proxy_server = $settings.proxyServer;

    # Set proxy environment variables
    $env:http_proxy = ($env:https_proxy = $proxy_server)
    [System.Environment]::SetEnvironmentVariable('http_proxy', $proxy_server, 'User');
    [System.Environment]::SetEnvironmentVariable('https_proxy', $proxy_server, 'User');

    # Set proxy git settings
    git config --global http.proxy $proxy_server;
    git config --global https.proxy $proxy_server;

    # Set proxy npm settings
    npm config set proxy $proxy_server;
    npm config set https-proxy $proxy_server;
}
Set-Alias -Name proxy-set -Value Set-Proxy

function Unset-Proxy {
    # Unset proxy environment variables
    $env:http_proxy = ($env:https_proxy = '')
    [System.Environment]::SetEnvironmentVariable('http_proxy', [NullString]::Value, 'User');
    [System.Environment]::SetEnvironmentVariable('https_proxy', [NullString]::Value, 'User');

    # Unset proxy git settings
    git config --global --unset http.proxy;
    git config --global --unset https.proxy;

    # Delete proxy npm settings
    npm config delete proxy;
    npm config delete https-proxy;
}
Set-Alias -Name proxy-unset -Value Unset-Proxy

if ($settings.proxyEnable -and (!$env:http_proxy)) { Set-Proxy }
elseif ((!$settings.proxyEnable) -and $env:http_proxy) { Unset-Proxy }
