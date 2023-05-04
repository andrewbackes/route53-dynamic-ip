# route53-dynamic-ip

Dynamically update IPs for records using AWS Route53.

This tool updates a single DNS record that exists in an AWS Route53 zone with
the external IP address of the machine running it. It is used when you're router has
a dynamic IP address but you would like to keep a hostname associated with it.


## Usage

Set the required environment variable and run `update-dns.sh`. 

Environment variables:

| Name | Description
| --- | --- |
| AWS_PROFILE | Name of the profile in the AWS credentials file |
| RECORD_HOSTNAME | Hostname of the record to update. Ex: www.example.com |
| ZONE_ID | Zone ID for the record. Can be found in the AWS console. |

## Docker

Example usage:

```
$ docker run -ti \
    --name route53-dynamic-ip \
    -e AWS_PROFILE=my-profile \
    -e RECORD_HOSTNAME=www.example.com \
    -e ZONE_ID=AKAI123456 \
    -m "~/.aws/credentials":/root/.aws/credentials \
    andrewbackes/route53-dynamic-ip:v1
```

Kubernetes examples can be found in `./kubernetes/`.