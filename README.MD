# SupportManager Server Scripts
This repository contains the scripts used to manage a SupportManager server. The scripts are designed to be run on a Ubuntu 22.04 server.

## Installation
To install the scripts, run the following command:
```bash 
git clone TomEasterbrook/support-manager-Server-Scripts
```
You can then run the scripts using the following command:
```bash
bash ./path/to/script.sh
```
Any secrets required by the scripts will be prompted for when the script is run. In time, these will be replaced with environment variables.

## Scripts

### server-setup.sh
This script is used to setup a new server. It will install the required packages, setup the required users and groups, and configure the firewall.

