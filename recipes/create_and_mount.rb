#
# Cookbook Name:: aws_ebs_disk
# Recipe:: create_and_mount
#
# Copyright 2013 Gautam Dey <gdey@cpan.org>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#

unless node['aws'].nil? begin 

  # include_recipe 'aws';
   
   app_environment = node["app_environment"] || "development"
   aws = search(:aws,"id:#{app_environment}").first
   
   volumes = node['aws']['ebs_volume'];
   
   volumes.each do | volume_name, volume_hash |
   
      # Skip the volumes we do not know what to do with
      next if volume_hash['aws_ebs_disk_action'].nil? or 
            ( volume_hash['aws_ebs_disk_action'] != "create_and_mount" )

      resource_tags = {};
      resource_tags.merge!( node['aws']['tags'] ) unless node['aws']['tags'].nil?
      resource_tags.merge!( volume_hash['tags'] ) unless volume_hash['tags'].nil?
      resource_tags["Chef Environment"] = node.chef_environment
      resource_tags["App Environment"]  = app_environment

      aws_ebs_disk volume_name do
         aws_secret_access_key aws['aws_secret_access_key']
         aws_access_key aws['aws_access_key_id']
         description "Attaching to instance #{node.ec2.instance_id}"
         mount_point volume_hash["mount_point"]
         device volume_hash["device"]
         fstype volume_hash["fstype"]
         size volume_hash["size"]
         tags resource_tags
      end
   
   end

   aws_resource_tag node['ec2']['instance_id'] do

      resource_tags = {};
      resource_tags.merge!( node['aws']['tags'] ) unless node['aws']['tags'].nil?
      
      resource_tags["Chef Environment"] = node.chef_environment
      resource_tags["App Environment"]  = app_environment

      aws_access_key aws['aws_access_key_id']
      aws_secret_access_key aws['aws_secret_access_key']

      tags resource_tags
      action :update

   end

end


