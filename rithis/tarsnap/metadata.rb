name             'tarsnap'
maintainer       'Rithis Studio'
maintainer_email 'mail2ignis@gmail.com'
license          'All rights reserved'
description      'Installs/Configures tarsnap'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w{ build-essential }.each do |dep|
  depends dep
end
