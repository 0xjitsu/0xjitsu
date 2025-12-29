#!/bin/bash
# Mac System Performance Audit Script
# Run this script in Terminal on your Mac: bash mac_audit.sh

echo "=============================================="
echo "       MAC SYSTEM PERFORMANCE AUDIT"
echo "=============================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print section headers
section() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  $1"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# 1. SYSTEM INFORMATION
section "1. SYSTEM INFORMATION"
echo ""
echo "Hardware Overview:"
system_profiler SPHardwareDataType 2>/dev/null | grep -E "Model Name|Model Identifier|Chip|Memory|Serial"
echo ""
echo "macOS Version:"
sw_vers
echo ""
echo "Uptime:"
uptime

# 2. STORAGE ANALYSIS
section "2. STORAGE ANALYSIS"
echo ""
echo "Disk Usage Overview:"
df -h / 2>/dev/null
echo ""
echo "Largest Directories in Home (~):"
du -sh ~/Downloads ~/Desktop ~/Documents ~/Library/Caches ~/Library/Application\ Support 2>/dev/null | sort -hr
echo ""
echo "Total Cache Size:"
du -sh ~/Library/Caches 2>/dev/null
echo ""
echo "Trash Size:"
du -sh ~/.Trash 2>/dev/null

# 3. MEMORY ANALYSIS
section "3. MEMORY ANALYSIS"
echo ""
echo "Memory Pressure:"
memory_pressure 2>/dev/null | head -20
echo ""
echo "VM Statistics:"
vm_stat 2>/dev/null
echo ""
echo "Top Memory Consumers:"
ps aux --sort=-%mem 2>/dev/null | head -11 || ps -Ao user,pid,%cpu,%mem,comm -r | head -11

# 4. CPU & PROCESS ANALYSIS
section "4. CPU & PROCESS ANALYSIS"
echo ""
echo "CPU Load Averages:"
sysctl -n vm.loadavg 2>/dev/null
echo ""
echo "Top CPU Consumers:"
ps -Ao user,pid,%cpu,%mem,comm -r 2>/dev/null | head -11
echo ""
echo "Number of Running Processes:"
ps aux 2>/dev/null | wc -l

# 5. STARTUP ITEMS & LAUNCH AGENTS
section "5. STARTUP ITEMS & LAUNCH AGENTS"
echo ""
echo "User Launch Agents:"
ls -la ~/Library/LaunchAgents/ 2>/dev/null | head -20
echo ""
echo "System Launch Agents:"
ls -la /Library/LaunchAgents/ 2>/dev/null | head -20
echo ""
echo "Login Items (requires user interaction to view fully):"
osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null

# 6. NETWORK STATUS
section "6. NETWORK STATUS"
echo ""
echo "Active Network Connections:"
netstat -an 2>/dev/null | grep ESTABLISHED | wc -l
echo "established connections"
echo ""
echo "DNS Configuration:"
scutil --dns 2>/dev/null | head -20

# 7. BATTERY HEALTH (MacBooks only)
section "7. BATTERY HEALTH"
echo ""
pmset -g batt 2>/dev/null
echo ""
echo "Battery Cycle Count:"
system_profiler SPPowerDataType 2>/dev/null | grep -E "Cycle Count|Condition|Maximum Capacity"

# 8. SYSTEM INTEGRITY & SECURITY
section "8. SYSTEM INTEGRITY & SECURITY"
echo ""
echo "SIP Status:"
csrutil status 2>/dev/null
echo ""
echo "FileVault Status:"
fdesetup status 2>/dev/null
echo ""
echo "Firewall Status:"
/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>/dev/null

# 9. SOFTWARE UPDATES
section "9. SOFTWARE UPDATES"
echo ""
echo "Checking for available updates..."
softwareupdate -l 2>/dev/null

# 10. BREW PACKAGES (if Homebrew installed)
section "10. HOMEBREW STATUS"
if command -v brew &> /dev/null; then
    echo "Homebrew Version: $(brew --version | head -1)"
    echo ""
    echo "Outdated Packages:"
    brew outdated 2>/dev/null | head -20
    echo ""
    echo "Brew Doctor Issues:"
    brew doctor 2>&1 | head -20
else
    echo "Homebrew not installed"
fi

# 11. DISK HEALTH
section "11. DISK HEALTH"
echo ""
echo "SMART Status:"
diskutil info disk0 2>/dev/null | grep -E "SMART|Solid State|Media Name"

# 12. TEMP FILES & CACHES SIZE
section "12. CACHE & TEMP FILES ANALYSIS"
echo ""
echo "System Caches:"
sudo du -sh /Library/Caches 2>/dev/null || echo "Need sudo for system caches"
echo ""
echo "User Caches:"
du -sh ~/Library/Caches 2>/dev/null
echo ""
echo "Browser Caches (estimated):"
du -sh ~/Library/Caches/Google 2>/dev/null
du -sh ~/Library/Caches/com.apple.Safari 2>/dev/null
du -sh ~/Library/Caches/Firefox 2>/dev/null

# 13. SPOTLIGHT INDEX STATUS
section "13. SPOTLIGHT STATUS"
echo ""
mdutil -s / 2>/dev/null

echo ""
echo "=============================================="
echo "              AUDIT COMPLETE"
echo "=============================================="
echo ""
echo "Review the sections above for potential issues."
echo "See the recommendations below based on common findings."
echo ""
