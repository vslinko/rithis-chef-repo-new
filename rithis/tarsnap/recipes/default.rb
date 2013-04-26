#
# Cookbook Name:: tarsnap
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
require 'chef/data_bag'

include_recipe "build-essential"

dependencies = case node['platform']
               when 'centos', 'redhat'
                 %w{ openssl-devel zlib-devel e2fsprogs-devel mailx }
               when 'debian', 'ubuntu'
                 %w{ libssl-dev zlib1g-dev e2fslibs-dev }
               else 
                 raise "Unsupported platform"
               end

dependencies.each do |pkg|
    package pkg
end

tarsnap_archive_name = ::File.basename(node['tarsnap']['source_url'])
tarsnap_archive_dir  = ::File.basename(node['tarsnap']['source_url'], ".tgz")

remote_file "#{Chef::Config[:file_cache_path]}/#{tarsnap_archive_name}" do
  source   node['tarsnap']['source_url']
  checksum "0c0d825a8c9695fc8d44c5d8c3cd17299c248377c9c7b91fdb49d73e54ae0b7d"
end

execute "Unpack tarsnap source distribution" do
  command "tar xzf #{tarsnap_archive_name}"
  cwd     Chef::Config[:file_cache_path]

  not_if { ::File.directory? "#{Chef::Config[:file_cache_path]}/#{tarsnap_archive_dir}" }
end

bash "Build tarsnap client" do
  cwd  "#{Chef::Config[:file_cache_path]}/#{tarsnap_archive_dir}"

  code <<-EOH
    set -x
    exec >  #{Chef::Config[:file_cache_path]}/chef-tarsnap-build.log
    exec 2> #{Chef::Config[:file_cache_path]}/chef-tarsnap-build.log
   ./configure && make all install clean
  EOH

  not_if { ::File.exists? "/usr/local/bin/tarsnap" }
end

tarsnap_keygen_cmd = <<-EOS 
  echo '#{node['tarsnap']['account_password']}' | /usr/local/bin/tarsnap-keygen \
    --keyfile /usr/local/etc/tarsnap.key \
    --user #{node['tarsnap']['account_login']} \
    --machine #{node['fqdn']}
EOS

unless ::File.exists?("/usr/local/etc/tarsnap.key")

  unless node['tarsnap']['machine_key'].nil?

    file "/usr/local/etc/tarsnap.key" do
      content node['tarsnap']['machine_key']
    end

  else

    execute "Generate keyfile for this machine" do
      command tarsnap_keygen_cmd
    end

    ruby_block "Store tarsnap key in an attribute" do
      block do 
        node.set['tarsnap']['machine_key'] = ::File.read("/usr/local/etc/tarsnap.key")
      end
    end
  end
end

file "/usr/local/etc/tarsnap.key" do
  owner "root"
  mode  "0600"
end

template "/usr/local/etc/tarsnap.conf" do
  mode "0644"
end

directory node['tarsnap']['cache_dir'] do
  recursive true
end
