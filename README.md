# ⌨️ oboi&trade; Data Leakage Protection (DLP)

![oboi logo](oboi_logo_colour.png)

**oboi-dlp** is an Apache external filter for Data Loss Prevention (DLP) that inspects HTTP request and response bodies in real time, applying configurable rules for blocking, logging, or alerting on sensitive data.

## 🚀 Quick Install

```bash
brew tap forshaws/homebrew-oboi-dlp
brew install oboi-dlp
```

## 🎯 Setup Overview

After installation, you need to:

1. **Enable Apache's `mod_ext_filter`** module
2. **Configure Apache to use the `oboi-dlp` binary**
3. **Verify `oboi-dlp.conf` is accessible**

---

## 🍎 macOS Configuration

### Binary & Config Locations

| Architecture | Apache Config | oboi-dlp.conf | Binary |
|--------------|---------------|---------------|--------|
| Intel Macs | `/usr/local/etc/httpd` | `/usr/local/etc/oboi-dlp.conf` | `/usr/local/bin/oboi-dlp` |
| Apple Silicon | `/opt/homebrew/etc/httpd` | `/opt/homebrew/etc/oboi-dlp.conf` | `/opt/homebrew/bin/oboi-dlp` |

### Apache Configuration

Add to your `httpd.conf`:

```apache
# Enable external filter module
LoadModule ext_filter_module lib/httpd/modules/mod_ext_filter.so

# OBOI-DLP Filter Definition
ExtFilterDefine dlpfilterin mode=input cmd="/opt/homebrew/bin/oboi-dlp --mode=input" preservescontentlength
ExtFilterDefine dlpfilterout mode=output cmd="/opt/homebrew/bin/oboi-dlp --mode=output" preservescontentlength

<Location "/">
    SetInputFilter dlpfilterin
    SetOutputFilter dlpfilterout
</Location>

# Optional: Custom log paths (create these files first with proper permissions)
#SetEnv OBOI_DLP_SYSTEMLOGPATH /usr/local/var/log/dlpfilter.log
#SetEnv OBOI_DLP_CAPALOGPATH /usr/local/var/log/capa.log

# Optional: ntfy.sh notifications
#SetEnv OBOI_DLP_TOPIC "your_topic_name_here"

# Optional: API key for licensed features
#SetEnv OBOI_DLP_APIKEY="YOUR_API_KEY_GOES_HERE"

```

**Note:** Update the binary path based on your architecture (Intel: `/usr/local/bin/oboi-dlp`, Apple Silicon: `/opt/homebrew/bin/oboi-dlp`)

### macOS Troubleshooting

- Run `apachectl configtest` after configuration changes
- Ensure you're using the correct paths for your architecture
- If running multiple Apache instances, verify Homebrew Apache is active: `brew services restart httpd`

---

## 🐧 Linux Configuration

### Distribution-Specific Paths


| Architecture | Apache Config/root | oboi-dlp.conf | Binary |
|--------------|-------------------|---------------|--------|
| RHEL/CentOS/<br>Fedora | `/etc/httpd/conf/`<br>`httpd.conf` | `/home/linuxbrew/.linuxbrew/`<br>`etc/oboi-dlp.conf` | `/home/linuxbrew/.linuxbrew/`<br>`bin/oboi-dlp` |
| Ubuntu/<br>Debian | `/etc/apache2/` | `/home/linuxbrew/.linuxbrew/`<br>`etc/oboi-dlp.conf` | `/home/linuxbrew/.linuxbrew/`<br>`bin/oboi-dlp` |

### RHEL/CentOS/Fedora Setup

Add to `/etc/httpd/conf/httpd.conf`:

```apache
LoadModule ext_filter_module modules/mod_ext_filter.so

# OBOI-DLP Configuration
ExtFilterDefine dlpfilterin mode=input cmd="/home/linuxbrew/.linuxbrew/bin/oboi-dlp --mode=input" preservescontentlength
ExtFilterDefine dlpfilterout mode=output cmd="/home/linuxbrew/.linuxbrew/bin/oboi-dlp --mode=output" preservescontentlength

<Location "/">
    SetInputFilter dlpfilterin
    SetOutputFilter dlpfilterout
</Location>

# Optional: Custom log paths (create these files first with proper permissions)
#SetEnv OBOI_DLP_SYSTEMLOGPATH /usr/local/var/log/dlpfilter.log
#SetEnv OBOI_DLP_CAPALOGPATH /usr/local/var/log/capa.log

# Optional: ntfy.sh notifications
#SetEnv OBOI_DLP_TOPIC "your_topic_name_here"

# Optional: API key for licensed features
#SetEnv OBOI_DLP_APIKEY="YOUR_API_KEY_GOES_HERE"

```

### Ubuntu/Debian Setup

1. **Enable the module:**
   ```bash
   sudo a2enmod ext_filter
   ```

2. **Create filter configuration:**
   ```bash
   sudo nano /etc/apache2/mods-available/ext_filter.conf
   ```

   Add:
   ```apache
   # OBOI-DLP Configuration
   ExtFilterDefine dlpfilterin mode=input cmd="/home/linuxbrew/.linuxbrew/bin/oboi-dlp --mode=input" preservescontentlength
   ExtFilterDefine dlpfilterout mode=output cmd="/home/linuxbrew/.linuxbrew/bin/oboi-dlp --mode=output" preservescontentlength

   <Location "/">
       SetInputFilter dlpfilterin
       SetOutputFilter dlpfilterout
   </Location>

   # Optional: Custom log paths (create these files first with proper permissions)
   #SetEnv OBOI_DLP_SYSTEMLOGPATH /usr/local/var/log/dlpfilter.log
   #SetEnv OBOI_DLP_CAPALOGPATH /usr/local/var/log/capa.log
 
   # Optional: ntfy.sh notifications
   #SetEnv OBOI_DLP_TOPIC "your_topic_name_here"
 
   # Optional: API key for licensed features
   #SetEnv OBOI_DLP_APIKEY="YOUR_API_KEY_GOES_HERE"
   ```

3. **Reload Apache:**
   ```bash
   sudo systemctl reload apache2
   ```

### Linux Security Considerations

- **SELinux (RHEL/CentOS/Fedora):** May require additional permissions
- **AppArmor (Ubuntu/Debian):** Generally more permissive for standard operations
- **systemd PrivateTmp:** Check if Apache has private temp namespace that could affect file operations. See the **PrivateTmp & oboi-dlp** section for detailed information.

---

## 📁 Working Directory

oboi-dlp automatically creates its working directory at `/var/tmp/oboi-dlp` with appropriate permissions for both user and Apache execution contexts. This location provides:

- Cross-platform compatibility (Linux & macOS)
- Persistence across reboots
- Proper web server access permissions

### ⚠️ PrivateTmp & oboi-dlp
Many Apache installs are configured to use `PrivateTmp=on` and oboi-dlp is designed to handle this without any changes to your security posture. **note** - no amount of chmod/chown will overide PrivateTmp. The first time oboi-dlp is called by Apache (or other calling process/server) it will try and determine if it can use `/var/tmp/oboi-dlp` to build its instal files. If PrivateTmp is on, it will build these files in the private directory space. For most systems this will be a folder named something like `/var/tmp/system.d-xxxxxxxxx-apache2/var/tmp/oboi-dlp/`. You can create a symlink to the oboi-dlp log files insode this folder to tail them or copy them to a locally writeable folder if you need this.

---

## ⚙️ Configuration File

The `oboi-dlp.conf` file controls DLP rules and thresholds:

```ini
API Key = on,0
AWS Key = on,0
AWS Temp Key = on,0
Credit Card = on,0
National ID = on,0
Sort Code = on,10
UK Bank Account = on,5
US Bank Account = on,5
Phone Number = on,10
Phone Number USA = on,10
Email Threshold = 5
Whitelist URIs = /status,/healthcheck,/whitelist.txt
```

Format: `<RULE_NAME> = <on/off>, <threshold>`

---

## 📊 Logging & Notifications

### Custom Log Files

If using custom log paths, create them with proper permissions:

```bash
# macOS
touch /usr/local/var/log/{capa.log,dlpfilter.log}
sudo chgrp _www /usr/local/var/log/{capa.log,dlpfilter.log}
chmod 0770 /usr/local/var/log/{capa.log,dlpfilter.log}

# Linux
touch /var/log/{capa.log,dlpfilter.log}
sudo chgrp www-data /var/log/{capa.log,dlpfilter.log}  # Ubuntu/Debian
sudo chgrp apache /var/log/{capa.log,dlpfilter.log}    # RHEL/CentOS
chmod 0770 /var/log/{capa.log,dlpfilter.log}
```

### Viewing Logs

```bash
# Default location
tail -f /var/tmp/oboi-dlp/{capa.log,dlpfilter.log}

# Custom location
tail -f /usr/local/var/log/capa.log

# Colored CAPA alerts
tail -f /var/tmp/oboi-dlp/capa.log | sed 's/^/\x1b[31m[CAPA]\x1b[0m /'
```

Example of tailing CAPA logs with colour coding
![oboi logo](capa-fancy.png)

### ntfy.sh Notifications

Enable real-time alerts by setting your ntfy topic:

```apache
SetEnv OBOI_DLP_TOPIC "your_secret_topic_name"
```

---

## 🧪 Testing

### Automated Test Suite

The installation includes a comprehensive test suite. Copy `oboi-dlp-test/` to your web root and access:

- **Web interface:** `http://your-server/oboi-dlp-test/test_oboi_dlp.html`
- **Command line:** `./oboi-dlp-scan.sh`

**⚠️ Remove the test suite after verification**

The command line interface
![oboi logo](oboi-test-sh.png)

The web interface
![oboi logo](oboi-test-html.png)

### Manual Testing

Test DLP functionality by serving files containing sensitive data patterns. Blocked requests will return "Access Blocked" and generate CAPA log entries.

---

## 🔧 Useful Commands

### Apache Management
```bash
# Test configuration
apachectl configtest

# Restart services
sudo systemctl restart apache2    # Linux
sudo apachectl restart           # macOS

# View logs
tail -f /var/log/apache2/error.log    # Ubuntu/Debian
tail -f /var/log/httpd/error_log      # RHEL/CentOS
tail -f /usr/local/var/log/httpd/error_log  # macOS
```

### Service Management
```bash
# Linux
sudo systemctl {start|stop|restart|status} apache2
sudo systemctl {start|stop|restart|status} httpd

# macOS
brew services {start|stop|restart} httpd
```

---

## 🔐 Licensing

### Free Trial
oboi-dlp includes a free trial mode for:
- Personal use
- Educational purposes  
- Prototyping

### Licensed Features
Commercial use requires a valid API key. Set your license key in Apache configuration:

```apache
SetEnv OBOI_DLP_APIKEY="YOUR_API_KEY_GOES_HERE"
```

Visit [toridion.com/oboi-dlp](https://toridion.com/oboi-dlp/) for licensing details.

---

## 🚮 Uninstall

Basic uninstall

```bash
brew uninstall oboi-dlp
brew untap forshaws/homebrew-oboi-dlp
```

Deep uninstall with cache clearing - can help sometimes if you have meddled.

```bash
brew uninstall oboi-dlp
brew cleanup -s
rm -f "$(brew --cache)"/oboi-dlp-*
brew info oboi-dlp
find /usr/local -name "*oboi-dlp*" 2>/dev/null
find /opt/homebrew -name "*oboi-dlp*" 2>/dev/null
find ~/Library/Caches/Homebrew -name "*oboi-dlp*" 2>/dev/null
find ~/Library/Logs/Homebrew -name "*oboi-dlp*" 2>/dev/null
brew untap forshaws/homebrew-oboi-dlp
```

Remove configuration from `httpd.conf` and restart Apache.

---

## 🌟 Features

- **Automated DLP Protection** - Blocks sensitive data exfiltration
- **Real-time Processing** - Filters HTTP requests/responses as they happen  
- **Configurable Rules** - Customizable detection thresholds
- **Multi-platform** - Works on macOS and Linux
- **Enterprise Integration** - IMS/QMS audit exports
- **Fraud Detection** - Optional email/username scoring via TORIDION API
- **Instant Alerts** - ntfy.sh notifications for critical events

---

**Version 0.1.9** | For support and documentation: [toridion.com/oboi-dlp](https://toridion.com/oboi-dlp/)