## Packer Builder Template with SSH Bypass
A quick little workaround for using Packer in AWS whilst behind a firewall. :-)

#### Prerequisites

In order to use this tool you need the following already installed:
* Terraform (v0.11.7 as of writing this)
* Packer
* AWS Access Key for the account you want your packer builds to run in.
* A DEFAULT VPC is enabled in that account.
* You have a key pair setup in that account that Terraform can use for the bastion host.

#### But How Does It Work???

I'm glad you asked that question, Timmy.
Here's the secret = non-standard SSH ports.  :-)
Essentially we are launching a server running SSH on port 443 in the
default VPC of the account you authenticate to, and then using that
bastion to bounce the connection through to the ami that packer is
baking.

#### How do I get started?

1) Install prerequisites
1) Clone this repo
```bash
mkdir packer_skeleton
cd packer_skeleton
git clone ${REPO_NAME} .
```
1) Run the script titled "RUNME.sh"

And thats pretty much it.  At the end you will get an AMI id.  Default
values are set such that you should get a successful run in us-east-1.
You will want to customize some aspects.

#### Parts to customize

Most likely you will want to change the source_ami and the path
to the provisioning script.  Here are a few items that you can and
should customize

##### Variables JSON File (vars.json)

This script is a small json file with a few configurable values.
These will overwrite the variables at the top of packer.json.  Take a
look at the file in the "packer" directory called vars.json.template
and you'll see something like this:

```json
{
  "packer_source_ami": "ami-04169656fea786776",
  "packer_provisioner_script": "provision.sh",
  "packer_ami_name": "packerbuild-{{timestamp}}",
  "packer_ami_description": "Build from packer skeleton"
}
```

Arguably, the most important value in here would be packer_source_ami
as this would allow you to set the base image and OS to build on.
This template defaults to ubuntu, but you could use any linux image
as long as the provisioning script was valid for that operating system.

##### RUNME.sh

There is some logic in this script to discover certain values from
terraform and other places.  You can edit this script to your liking,
but don't commit your personal customizations.

##### Provisioner Scripts

There is a directory (./provisioners) where you should place all the
logic that you would like to run on the builder image to be included
in the resulting AMI.

There are a few ways to add provisioning logic:

1) Add paste bash script directly into provisioners/run.sh
1) Add a file to provisioners directory and add another provisioner
block to the packer.json. (ANY type of script as log as its supported
by packer.  (https://www.packer.io/docs/provisioners/index.html)


### Long Live Shadow IT
