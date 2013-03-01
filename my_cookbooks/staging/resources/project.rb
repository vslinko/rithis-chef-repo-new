actions :enable, :disable
default_action :enable

attribute :name, :kind_of => String, :name_attribute => true
attribute :repository, :kind_of => String
attribute :reference, :kind_of => String
attribute :port, :kind_of => Integer
attribute :script, :kind_of => String
