#!/bin/bash

# How this script works?

# First of all I have defined a couple of variables to declare different types of file which we will use thorugh out the process
# Our certificates will be generated and stored under /certs folder
# I have created two functions separately to generate RootCA certificate and server certificate
# If a rootCA private key already exists then the script will skip the generation of rootCA certificate and continue with the generation of server certificate
# The rest of the script is using different openssl command to generate and verify respective private keys and certificates

PATH="client"
PATH_CERT="certs"
CLIENT_KEY="$PATH/client.key"
CLIENT_CSR="$PATH/client.csr"
CLIENT_CRT="$PATH/client.crt"
CLIENT_EXT="$PATH/client_ext.cnf"
CA_KEY="$PATH_CERT/ca.key"
CA_CRT="$PATH_CERT/cacert.pem"
OPENSSL_CMD="/usr/bin/openssl"
COMMON_NAME="$1"



function sign_client_certificate {

   
   
    #### for testing

    # echo "==> Print public key from CRT"
    #  $OPENSSL_CMD x509 -noout -pubkey -in $CLIENT_CRT

    # echo "==> Print public key from Private key"
    #   $OPENSSL_CMD pkey -pubout -in $CLIENT_KEY

    echo "==> Verifying the client certificate is signed by RootCA"
    # $OPENSSL_CMD verify -CAfile $CA_CRT $CLIENT_CRT >/dev/null 2>&1
    $OPENSSL_CMD verify -CAfile $CA_CRT $CLIENT_CRT 
     [[ $? -ne 0 ]] && echo "ERROR: Failed to verify $CLIENT_CRT against $CA_CRT" && exit 1
}

# MAIN
sign_client_certificate