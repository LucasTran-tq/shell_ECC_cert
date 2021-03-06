#!/bin/bash

# How this script works?

# First of all I have defined a couple of variables to declare different types of file which we will use thorugh out the process
# Our certificates will be generated and stored under /certs folder
# I have created two functions separately to generate RootCA certificate and server certificate
# If a rootCA private key already exists then the script will skip the generation of rootCA certificate and continue with the generation of server certificate
# The rest of the script is using different openssl command to generate and verify respective private keys and certificates

PATH="client"
CLIENT_KEY="$PATH/client.key"
CLIENT_CSR="$PATH/client.csr"
# CLIENT_CRT="$PATH/server.crt"
# CA_EXTFILE="$PATH/ca_cert.cnf"
CLIENT_EXT="$PATH/client_ext.cnf"
CLIENT_CONF="$PATH/client_cert.cnf"
OPENSSL_CMD="/usr/bin/openssl"
COMMON_NAME="$1"

function generate_client_certificate {

    echo "==> Generating client private key"
    $OPENSSL_CMD ecparam -out $CLIENT_KEY -name prime256v1 -genkey 2>/dev/null
    [[ $? -ne 0 ]] && echo "ERROR: Failed to generate $CLIENT_KEY" && exit 1

    echo "==> Generating certificate signing request for client"
    # $OPENSSL_CMD req -new -key $CLIENT_KEY -out $CLIENT_CSR -config $CLIENT_CONF -sha256 2>/dev/null
    $OPENSSL_CMD req -new -key $CLIENT_KEY -out $CLIENT_CSR -config $CLIENT_CONF 2>/dev/null
    [[ $? -ne 0 ]] && echo "ERROR: Failed to generate $CLIENT_CSR" && exit 1

    ###  for testing
    echo "==> Verify client CSR"
    $OPENSSL_CMD req -text -in $CLIENT_CSR -noout -verify

    echo "==> Print public key"
      $OPENSSL_CMD pkey -pubout -in $CLIENT_KEY
}

# MAIN
generate_client_certificate