#!/bin/bash
VOLUMES=./volumes
CLIENT_DIR=./client/org0/ca
CERTS=$CLIENT_DIR/crypto
CLIENT_HOME=$CLIENT_DIR/admin
cp $VOLUMES/org0/ca/crypto/ca-cert.pem $CERTS/tls-ca-cert.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=../crypto/tls-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$CLIENT_HOME
fabric-ca-client enroll -d -u https://rca-org0-admin:rca-org0-adminpw@0.0.0.0:7053
fabric-ca-client register -d --id.name orderer1-org0 --id.secret ordererpw --id.type orderer -u https://0.0.0.0:7053
fabric-ca-client register -d --id.name admin-org0 --id.secret org0adminpw --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7053