#!/usr/bin/env ruby

require 'aws'
require 'pp'
require 'pty'
require 'FileUtils'

# helper method for spawning knife procs and showing the output in the current shell
def spawn(command)
    PTY.spawn(command) do |output, input, pid|
        begin
          # Do stuff with the output here. Just printing to show it works
          output.each { |line| print line }
        rescue Errno::EIO
          puts "that the process has finished giving output"
        end
    end
end

#create a server in EC2, with a name we can identify later
server_name = "desktop#{rand(10000)}"
spawn "knife ec2 server create -I ami-1d620e74 -G default -f t1.micro -x admin -N #{server_name}"

#find the server we just created. TODO : maybe we could have done this more easily without knife ?
ec2 = AWS::EC2::Base.new(:access_key_id => "#{ENV['AMAZON_ACCESS_KEY_ID']}",:secret_access_key => "#{ENV['AMAZON_SECRET_ACCESS_KEY']}")
resp = ec2.describe_tags(:filter => [{'resource-type' => ['instance']}, {'key' => ['Name']},{'value' => [server_name]}])

instance = resp["tagSet"]["item"].first if resp["tagSet"] and resp["tagSet"]["item"] and resp["tagSet"]["item"].first 
puts 'no instances found' || abort unless instance

instance_id = instance["resourceId"] 
puts 'failed finding instance_id after creation' || abort unless instance_id

instances = ec2.describe_instances()["reservationSet"]["item"].collect { |is| is["instancesSet"]["item"].first }
instance = instances.select { |i| i["instanceId"] == instance_id }.first

#get the dns name for the instance
instance_dns = instance["dnsName"]

#replicate the template node file to a filename matching the new node
FileUtils.copy('nodes/desktop_template.json', "nodes/#{instance_dns}.json")
puts "created nodes/#{instance_dns}.json for new server named #{server_name}"

#start chef solo bootstrap
spawn "knife solo bootstrap admin@#{instance_dns}"

puts "Done."
