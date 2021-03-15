# ca-fabric-hyperledger-test

The topology of this network is represented by the image below:

![Network topology](https://hyperledger-fabric-ca.readthedocs.io/en/latest/_images/network_topology.png)

## How to execute

`docker-compose up`

## How to enter the container

`docker exec -it <container-name> bash`

how to permit shell execution:

`chmod +x <script_name>`


## How to clear volumes directory

`sudo rm -r ./volumes/*`

## Terminology

The term bootstrap refers to a set of operations that are executed as soon as the service start.

## Directory hierarchy

Executing the docker-compose will mount volumes of these machines on the volumes folder. Don't worry, the `volumes/` content is in `.gitignore`.

volumes/
├── tls/
|    └── ca/ 
├── org0
|    ├── ca/
|    └── orderer/  
├── org1
|    ├── ca/ 
|    └── peer1/ 
└── ...

There must be an independent TLS certificates provider organization. It's importance is to permit encryption of the packets being sent from fabric-ca-client. Also, this certificate may be copied to other instances that make use of the SDK. This organization consists of only a fabric-ca node. It's only responsability is to record users registries on `register` operations and to emit pair of public and private keys on `enroll` requests from it's registered users. These certificates will be used by these clients in order to provide secure communications between nodes. (You know, HTTPS)

There must be at least one reliable organization that provides a set of orderer nodes. In this example, the organization 0 has only 1 orderer node. It's CA only needs to register and enroll nodes from it's own organization. In order to an orderer node exist, there must be a `genesis block`. A `genesis block` is the initial block generated to a channel. A channel is a segregated blockchain that permit private transactions in a subnet from the fabric network.

The organization 1 may be replicated to more organizations and it's peers may be multiplied. Peers to exist must only have TLS certificate provided from TLS CA and a certificate generated by it's organization. Every peer is capable of executing transaction operations by emmiting it to a channel. The peers are the nodes that receive SDK requests to execute. They are called peer gateways for that reason.

## Pattern

Every service has a bootstrap shell script that automates it's initialization. Each script is stored in `scripts` directory under the specific service that it attends. Every service starts by going to `/home` (where the script is stored), gives permission to execute it and finally executes it.

In every one, inside `ca/crypto` folder, copy the TLS root certificate from the fabric ca tls to `ca-cert.pem`. It can be found on the TLS CA `/tmp/hyperledger/tls-ca/crypto/ca-cert.pem`.

## Services

### TLS organization

#### tls-ca

`docker-compose up tls-ca`

This node is a Certification Authority for TLS certificates. It'll generate certificates for every client to encrypt the content in the session OSI layer.

This service emits the certificates for each client on the specified volume on docker-compose. Each one of these certificates must be copied to other peers in order to grant them TLS encryption security.

### ORG0 organization

#### org0-ca

`docker-compose up org0-ca`

This node is the CA for organization 0. The organization 0 contribute with only an orderer node. That is why it's aliased as orderer-ca: because it's the CA for the organization that only has an orderer node.

The responsability for this node is to provide a certification for all the nodes from organization 0. i.e.: to provide a certificate for the orderer node and the admin of the orderer node.

#### org0-orderer

`docker-compose up org0-orderer`

This node is the orderer node. It can only exist if it has access to a `genesis.block` and a `channel.tx` files. By having access to these files it can receive transactions blocks from peers in order to order them and broadcast it to all peers from the same channel.

### ORG1 organization

#### org1-ca

`docker-compose up org1-ca`

This node is the CA for organization 1. The organization 1 contribute with 1 peer.

The responsability for this node is to provide a certification for all the nodes from organization 1. i.e.: to provide a certificate for the peers from organization 1 and the admin of the orderer node.

#### org1-peer

`docker-compose up org1-peer`

This node serves as a gateway for requests from traditional applications equipped with the SDK. It can interact with a channel to execute transactions on the ledger.

## The process of pre register and enrollment

## The docker directory

The docker directory has a set of `docker-compose` files for different purposes.

This repository may be used for 3 different approaches:

- If you want to deploy a simple experimental fabric network locally;
- If you want to deploy a relatively complex experimental fabric network locally;
- If you want to deploy a relatively complex experimental fabric network on cloud in which each organization is a EC2 instance;

Each one of the these cases has a dedicated readme to help setting this infrastructure.

From the experimental cloud docker swarm it may derive the production oriented artifact.

### Simple network

volumes/
├── tls/
|    └── ca/ 
├── org0
|    ├── ca/
|    └── orderer/  
└── org1
     ├── ca/ 
     └── peer1/ 

### Relatively Complex network

volumes/
├── tls/
|    └── ca/ 
├── org0
|    ├── ca/
|    └── orderer/  
├── org1
|    ├── ca/
|    ├── peer1/ 
|    └── peer2/ 
└── org2
     ├── ca/
     ├── peer1/ 
     └── peer2/ 

### Relatively Complex network on cloud

ec2-org0/
├── tls/
|    └── ca/ 
└── org0
     ├── ca/
     └── orderer/

ec2-org1/
└── org1
     ├── ca/
     ├── peer1/ 
     └── peer2/ 

ec2-org2/
└── org2
     ├── ca/
     ├── peer1/ 
     └── peer2/ 
