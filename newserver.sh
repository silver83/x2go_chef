# provision a new m1.small Ubuntu 10.04 webserver
knife ec2 server create -I ami-1d620e74 -G default -f t1.micro -x admin
knife solo bootstrap admin@ec2-184-73-140-228.compute-1.amazonaws.com