# 
# Author:: Joshua Timberman <joshua@opscode.com>
# Copyright:: Copyright (c) 2012, Opscode, Inc. <legal@opscode.com>
# License:: Apache License, Version 2.0
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
########################################################################
# NOTICE
########################################################################
# While this is a shell script that can be executed, you'll probably
# want to simply copy/paste the content into a shell, especially for
# the MANUAL STEP below. You can also put this in a Jenkins/CI build
# job and have automatically built AMIs.
#
########################################################################

# Arbitrary name of the AMI. You will need to change this.
export NAME=ubuntu-12.04-workstation-2012-06-18
export BUCKET=my-chef-ami-bucket

# Log in as the Ubuntu user and ensure history is clear, then su to root
export HISTSIZE=0
sudo su -
export HISTSIZE=0

# Set up multiverse (for ec2 tools)
(
cat <<EOF
deb http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ precise multiverse
deb-src http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ precise multiverse
deb http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ precise-updates multiverse
deb-src http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ precise-updates multiverse
deb http://security.ubuntu.com/ubuntu precise-security multiverse
deb-src http://security.ubuntu.com/ubuntu precise-security multiverse
EOF
) > /etc/apt/sources.list.d/multiverse.list

# Update the APT cache, perform a full upgrade of all packages, and
# install the packages required for "workstations" and the EC2 tools
# required for bundling an AMI.
apt-get update
aptitude safe-upgrade
aptitude install whois ack-grep git subversion mercurial bzr vim-nox emacs23-nox emacs-goodies-el gnome-core vnc4server ec2-api-tools ec2-ami-tools gedit x11vnc

# Add AWS configuration. You will need to supply your AWS data.
mkdir -p /mnt/ec2

(
cat <<EOF
KEY_FILE_NAME=/mnt/ec2/pk.pem
CERT_FILE_NAME=/mnt/ec2/cert.pem
EC2_PRIVATE_KEY=$KEY_FILE_NAME
EC2_CERT=$CERT_FILE_NAME
AWS_ACCOUNT_ID="your account #"
AWS_ACCESS_KEY_ID="your access key"
AWS_SECRET_ACCESS_KEY="your secret access key"
AMAZON_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
AMAZON_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
 
export EC2_PRIVATE_KEY EC2_CERT AWS_ACCOUNT_ID KEY_FILE_NAME CERT_FILE_NAME \
  AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AMAZON_ACCESS_KEY_ID AMAZON_SECRET_ACCESS_KEY
EOF
) > /mnt/ec2/config

# MANUAL STEP. Modify the config file, and fill in the contents of
# your AWS key files so that the AMI can be bundled.
vi -o /mnt/ec2/pk.pem /mnt/ec2/cert.pem /mnt/ec2/config
. /mnt/ec2/config

ec2-bundle-vol -c /mnt/ec2/cert.pem -k /mnt/ec2/pk.pem --user "$AWS_ACCOUNT_ID" -r x86_64 -p ${NAME}
ec2-upload-bundle --acl public-read -b ${BUCKET} -m /tmp/${NAME}.manifest.xml -a "$AMAZON_ACCESS_KEY_ID" -s "$AMAZON_SECRET_ACCESS_KEY"

ec2-register ${BUCKET}/${NAME}.manifest.xml -n ${NAME}
