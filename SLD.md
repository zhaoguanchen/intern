# SLD

# 1. How to install SLD?

for the machine, I recommend `t2.medium` (at least 2 vCPU, 4 G Memory).

## 1.1 install docker

maybe you can create a bash file and paste these commands.

```bash
sudo vim install.sh
```

Paste these commands.

```BASH
sudo apt-get -y remove docker docker-engine docker.io containerd runc
sudo apt-get -y update
sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get -y update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

execute it

```bash
sudo sh install.sh
```



## 1.2 Clone the code 

```bash
git clone https://github.com/Biodepot-LLC/Stack-Lifecycle-Deployment.git
```

## 1.3 Configuration

### IBM

**install IBM Cloud CLI**

install IBM Cloud CLI, and login in.

The latest version of the IBM Cloud CLI is installed when you run the command. As the CLI installs, keep an eye on the command line to authenticate as needed.

- For MacOS, run the following command:

  ```
  curl -fsSL https://clis.cloud.ibm.com/install/osx | sh
  ```

- For Linux™, run the following command:

  ```
  curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
  ```

- For Windows™ 10 Pro, run the following command in PowerShell as an administrator:

  ```
  iex(New-Object Net.WebClient).DownloadString('https://clis.cloud.ibm.com/install/powershell')
  ```

**Log in to IBM Cloud**

Log in to IBM Cloud with your IBMid. If you have multiple accounts, you are prompted to select which account to use. If you do not specify a region with the `-r` flag, you must also select a region.

```
ibmcloud login
```

**modify configuration**

```bash
cd Stack-Lifecycle-Deployment/sld-dashboard
nano .env
```

modify the ibm-key.



## 1.4 Run

**Go to play.sh**

```bash
cd Stack-Lifecycle-Deployment/play-with-sld/docker/
```

**Execute start**

This step may take a pretty long time, depending on the machine.

```bash
sudo sh play.sh start
```

**Execute init**

```bash
sudo sh play.sh init
```

