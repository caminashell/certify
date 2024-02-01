#!/bin/bash
## Self Signed Certificate Generator
## Because I wanted to make my machines life easier to bootstrap...

# if [ -z "$1" ]; then
# 	echo "provide a domain as an argument (e.g. home.local)"
# 	exit;
# fi

NC='\033[0m' # No Color / Reset
BOLD='\033[1m'
ITALIC='\033[2m'
GREY='\033[0;30m'
PURPLE='\033[0;35m'
BLUE='\033[0;36m'
GREEN='\033[0;32m'

# MACHINEHOST="$(hostname | awk '{print tolower($0)}')"
TIMESTAMP="$(date +%s)"
HASH="$(echo $TIMESTAMP | sha256sum | sed '$s/.$//')"
TRIM="$(echo $HASH | cut -c 1-7)"
# YEAR=$(date | awk '{print $6}' | sed 's/20//g')
YEAR=$(date +%y)
MONTH=$(date +%m)
DATE=$(date +%d)
TICK="✓"
FOLDER=".ssl"
SUCCESS="$NC[$GREEN$TICK$NC]$GREEN Created"
ARCHIVE="[+] Packing"
DRULE="=========================================================================================="
SRULE="------------------------------------------------------------------------------------------"

SCRNAME="certify"
SCRVERSION="v0.24.131"
SCRTITLE="Certify - Self-signed Certificate Generator"
SCRAUTHOR="Camina Shell"
SCRUSER="caminashell"
SIGNAGE=$BLUE"\n$SCRTITLE$NC $SCRVERSION, by $SCRAUTHOR (2018-$(date | awk '{print $6}'))$NC"

usage() {
  echo -e $SIGNAGE
  echo -e "\nUsage: $SCRNAME [common name] [country code] [state] [location] [organisation]"
  echo -e "\nExample: $SCRNAME home.local GB England London Acme.org"
  # echo -e "\nUsage: $SCRNAME [common name] [country code] [state] [location] [organisation] [[unit]]"
  # echo -e "\nExample: $SCRNAME home.local GB England London 'Acme Inc.' IT"
  echo -e "\nOptional Variables: N/A, N/A\n"
  echo -e "Press Ctrl+C to quit.\n\n"
}

create() {
  clear
  echo -e $SIGNAGE
  echo $DRULE
  echo -e "This tool is a work in progress..."
  echo -e "It makes use of OpenSSL(1) to generate key files and Tar(2) to create an archive."
  echo -e "If you see no version output for them below, install it first and rerun."
  echo $SRULE
  echo -e "\n(1)$GREEN OpenSSL$NC: $(openssl version)\n\n(2)$GREEN Tape Archive$NC: $(tar --version)\n"
  echo $SRULE
  echo -e "Originally conceived on Apple MacOS; Refactored for GNU/Linux."
  echo -e "Comments and suggestions welcome!\n"
  echo -e "https://github.com/$SCRUSER"
  echo -e "https://x.com/$SCRUSER"
  echo $DRULE
  echo -e "\n\nPress any key to create new certificates in $GREEN$HOME/$FOLDER/"$NC
  read -p ""

  mkdir -p ~/$FOLDER/$HASH
  cd ~/$FOLDER/$HASH

# https://www.rfc-editor.org/rfc/rfc1779#section-2.2
#
# Key     Attribute (X.520 keys)
# ------------------------------
# CN      CommonName
# L       LocalityName
# ST      StateOrProvinceName
# O       OrganizationName
# OU      OrganizationalUnitName
# C       CountryName
# STREET  StreetAddress

  openssl req -x509 -nodes -new -sha256 -days 1024 -newkey rsa:4096 -keyout ${1}.ca.key -out ${1}.ca.pem -subj "/C=${2}/CN=${1}" 2>/dev/null
  echo -e $SUCCESS ${1}.ca.key
  echo -e $SUCCESS ${1}.ca.pem

  openssl x509 -outform pem -in ${1}.ca.pem -out ${1}.ca.crt
  echo -e $SUCCESS ${1}.ca.pem
  echo -e $SUCCESS ${1}.ca.crt
  # echo -e $NC

  echo "authorityKeyIdentifier=keyid,issuer
  basicConstraints=CA:FALSE
  keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
  subjectAltName = @alt_names
  [alt_names]
  DNS.1 = $1
  DNS.2 = *.$1

  " > domains.ext

  openssl req -new -nodes -newkey rsa:2048 -keyout ${1}.key -out ${1}.csr -subj "/C=${2}/ST=${3}/L=${4}/O=${5}/CN=$1" 2>/dev/null
  # openssl req -new -nodes -newkey rsa:2048 -keyout ${1}.key -out ${1}.csr -subj "/C=${2}/ST=${3}/L=${4}/O=$(echo "$5")/CN=$1/OU=$(echo "$6")" 2>/dev/null
  echo -e $SUCCESS ${1}.key
  echo -e $SUCCESS ${1}.csr
  # echo -e $NC

  openssl x509 -req -sha256 -days 1024 -in ${1}.csr -CA ${1}.ca.pem -CAkey ${1}.ca.key -CAcreateserial -extfile domains.ext -out ${1}.crt 2>/dev/null
  echo -e $SUCCESS ${1}.ca.pem
  echo -e $SUCCESS ${1}.ca.key
  # echo -e $NC

  rm domains.ext
  # ls -l

  tar -cf ../$1.$TRIM.tgz *.*
  cd ..
  rm -rf ./$HASH
  echo -e $NC
  tar -tf ./$1.$TRIM.tgz | xargs -L 1 echo -e $ARCHIVE
  echo -e $NC

  echo -e $SUCCESS" ${HOME}/${FOLDER}/$1.$TRIM.tgz"
  echo -e $NC

 # Rethink this one...
  # if [[ "$OSTYPE" == "darwin"* ]] ; then
  #   echo -e "\nAdding certificate to MacOS keychain..."
  #   security add-trusted-cert -d -r trustAsRoot -p ssl -p basic -k $HOME/Library/Keychains/login.keychain-db $HOME/$FOLDER/$TRIM/$1.crt
  # fi

  read -p "Press enter to open certificates folder..."

  if [[ "$OSTYPE" == "darwin"* ]] ; then
    open $HOME/$FOLDER
  fi

  if [[ "$OSTYPE" == "linux-gnu"* ]] ; then
    cd $HOME/$FOLDER
    dolphin $HOME/$FOLDER &
  fi
}

trap quit SIGINT
trap quit SIGTERM

# Basic Parameter Logic
if [ -z "$1" ]; then
  usage;
  exit;
else
  create $1 $2 $3 $4 $5 $6
fi
