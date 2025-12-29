# Mac Performance Optimization Recommendations

## How to Use This Guide

1. Run the audit script first: `bash mac_audit.sh`
2. Review findings from each section
3. Apply the relevant recommendations below

---

## 1. Storage Optimization

### If disk usage is above 80%:

```bash
# Empty the Trash
rm -rf ~/.Trash/*

# Clear user caches (safe to delete)
rm -rf ~/Library/Caches/*

# Clear system logs
sudo rm -rf /private/var/log/*

# Remove iOS device backups (if not needed)
rm -rf ~/Library/Application\ Support/MobileSync/Backup/*

# Clear Xcode derived data (if developer)
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Clear npm cache
npm cache clean --force

# Clear pip cache
pip cache purge

# Clear Docker (if installed)
docker system prune -a
```

### Identify large files:
```bash
# Find files larger than 1GB
find ~ -type f -size +1G 2>/dev/null

# Use ncdu for interactive disk usage
brew install ncdu && ncdu ~
```

---

## 2. Memory Optimization

### If memory pressure is high:

1. **Close unnecessary apps** - Check Activity Monitor → Memory tab
2. **Reduce browser tabs** - Each tab uses significant RAM
3. **Disable memory-heavy login items**:
   - System Settings → General → Login Items
   - Remove apps you don't need at startup

### Quick memory cleanup:
```bash
# Clear inactive memory (sudo required)
sudo purge
```

### Permanent improvements:
- Upgrade RAM if possible (not on Apple Silicon Macs)
- Use Safari instead of Chrome (uses less memory)
- Close Electron apps when not in use (Slack, VS Code, Discord)

---

## 3. Startup Speed Optimization

### Review and clean startup items:

```bash
# List all launch agents
ls ~/Library/LaunchAgents/
ls /Library/LaunchAgents/
ls /Library/LaunchDaemons/

# Disable a specific launch agent
launchctl unload ~/Library/LaunchAgents/com.example.agent.plist

# Remove it permanently
rm ~/Library/LaunchAgents/com.example.agent.plist
```

### Common culprits to disable:
- Adobe Creative Cloud updaters
- Spotify helper
- Google Update
- Microsoft AutoUpdate
- Unused cloud sync services

### Manage login items:
System Settings → General → Login Items → Remove unnecessary apps

---

## 4. CPU Optimization

### If CPU is constantly high:

```bash
# Find CPU-intensive processes
top -o cpu

# Kill a runaway process
kill -9 <PID>
```

### Common fixes:
1. **Spotlight re-indexing**: Wait for it to complete or exclude folders
   ```bash
   # Check Spotlight status
   mdutil -s /

   # Exclude a folder from Spotlight
   # System Settings → Siri & Spotlight → Spotlight Privacy
   ```

2. **Disable unnecessary animations**:
   ```bash
   # Reduce transparency
   defaults write com.apple.universalaccess reduceTransparency -bool true

   # Reduce motion
   defaults write com.apple.universalaccess reduceMotion -bool true
   ```

3. **Reset SMC** (Intel Macs only):
   - Shut down Mac
   - Hold Shift + Control + Option + Power for 10 seconds
   - Release and power on

---

## 5. Network Performance

### DNS optimization:
```bash
# Flush DNS cache
sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder

# Use faster DNS (Google or Cloudflare)
# System Settings → Network → Wi-Fi → Details → DNS
# Add: 8.8.8.8, 8.8.4.4 (Google) or 1.1.1.1, 1.0.0.1 (Cloudflare)
```

### Network diagnostics:
```bash
# Test connection speed
networkQuality

# Check for packet loss
ping -c 100 google.com
```

---

## 6. Browser Performance

### Chrome optimization:
```bash
# Clear Chrome cache
rm -rf ~/Library/Caches/Google/Chrome/*

# Disable hardware acceleration if causing issues
# chrome://settings → System → Use hardware acceleration
```

### Safari optimization:
- Clear history and website data regularly
- Disable extensions you don't use
- Enable "Prevent cross-site tracking"

### General tips:
- Use fewer extensions
- Limit tabs to under 20
- Use a tab suspender extension

---

## 7. Software Updates

### Keep everything updated:
```bash
# macOS updates
softwareupdate -ia

# Homebrew updates
brew update && brew upgrade

# App Store updates
mas upgrade  # requires 'mas' CLI: brew install mas
```

---

## 8. System Maintenance

### Weekly maintenance tasks:
```bash
# Repair disk permissions (older macOS)
sudo diskutil repairPermissions /

# Verify disk health
diskutil verifyVolume /

# Rebuild Launch Services database
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Reset NVRAM (Intel Macs)
# Restart and hold Option + Command + P + R for 20 seconds
```

### Maintenance scripts (run periodically):
```bash
# Run daily, weekly, and monthly maintenance scripts
sudo periodic daily weekly monthly
```

---

## 9. Battery Optimization (MacBooks)

### Extend battery life:
1. **Enable optimized charging**: System Settings → Battery → Battery Health
2. **Reduce display brightness**
3. **Disable location services for apps that don't need it**
4. **Use Safari over Chrome** (more energy efficient)

### Check battery health:
```bash
# View cycle count and condition
system_profiler SPPowerDataType | grep -E "Cycle|Condition|Capacity"
```

### Battery health guidelines:
- Under 500 cycles: Excellent
- 500-800 cycles: Good
- 800-1000 cycles: Consider replacement
- Over 1000 cycles: Replace soon

---

## 10. Security & Privacy Improvements

### Essential security settings:
```bash
# Enable FileVault
sudo fdesetup enable

# Enable Firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Check SIP status (should be enabled)
csrutil status
```

### Privacy improvements:
1. Review app permissions: System Settings → Privacy & Security
2. Disable analytics: System Settings → Privacy & Security → Analytics
3. Review location services: System Settings → Privacy & Security → Location Services

---

## 11. Recommended Tools

### Free tools:
- **OnyX**: System maintenance and optimization
- **AppCleaner**: Properly uninstall apps with all files
- **Stats**: Menu bar system monitor
- **Homebrew**: Package manager for CLI tools

### Install via Homebrew:
```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Useful utilities
brew install --cask appcleaner    # App uninstaller
brew install --cask stats         # System monitor
brew install ncdu                 # Disk usage analyzer
brew install htop                 # Better process viewer
```

---

## 12. Quick Performance Boost Checklist

- [ ] Empty Trash
- [ ] Clear browser cache and close unused tabs
- [ ] Quit apps you're not using
- [ ] Remove unnecessary startup/login items
- [ ] Update macOS and all apps
- [ ] Restart Mac (clears memory and caches)
- [ ] Free up at least 20% disk space
- [ ] Run `sudo periodic daily weekly monthly`
- [ ] Disable unnecessary Spotlight indexing locations
- [ ] Review and remove unused apps

---

## 13. When to Consider Hardware Upgrades

### Signs you need more RAM:
- Constant memory pressure warnings
- Swap usage consistently high
- Apps frequently freeze or crash

### Signs you need more storage:
- Can't keep 10%+ free space
- Constantly managing files
- Can't install updates

### Signs of aging hardware:
- Battery cycle count over 1000
- Slow even with minimal apps
- Frequent kernel panics
- Fan running constantly

---

## Need More Help?

Run these diagnostics:
```bash
# Full system report
sudo sysdiagnose

# Check for hardware issues
# Apple Menu → About This Mac → System Report → Hardware

# Apple Diagnostics
# Restart and hold D (Intel) or Power button (Apple Silicon)
```
