maintainer       "Gautam Dey"
maintainer_email "gdey@cpan.org"
license          "Apache 2.0"
description      "LWRPs for creating, formating, and mounting ebs volumes"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.0"
recipe           "aws_ebs_disk", "Provides LWRPS for creating, formating,"+
                 " and mounting ebs volumes"
supports         "ubuntu"
depends          "aws"   
