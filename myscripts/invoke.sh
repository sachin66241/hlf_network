CONTRACT=mytoken

peer chaincode invoke \
    -o orderer1.cybro-blockchain:7050 \
    --tls true \
    --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/cybro-blockchain/orderers/orderer1.cybro-blockchain/msp/tlscacerts/tlsca.cybro-blockchain-cert.pem \
    -C $CHANNEL_NAME \
    -n $CONTRACT \
    --peerAddresses peer1.adminOrg.cybro-blockchain:7051 \
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/adminOrg.cybro-blockchain/peers/peer1.adminOrg.cybro-blockchain/tls/ca.crt \
    --peerAddresses peer1.userOrg.cybro-blockchain:9051 \
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/userOrg.cybro-blockchain/peers/peer1.userOrg.cybro-blockchain/tls/ca.crt \
    -c '{"Args":["allote","Org1MSP","10"]}'