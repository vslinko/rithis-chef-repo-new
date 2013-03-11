name    "rithis_youtrack"
version "0.0.0"

%w{ nginx youtrack }.each do |cb|
  depends cb
end
