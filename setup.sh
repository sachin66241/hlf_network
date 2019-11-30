echo
echo "GENERATING CRYPTO-ELEMENTS"
echo

sleep 1

../bin/cryptogen generate --config=./crypto-config.yaml

export FABRIC_CFG_PATH=$PWD

echo
echo "GENERATING GENESIS BLOCK"
echo

sleep 1

../bin/configtxgen \
    -profile Raft \
    -channelID byfn-sys-channel \
    -outputBlock ./channel-artifacts/genesis.block

export CHANNEL_NAME=mychannel

echo
echo "GENERATING CHANNEL CREATION ARTIFIACTS"
echo

sleep 1

../bin/configtxgen \
    -profile FourOrgsChannel \
    -outputCreateChannelTx ./channel-artifacts/channel.tx \
    -channelID $CHANNEL_NAME

echo
echo "GENERATING ANCHOR PEER UPDATE TRANSACTION ARTIFACTS"
echo

sleep 1

../bin/configtxgen \
    -profile FourOrgsChannel \
    -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx \
    -channelID $CHANNEL_NAME \
    -asOrg Org1MSP

../bin/configtxgen \
    -profile FourOrgsChannel \
    -outputAnchorPeersUpdate  ./channel-artifacts/Org2MSPanchors.tx \
    -channelID $CHANNEL_NAME \
    -asOrg Org2MSP

echo
echo "EXPORTING PRIVATE KEYS FOR RUNNING CAS"
echo

sleep 1

envfile=../../../../.env
cd crypto-config/peerOrganizations/
for((i=1;i<=$(ls -1 | wc -l);i++))
do
    cd $(ls -d -1 */ |sed -n $i'p')
    cd ca
    PV_KEY=$(ls *_sk)
    sed -i 's/^CA_PV'$i'=.*$/CA_PV'$i'='$PV_KEY'/' ../../../../.env
    cd ../..
done

cd ../..

echo
echo "STARING NETWORK"
echo

sleep 1

docker-compose -f docker-compose.yaml up -d


echo 
echo "GENERATING CONNECTION PROFILES"
echo

sleep 1
cd connection
./ccp-generate.sh