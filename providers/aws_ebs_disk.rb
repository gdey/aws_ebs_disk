#include_recipe 'aws'

action :create_and_mount do

   Chef::Log.debug("Going to create and Attaching ebs volume");

   aws_ebs_volume new_resource.name do 
      aws_access_key new_resource.aws_access_key
      aws_secret_access_key new_resource.aws_secret_accesss_key
      size new_resource.size
      device new_resource.device
      description new_resource.description
      action [ :create, :attach ]
   end
   
   # This is true for ubuntu.
   guest_device = new_resource.device.sub(/\/dev\/s/, '/dev/xv');
   script "Formatting volume #{guest_device}" do
      interpreter "bash"
      cwd "/"
      code "mke2fs -t #{new_resource.fstype} -F #{guest_device} -L '#{new_resource.name}'"
      user "root"
      not_if "blkid #{guest_device} | grep 'TYPE=\"#{new_resource.fstype}\"", 
             :user => "root", :cwd => "/"
   end

   mount new_resource.mount_point do 
      device guest_device
      fstype new_resource.fstype
      options new_resource.mount_options
      action [:mount, :enable]
   end

   # Let's tag our resource.
   aws_resource_tag node['aws']['ebs_volume'][new_resource.name]['volume_id'] do

      resource_tags                         = new_resource.tags
      resource_tags["Mount Point"]          = new_resource.mount_point
      resource_tags["FS Type"]              = new_resource.fstype
      resource_tags["Guest Device"]         = guest_device
      resource_tags["Device"]               = new_resource.device
      resource_tags["Attached Instance ID"] = node.ec2.instance_id

      node.set['aws']['ebs_volume'][new_resource.name]['mount_point']         = new_resource.mount_point
      node.set['aws']['ebs_volume'][new_resource.name]['fstype']              = new_resource.fstype
      node.set['aws']['ebs_volume'][new_resource.name]['device']              = new_resource.device
      node.set['aws']['ebs_volume'][new_resource.name]['size']                = new_resource.size
      node.set['aws']['ebs_volume'][new_resource.name]['guest_device']        = guest_device
      node.set['aws']['ebs_volume'][new_resource.name]['aws_ebs_disk_action'] = "create_and_mount"

      aws_access_key new_resource.aws_access_key
      aws_secret_access_key new_resource.aws_secret_accesss_key
      tags resource_tags
      node.save
      action :update

   end



end


