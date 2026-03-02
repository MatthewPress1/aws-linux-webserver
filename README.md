# Linux Web Server on AWS

## Overview
A hardened Apache web server deployed on AWS EC2 running Ubuntu, accessible at [matthewpress.net](https://matthewpress.net) with HTTPS via Let's Encrypt.

## Technologies Used
- AWS EC2 (t3.micro, Ubuntu 24.04)
- Apache2
- Let's Encrypt / Certbot
- UFW Firewall
- Namecheap DNS

## Architecture
- EC2 instance with Elastic IP
- Domain pointing to Elastic IP via DNS A record
- Apache serving on ports 80 and 443
- SSL certificate auto-renewing via Certbot
- UFW allowing only ports 22, 80, 443

## Steps Taken
- Launched EC2 instance running Ubuntu on AWS with Elastic IP
- Created the SSH automation script and customized the local config file in ~/.ssh
- Installed Apache and configured the AWS security group to allow ports 80 and 443
- Purchased custom domain name and created both A, and www records pointing to my Elastic IP
- Installed Certbot to automatically configure Apache HTTPS and auto renew
- Set both PermitRootLogin and PasswordAuthentication to no to harden server
- Enabled UFW and allowed ports 22, 80, 443

## SSH Automation
```bash
# Checks if ssh-agent is already running, if not it starts it and saves the environment variables in agent.env
if ! pgrep ssh-agent > /dev/null 2>&1 ; then
        ssh-agent > ~/.ssh/agent.env
fi
# Applies environment variables to the current shell 
source ~/.ssh/agent.env > /dev/null 2>&1

# Checks if the key is already added to the agent, if not it adds it 
if ! ssh-add -l > /dev/null 2>&1 ; then
        ssh-add ~/.ssh/id_rsa_aws.pem > /dev/null 2>&1
fi
```

## SSH config

```ssh-config
Host aws
    HostName <your-ip>
    User ubuntu
```

## Challenges & Troubleshooting
I'm more comfortable with Azure but wanted to try AWS so I had to learn the console and make sure I was not going to get charged a bunch of money. I followed the free tier as best I could and setup budgets to alert me when my VM had hit a certain cost.

After I installed apache I wanted to see my website, but it wasn't loading the page. So I checked the status of the service, it said it was running. I thought about it for a few seconds and realized that I needed to add the allow rules for HTTP and HTTPS in the security group on the AWS console. 

## What I Learned
The navigation and setup of the AWS VM.

I got tired of typing in the identity file and IP Address of the VM, so I researched how to automate that process. I came across "ssh-agent", "ssh-add", and the "~/.ssh/config" file. The SSH automation script runs everytime I open a new shell but since it checks if ssh-agent is already running it won't create duplicate ssh-agents. The "/dev/null 2>&1" code redirects the standard output and error to null so I don't see the output everytime the script runs. So now all I have to do is run "ssh aws" and I am in my Linux VM.

I got familiar with the SSL certificate process. My prior experience was all local by being my own CA and self-signing the certicates. This was an exciting part of the project because I got to see the "connection is secure" message and the lock emblem next to it on my live website!

 I used the man pages frequently to learn about commands and services that were vital to completing the project.  
