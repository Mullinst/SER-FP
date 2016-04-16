SER Final Project - Group 18
==============================================


Required Libraries and Dependencies
-----------------------------------
1. [Git](http://git-scm.com/downloads)
2. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
3. [Vagrant](https://www.vagrantup.com)


How to Run Project
------------------
1. Download project repository.
2. In terminal (or equivalent command line application), navigate to the repository directory.
3. Navigate to the vagrant directory.
4. Execute the following commands in order:
	* `vagrant up` (powers on the virtual machine)
	* `vagrant ssh` ​(logs into the virtual machine)​
	* `cd /vagrant​` to change directory to the s​ynced folders.
	* `cd src/` to change directory to src.
	* `psql` to access postgresql.
	* `\i example.sql` to create example database.


Copyright and license
---------------------
Code and documentation copyright 2015 Troy Mullins. Code released under [the MIT license]().