SER Final Project - Group 18
Thomas Norby, Troy Mullins, Robert King, Jacky Liang
==============================================
<br>

Table of Contents
-----------------------------------
<br>
•Introduction<br>
•Contribution<br>
•Required Libraries and Dependencies<br>
•Installation<br>
•Terminating executables <br>
•Useful Documentation<br>
•Useful Git commands<br>
•Commit Message Syntax<br>
•Troubleshooting<br>
•Copyright and license<br>


Introduction
-----------------------------------

This program represents a scheduling application for a consulting company. It uses four tables Users, Permissions, Stores and Shifts. Demonstrated in our video you will see our GUI and query statements executed.
Users can log in, create or delete users and query information about users such as permission levels.


Contribution
-----------------------------------

Team Member 1 Thomas Norby: Contribution<br>
Team Member 2 Troy Mullins: Contribution<br>
Team Member 3 Robert King: Contribution<br>
Team Member 4 Jacky Liang: Contribution<br>


Required Libraries and Dependencies
-----------------------------------

1. [Git](http://git-scm.com/downloads)
2. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
3. [Vagrant](https://www.vagrantup.com)


Installation
------------------

To install and access the database use the following steps:<br>
1. Download project repository.<br>
2. In terminal (or equivalent command line application), navigate to the repository directory.<br>
3. Navigate to the vagrant directory.<br>
4. Execute the following commands in order:<br><br><br>
	• `vagrant up` (powers on the virtual machine)<br>
	• `vagrant ssh` (logs into the virtual machine)<br>
	• `cd /vagrant` to change directory to the synced folders.<br>
	• `cd src/` to change directory to src.<br>
	• `psql` to access postgresql.<br>
	• `\i database_setup.sql` to create filername database.<br>
	• `\q` to exit database.<br>
	• `python project.py` to run project.<br>
	• Open browser to `http://localhost:8000`<br>
<br><br>
You should now be able to access the database and select and view queries.
<br><br>
For troubleshooting any of the above steps please see the 'Troubleshooting' section below.


Terminating executables 
--------------------

To end your database session use the following steps:
* `control c` to interupt python.
* `exit` to exit ssh.
* `vagrant halt` to shutdown virtual machine. 


Useful Documentation
---------------------

Below is a list of different documentation for reference.
* [Python 2.7](https://www.python.org/download/releases/2.7/)
* [PEP 8](https://www.python.org/dev/peps/pep-0008/)
* [Flask](http://flask.pocoo.org/docs/0.10/quickstart/)
* [jinja2](http://jinja.pocoo.org/docs/dev/)
* [jinja template docs](http://jinja.pocoo.org/docs/dev/templates/)
* [Bootstrap](http://getbootstrap.com/)
* [Postgresql](http://www.postgresql.org/docs/9.3/static/index.html)
* [MDN](https://developer.mozilla.org/en-US/)


Basic Git commands
--------------------

Basic Git commands used in the creation of this project.
* `git clone https://github.com/Mullinst/SER-FP.git` to clone this repository.
* `git pull` to pull recent commits.
* `git add <filename>` to add file to commit.
* `git commit -m 'commit message'` to commit changes to local repository.
* `git push` to push local commits to github.


Commit Message Syntax
---------------------

Syntax for commit messages
* `docs:` for documentation.
* `feat:` for new feature.
* `fix:` for bug fixes.
* `refactor:` for refactoring.
* `style:` for style changes.


Troubleshooting
---------------------

Ensure that Git, VirtualBox and Vagrant are all up to date and installed for the correct operating system you are currently using if you receive an error message when running vagrant up from the command line
<br><br>
If you receive an error when running vagrant ssh make sure you are using the Git command line interface.
<br><br>
Make sure to have Postgresql installed on your computer. If you receive an error message stating “psql: FATAL:  role "vagrant" does not exist” type the following:
<br>'exit'
<br>'vagrant halt'
<br>'vagrant destroy'
<br>'vagrant up'
<br>'vagrant ssh'
<br>and continue the setup as normal
<br>

Copyright and license
---------------------

Code and documentation copyright 2016 Robert King, Jacky Liang, Troy Mullins, and Thomas Norby. Code released under [the MIT license](https://github.com/Mullinst/SER-FP/blob/master/LICENSE).
