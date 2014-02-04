if node['platform'] == "centos"
  package "cronie"

  %w{ sendmail crond }.each do |svc|
    service svc do
      action [ :enable, :start ]
    end
  end
end

tarsnap_archive "System configs" do
  pathnames %w{ /etc /usr/local/etc }
  day "*"
  hour "0"
  minute "0"
end
