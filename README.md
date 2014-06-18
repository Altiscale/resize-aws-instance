# ResizeAwsInstance

This is a quick Ruby scipt to simplify the process of resizing and EBS based
AWS instance.  It use the aws-sdk (link) to automate the following steps:

    $ aws ec2 stop-instances --instance-id i-xxxxxxxx
    $ aws ec2 modify-instance-attribute --instance-id i-xxxxxxxx --instance-type xx.size
    $ aws ec2 start-instances --instance-id i-xxxxxxxx

## Installation

This is packaged as a gem to simplify the process of installation.  It does not
come with a shared library.  To install, simply run the following command:

    $ gem install resize_aws_instance

## Usage

    Simple script to resize EBS based AWS instance.

     Usage:
       resize_aws_instance [options]

     Note:
       The following AWS config options may be provided via environment variables:
         key-id     => AWS_ACCESS_KEY_ID
         secret-key => AWS_SECRET_ACCESS_KEY
         region     => AWS_DEFAULT_REGION

     Options:
      --instance-id, -i <s>:   AWS instance ID
           --key-id, -k <s>:   AWS access key ID
       --secret-key, -s <s>:   AWS secret access key
           --region, -r <s>:   AWS region
             --type, -t <s>:   Target instance type
         --snapshot, -n <s>:   Snapshot EBS volumes [none, root or comma separated
                               list IDs (a,b,c)] (default: none)
              --version, -v:   Print version and exit
                 --help, -h:   Show this message

## Contributing

1. Fork it ( https://github.com/[my-github-username]/resize-aws-instance/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
