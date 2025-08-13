## ⌨️ oboi&trade; Data Leakage Protection (DLP)

![Alt Text](oboi_logo_colour.png)

## 🌟 What is DLP - and what is oboi-dlp? 
**oboi-dlp;** is a DLP filter that protects your data from being leaked to third parties becuase of error, ommission or undetected vulnerabilities in your system. **oboi-dlp** installs as a Apache module that intelligently filters inbound and outbound payloads and blocks them from being served if they contain sensitive data. It also notifies you if exfiltration blocking has happened, then formats these notifications in to weekly audit reports that will import easily into your IMS (integrated Quality Management System) for compliance and quality reporting.

**oboi-dlp** has the ability to utilise TORIDION's TQNN FraudTagger scoreUsername API to detect POST payloads contaning email/usernames and validate against their enterprise fraud detection model at server level rather than code level. This added protection helps your web service/api/mobile apps flag or even block suspicious emails. Existing oboi licenses will be detected and used without further configuration!

<br /><br />

## 🌟 Features 

⦿ **Major data types protected automatically** blocks exfiltration of sensitive data

⦿ **Out of the box exfil DLP** for Apache and all connected surfaces (Mysql/RDS/AWS/S3)

⦿ **Easy IMS/QMS Audit Export** Exports IMS ready audits for your compliance system

⦿ **Notifications of critical events** get notified of xfil events as they happen

⦿ **HTTP_POST payload  fraud scan** at server level to detect/block spoofers

⦿ **Email/Username scoring** against enterprise grade fraud detection API

<br /><br />

## 💻 Beta Status

This software is in non commerical beta until this notice is removed
<br /><br /><br />
## ⚙️ Installation Instructions

### **Step 1: Install the tap and oboi-dlp**
Run these commands in your terminal to install:

```bash
brew tap forshaws/homebrew-oboi-dlp
brew install oboi-dlp
```

### **Step 2: Enable oboi-dlp in Apache**

In Step 1, you installed the **oboi-dlp** software. Now, you simply need to enable it in Apache by finding your active ```httpd.conf``` file and adding the required lines.
<br />
<br />

**A: Locate your Apache installation**
<br />Run:

```bash
which httpd
```
or
```bash
apachectl -V | grep HTTPD_ROOT
```

This will tell you where Apache is installed.
<br />
<br />


**B: Find your active httpd.conf**
<br />Run:

```bash
apachectl -V | grep SERVER_CONFIG_FILE
```

For example, the output might be:
```ini
SERVER_CONFIG_FILE="/usr/local/etc/httpd/httpd.conf"
```
You can open it directly with:
```bash
nano $(apachectl -V | grep SERVER_CONFIG_FILE | cut -d'"' -f2)
```



**C: Enable the required Apache modules**
<br />Inside httpd.conf, ensure this line is uncommented (remove the # if present):

```apache
LoadModule ext_filter_module lib/httpd/modules/mod_ext_filter.so
```
**note** the module path may differ from ```lib/httpd/modules/```. The important thing is to find the start of the line <br /> 
```#LoadModule ext_filter_module``` and uncomment it.
<br /><br />

**D: Add oboi-dlp configuration**
<br />At the bottom of your ```httpd.conf```, add:


```ini
# OBOI-DLP Configuration
Include /usr/local/etc/httpd/oboi-dlp.conf
```


Save the file and exit Nano.

**E: Test and restart Apache**
Check your Apache configuration for syntax errors:


```bash
apachectl configtest
```
If there are no warnings, restart Apache to apply changes (your restart may be different):
```bash
sudo apachectl restart
```
<br /><br />

## **🛠 Useful Apache Commands**

Check Apache status:
```bash
sudo apachectl status
```

View Apache error log:

```bash
tail -f /usr/local/var/log/httpd/error_log
```

View Apache access log:
```bash
tail -f /usr/local/var/log/httpd/access_log
```

Stop Apache:
```bash 
sudo apachectl stop
```

Start Apache:
```bash
sudo apachectl start
```
Restart Apache:
```bash
sudo apachectl restart
```



<br /><br />
## ⚙️ Uninstall Instructions  

Run this command in your terminal:

```bash
brew uninstall oboi-dlp
```



<br /><br />

## 📧 Usage Instructions 

oboi-dlp&trade; 

**Recommended : Adding your apikey to the env**

By adding the apikey to your environment variables you can activate oboi-dlp license. If your apikey is set in env, then oboi-dlp just uses your api credits.** If no key is set in env or on the command line it will default to free trial mode**. 

Add your key to the env by using the following command:

```bash
export OBOI_DLP_APIKEY="YOUR_API_KEY_GOES_HERE"
```

Remove the key using the following command:

```bash
unset OBOI_DLP_APIKEY
```





## 🔐 Free Usage & Fair Use

**oboi-dlp** trial mode is free to use under the license for personal, educational, and prototyping purposes.

Usage beyond this will require a valid API license key, please [view the API plans](https://toridion.com/oboi-dlp/) for license details for commercial use.

