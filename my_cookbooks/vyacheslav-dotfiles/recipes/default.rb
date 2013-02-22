include_recipe "git"

user = "vyacheslav"
home = "/home/#{user}"

execute "dotfiles" do
  command <<-EOC
    git init
    git remote add origin git://github.com/vslinko/dotfiles.git
    git pull -u origin master
    git submodule update --init
  EOC
  creates "#{home}/.git"
  cwd home
  user user
end
