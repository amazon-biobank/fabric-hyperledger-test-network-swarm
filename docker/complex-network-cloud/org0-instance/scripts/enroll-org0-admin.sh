#!/bin/bash
VOLUMES=./volumes
CLIENT_DIR=./client/org0
CERTS=$CLIENT_DIR/orderer/assets/ca
export FABRIC_CA_CLIENT_HOME=$CLIENT_DIR/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=../../../$CERTS/org0-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-org0:org0adminpw@0.0.0.0:7053
mkdir -p $CLIENT_DIR/orderer/msp/admincerts
cp $CLIENT_DIR/admin/msp/signcerts/cert.pem $CLIENT_DIR/orderer/msp/admincerts/orderer-admin-cert.pem