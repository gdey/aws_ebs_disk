def initialize(*args)
   super
   @action = :create_and_mount 
end

actions :create_and_mount 

attribute :aws_secret_access_key, :kind_of  => String,  :required  => true
attribute :aws_access_key,        :kind_of  => String,  :required  => true
attribute :mount_point,           :kind_of  => String,  :required  => true
attribute :device,                :kind_of  => String,  :required  => true
attribute :size,                  :kind_of  => Integer, :required  => true
attribute :mount_options,         :kind_of  => String,  :default   => "defaults,auto,noatime,noexec"
attribute :description,           :kind_of  => String,  :default   => ""
attribute :fstype,                :kind_of  => String,  :default   => "ext4"
attribute :tags,                  :kind_of  => Hash,    :default   => {}

