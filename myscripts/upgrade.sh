CONTRACT=mytoken
VERSION=$1
CONTRACT_PATH=/opt/gopath/src/github.com/chaincode/

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/adminOrg.cybro-blockchain/users/Admin@adminOrg.cybro-blockchain/msp
CORE_PEER_ADDRESS=peer1.adminOrg.cybro-blockchain:7051
CORE_PEER_LOCALMSPID="Org1MSP"
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/adminOrg.cybro-blockchain/peers/peer1.adminOrg.cybro-blockchain/tls/ca.crt

peer chaincode install \
    -n $CONTRACT \
    -v $VERSION \
    -l node \
    -p $CONTRACT_PATH

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/userOrg.cybro-blockchain/users/Admin@userOrg.cybro-blockchain/msp
CORE_PEER_ADDRESS=peer1.userOrg.cybro-blockchain:9051
CORE_PEER_LOCALMSPID="Org2MSP"
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/userOrg.cybro-blockchain/peers/peer1.userOrg.cybro-blockchain/tls/ca.crt

peer chaincode install \
    -n $CONTRACT \
    -v $VERSION \
    -l node \
    -p $CONTRACT_PATH


peer chaincode upgrade \
    -o orderer1.cybro-blockchain:7050 \
    --tls \
    --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/cybro-blockchain/orderers/orderer1.cybro-blockchain/msp/tlscacerts/tlsca.cybro-blockchain-cert.pem \
    -C mychannel \
    -n $CONTRACT \
    -v $VERSION \
    -l node \
    -p $CONTRACT_PATH \
    -c '{"function":"initLedger","Args": ["SimpleToken:initLedger"]}' \
    -P "AND ('Org1MSP.member','Org2MSP.member')"