def initialize(*args)
   super
   @action = :create_and_mount 
end

actions :create_and_mount 

attributes :aws_secret_access_key, :kind_of  => String,  :required  => true
attributes :aws_access_key,        :kind_of  => String,  :required  => true
attributes :mount_point,           :kind_of  => String,  :required  => true
attributes :device,                :kind_of  => String,  :required  => true
attributes :size,                  :kind_of  => Integer, :required  => true
attributes :mount_options,         :kind_of  => String,  :default   => "defaults,auto,noatime,noexec"
attributes :description,           :kind_of  => String,  :default   => ""
attributes :fstype,                :kind_of  => String,  :default   => "ext4"
attributes :tags,                  :kind_of  => Hash,    :default   => {}

