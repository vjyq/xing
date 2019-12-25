# xing

xing is a tool to start a VPC with an aws EC2 installed with a self defined service in cli, which is named after a Chinese poem:

"春色满园关不住，一枝红杏（xìng）出墙来"

## Installation

### Get xing
```
git clone https://github.com/vjyq/huz.git
```

### Install requirements
```
cd xing
pip install -r requirements.txt
```

### Configs

#### Configure aws cli
https://docs.amazonaws.cn/en_us/cli/latest/userguide/cli-chap-configure.html

#### Configure VPC and EC2
update `./infrastructure/terraform.tfvars`

## Getting started
```
cd ./infrastructure

# update bootstrap.sh with the required service

terraform init

terraform plan # to see what is going to happen. If, as expected,

terraform apply
```

## Stop/start/... the instance
https://docs.aws.amazon.com/cli/latest/reference/

e.g.
```
aws ec2 stop-instances --instance-ids <instance-id>
aws ec2 start-instances --instance-ids <instance-id>
aws ec2 describe-instances --instance-ids <instance-id> --query 'Reservations[*].Instances[*].PublicIpAddress'
```

## Destroy everything?
```
terraform destroy
```

## Author
yuqing.ji@outlook.com
