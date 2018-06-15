# A dummy plugin for Barge to set hostname and network correctly at the very first `vagrant up`
module VagrantPlugins
  module GuestLinux
    class Plugin < Vagrant.plugin("2")
      guest_capability("linux", "change_host_name") { Cap::ChangeHostName }
      guest_capability("linux", "configure_networks") { Cap::ConfigureNetworks }
    end
  end
end

Vagrant.configure(2) do |config|
  config.vm.define "p4-barge"

  config.vm.box = "ailispaw/barge"

  config.vm.provider :virtualbox do |vb|
    vb.cpus   = 2
    vb.memory = 2048
  end

  config.vm.synced_folder ".", "/vagrant", id: "vagrant"

  config.vm.provision :shell, run: "always" do |sh|
    sh.inline = <<-EOT
      pkg install git
    EOT
  end

  config.vm.provision :shell do |sh|
    sh.privileged = false
    sh.inline = <<-EOT
      git config --global http.sslCAinfo /etc/ssl/certs/ca-certificates.crt
      git clone https://github.com/p4lang/tutorials.git /vagrant/tutorials
    EOT
  end
end
