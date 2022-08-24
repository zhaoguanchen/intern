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



# 2. IBM Cloud

## 2.1 create IBM cloud account

Open `Cloud Accounts`- `IBM`, create a new Account. You can just select the default option.

Put your Api-Key.

## 2.2 Create Stack

**Image**

Maybe Ubuntu.(which you want)

**Key**

the key you created via IBM Cloud.

**Zone**

`us-south` is better.

**Port**

the port that you want to open to the public.

**User data**

bash commands that you want to execute.

For Bwb, it is:

```bash
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
sudo docker pull biodepot/bwb:latest
sudo docker run --rm -p 6080:6080 -v ${PWD}:/data -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/.X11-unix:/tmp/.X11-unix  --privileged --group-add root biodepot/bwb
```

*remember to add `sudo` and `-y`.*

## 2.3 Create Deploy

Click `Deploy`.

Then you will have a new instance on IBM Cloud.