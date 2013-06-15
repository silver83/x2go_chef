# provision a new m1.small Ubuntu 10.04 webserver
knife ec2 server create -r 'role[webserver]' -I ami-1d620e74 -f m1.small -A 'Your AWS Access Key ID' -K "Your AWS Secret Access Key"

knife solo prepare admin@ec2-54-226-159-138.compute-1.amazonaws.com