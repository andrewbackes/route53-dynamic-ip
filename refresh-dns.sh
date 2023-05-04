#!/usr/bin/env bash
set -e

if [ -z  "$RECORD_HOSTNAME" ]; then
    echo "RECORD_HOSTNAME env variable is required"
    exit 1
fi

if [ -z  "$ZONE_ID" ]; then
    echo "ZONE_ID env variable is required"
    exit 1
fi

if [ -z  "$AWS_PROFILE" ]; then
    echo "AWS_PROFILE env variable is required"
    exit 1
fi


RECORD_IP_ADDRESS=`host $RECORD_HOSTNAME | awk '{ print $4 }'`
if [ -z  "$RECORD_HOSTNAME" ]; then
    echo "Unable to resolve $RECORD_HOSTNAME"
    exit 1
fi

EXTERNAL_IP_ADDRESS=`curl -s 'https://api.ipify.org'`
if [ -z  "$EXTERNAL_IP_ADDRESS" ]; then
    echo "Unable to determine external IP address"
    exit 1
fi

if [[ "$RECORD_IP_ADDRESS" == "$EXTERNAL_IP_ADDRESS" ]]; then
    echo "The IP address for $RECORD_HOSTNAME is $RECORD_IP_ADDRESS and matches the external IP address $EXTERNAL_IP_ADDRESS"
    echo "No update needed"
else
    echo "THe IP address for $RECORD_HOSTNAME is $RECORD_IP_ADDRESS and does NOT match external IP address $EXTERNAL_IP_ADDRESS"
    echo "Updating $RECORD_HOSTNAME IP address to $EXTERNAL_IP_ADDRESS"
    aws route53 \
    --profile=$AWS_PROFILE \
    change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Update IP Address",
        "Changes": [
            {
                "Action": "UPSERT",
                "ResourceRecordSet": {
                    "Name": "'$RECORD_HOSTNAME'",
                    "Type": "A",
                    "TTL": 300,
                    "ResourceRecords": [
                        {
                            "Value": "'$EXTERNAL_IP_ADDRESS'"
                        }
                    ]
                }
            }
        ]
    }'
fi