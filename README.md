# Install Tibco ActiveMatrix Service Grid 2 on a CentOS VirtualBox VM using Vagrant and Puppet

In this project I aim to share what I have done to install the following TIBCO products on a dev machine:
* TIBCO Enterprise Message Service (EMS 5.1.5)
* TIBCO ActiveMatrix Service Grid (AMSG 2.3.2)
 
This proof of concept can be expanded for other environments.
Disclaimer: I am no expert in using Vagrant and Puppet.

There are probably two (obvious) ways of installing TIBCO products. Either extract the installation zip/tar files and then to do silent installs or create rpm files.
I chose the option to install from rpms as that is often recommended in forums for other products. Creating the rpm files takes a bit longer, but the actual installs are then reasonably fast.

I did not commit the actual rpm files I created as Tibco will not approve.

## Git clone this project

Start of by cloning [this github project](https://github.com/charlbrink/vagrant-puppet-tibco-amsg2)
Verify the configuration:
* Set your proxy settings in manifests/nodes.pp or remove if not required
* Verify modules/amsg2/manifests/params.pp
* You may also need to set the OS environment variable HTTP_PROXY to http://${proxy_username}:${proxy_password}@${proxy.server}:${proxy_port} replacing variables with your actual values. This is used for downloading the vagrant box.

## Create Tibco RPMs

The method I used was to manually install TIBCO Enterprise Message Service (EMS), TIBCO ActiveMatrix Service Grid (AMSG)in one TIBCO_HOME (/home/vagrant/local/tibco) and also sharing the same configuration folder (/home/vagrant/local/tibco).
**Do not run the TIBCO Configuration tool as part of the installtion!**

Using [FPM](https://github.com/jordansissel/fpm/wiki) one can easily create rpms as follows:
* fpm -s dir -t rpm -n "amsg" -v 3.2.0 /home/vagrant/amsg_home /home/vagrant/amsg_data to create the file amsg-3.2.0-1.x86_64.rpm and
* fpm -s dir -t rpm -n "ems" -v 6.3 /home/vagrant/ems_home /home/vagrant/ems_data to create the file ems-6.3-1.x86_64.rpm

FPM requires package rpm-build to be installed (sudo yum install rpm-build) to build an rpm.

Overwrite the provided files:
* modules/amsg2/files/amx-2.3.2-1.x86_64.rpm file and
* modules/amsg2/files/jdk-6u38-linux-amd64.rpm (only needed for running TIBCO installers, extracted from Oracle provided rpm.bin package)

## Create the CentOS VM instance

Required software to be installed on the host:
* [Vagrant](http://www.vagrantup.com/)
* [Oracle VM VirtualBox](https://www.virtualbox.org/)

Run "vagrant up" to set up a Virtualbox VM with CentOS and then install the required packages as well as GNOME.
Log in to the vm with username/password vagrant/vagrant and start GNOME with "sudo init 5" if a graphical environment is required.

## TIBCO Configuration
If you need to configure an admin server:
* Start hsql database by executing /home/vagrant/local/tibco/amx/hsqldb/bin/amx-db 
* Create the admin server by executing /home/vagrant/local/tibco/amxadministrator/2.3/bin/createadminserver
* Start the admin server by executing /home/vagrant/local/tibco/amxadministrator/2.3/bin/amx-admin.sh
