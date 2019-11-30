#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $7)
    local CP=$(one_line_pem $8)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${ORGNO}/$2/" \
        -e "s/\${DOMAIN}/$3/" \
        -e "s/\${P1PORT}/$4/" \
        -e "s/\${P2PORT}/$5/" \
        -e "s/\${CAPORT}/$6/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ccp-template.json 
}

function yaml_ccp {
    local PP=$(one_line_pem $7)
    local CP=$(one_line_pem $8)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${ORGNO}/$2/" \
        -e "s/\${DOMAIN}/$3/" \
        -e "s/\${P1PORT}/$4/" \
        -e "s/\${P2PORT}/$5/" \
        -e "s/\${CAPORT}/$6/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ccp-template.yaml | sed -e $'s/\\\\n/\\\n        /g'
}

DOMAIN=cybro-blockchain

ORG=adminOrg
ORGNO=1
P1PORT=7051
P2PORT=8051
CAPORT=7054
PEERPEM=../crypto-config/peerOrganizations/$ORG.$DOMAIN/tlsca/tlsca.$ORG.$DOMAIN-cert.pem
CAPEM=../crypto-config/peerOrganizations/$ORG.$DOMAIN/ca/ca.$ORG.$DOMAIN-cert.pem

echo "$(json_ccp $ORG $ORGNO $DOMAIN $P1PORT $P2PORT $CAPORT $PEERPEM $CAPEM)" > profiles/connection-$ORG.json
echo "$(yaml_ccp $ORG $ORGNO $DOMAIN $P1PORT $P2PORT $CAPORT $PEERPEM $CAPEM)" > profiles/connection-$ORG.yaml

ORG=userOrg
ORGNO=2
P1PORT=9051
P2PORT=10051
CAPORT=9054
PEERPEM=../crypto-config/peerOrganizations/$ORG.$DOMAIN/tlsca/tlsca.$ORG.$DOMAIN-cert.pem
CAPEM=../crypto-config/peerOrganizations/$ORG.$DOMAIN/ca/ca.$ORG.$DOMAIN-cert.pem

echo "$(json_ccp $ORG $ORGNO $DOMAIN $P1PORT $P2PORT $CAPORT $PEERPEM $CAPEM)" > profiles/connection-$ORG.json
echo "$(yaml_ccp $ORG $ORGNO $DOMAIN $P1PORT $P2PORT $CAPORT $PEERPEM $CAPEM)" > profiles/connection-$ORG.yaml
