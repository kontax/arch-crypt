# arch-crypt
## Overview
An Arch-based image with the goal of creating a read-only no network bootable
USB key, containing an encrypted LUKS partition. This contains scripts to 
generate GPG keys and certs as per [Dr Duh's Guide](https://github.com/drduh/YubiKey-Guide).

## Pre-requisites
* Blank 4GB+ USB key
* archiso

## Installation
Ensure the USB key is plugged in and take note of the device mapping, then run
the following:
```
$ git clone https://github.com/kontax/arch-crypt.git
$ make
$ sudo ./create-usb.sh
```

## Usage
