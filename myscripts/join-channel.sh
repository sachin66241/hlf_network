export CHANNEL_NAME=mychannel

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/adminOrg.cybro-blockchain/users/Admin@adminOrg.cybro-blockchain/msp
CORE_PEER_ADDRESS=peer1.adminOrg.cybro-blockchain:7051
CORE_PEER_LOCALMSPID="Org1MSP"
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/adminOrg.cybro-blockchain/peers/peer1.adminOrg.cybro-blockchain/tls/ca.crt


peer channel create \
    -o orderer1.cybro-blockchain:7050 \
    -c $CHANNEL_NAME \
    -f ../channel-artifacts/channel.tx \
    --outputBlock ../$CHANNEL_NAME.block \
    --tls \
    --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/cybro-blockchain/orderers/orderer1.cybro-blockchain/msp/tlscacerts/tlsca.cybro-blockchain-cert.pem

peer channel join -b ../mychannel.block


peer channel update \
    -o orderer1.cybro-blockchain:7050 \
    -c $CHANNEL_NAME \
    -f ../channel-artifacts/Org1MSPanchors.tx \
    --tls \
    --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/cybro-blockchain/orderers/orderer1.cybro-blockchain/msp/tlscacerts/tlsca.cybro-blockchain-cert.pem


echo "PEER 2"
sleep 1

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/userOrg.cybro-blockchain/users/Admin@userOrg.cybro-blockchain/msp
CORE_PEER_ADDRESS=peer1.userOrg.cybro-blockchain:9051
CORE_PEER_LOCALMSPID="Org2MSP"
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/userOrg.cybro-blockchain/peers/peer1.userOrg.cybro-blockchain/tls/ca.crt

peer channel join -b ../mychannel.block

peer channel update \
    -o orderer1.cybro-blockchain:7050 \
    -c $CHANNEL_NAME \
    -f ../channel-artifacts/Org2MSPanchors.tx \
    --tls \
    --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/cybro-blockchain/orderers/orderer1.cybro-blockchain/msp/tlscacerts/tlsca.cybro-blockchain-cert.pem
