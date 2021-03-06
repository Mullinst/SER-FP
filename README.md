#SER Final Project - Group 18

Thomas Norby, Troy Mullins, Robert King, Jacky Liang
------------------------------------------

Table of Contents
-----------------------------------

1. [Introduction](#introduction)
2. [Contribution](#contribution)
3. [Required Libraries and Dependencies](#libraries)
4. [Installation](#installation)
5. [Terminating executables](#terminating)
6. [Useful Documentation](#documentation)
7. [Useful Git commands](#useful-commands)
8. [Commit Message Syntax](#syntax)
9. [Troubleshooting](#troubleshooting)
10. [Acknowledgements](#udacity)
11. [Copyright and license](#licensing)


<a name="introduction">Introduction</a>
============

This program represents a scheduling application for a consulting company. It uses four tables Users, Permissions, Stores and Shifts. Demonstrated in our video you will see our GUI and query statements executed. Users can log in, create or delete users and query information about users such as permission levels.


<a name="contribution">Contribution</a>
============

* `Team Member 1 Thomas Norby:` All iterations of ER diagram and insert statements for populating the stores table
* `Team Member 2 Troy Mullins:` All source code with the exception of insert statements for store information.
* `Team Member 3 Robert King:` Edited READme
* `Team Member 4 Jacky Liang:` Contributed to READme


<a name="libraries">Required Libraries</a>
-----------------------------------

1. [Git](http://git-scm.com/downloads)
2. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
3. [Vagrant](https://www.vagrantup.com)


<a name="installation">Installation</a>
------------------

To install and access the database use the following steps

1. Download project repository.
2. In terminal (or equivalent command line application), navigate to the repository directory.
3. Navigate to the vagrant directory.
4. Execute the following commands in order:
	* `vagrant up` (powers on the virtual machine)
	* `vagrant ssh` (logs into the virtual machine)
	* `cd /vagrant` to change directory to the synced folders.
	* `cd src/` to change directory to src.
	* `psql` to access postgresql.
	* `\i database_setup.sql` to create filername database.
	* `\q` to exit database.
	* `python project.py` to run project.
	* Open browser to `http://localhost:8000`

You should now be able to access the database and select and view queries.

For troubleshooting any of the above steps please see the `Troubleshooting` section below.


<a name="terminating">Terminating</a>
--------------------

To end your database session use the following steps:

1. `control c` to interupt python.
2. `exit` to exit ssh.
3. `vagrant halt` to shutdown virtual machine. 


<a name="documentaiton">Useful Documentation</a>
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


<a name="useful-commands">Useful Commands</a>
--------------------

Basic Git commands used in the creation of this project.

* `git clone https://github.com/Mullinst/SER-FP.git` to clone this repository.
* `git pull` to pull recent commits.
* `git add <filename>` to add file to commit.
* `git commit -m 'commit message'` to commit changes to local repository.
* `git push` to push local commits to github.


<a name="syntax">Git Commit Syntax</a>
---------------------

Syntax for commit messages

* `docs:` for documentation.
* `feat:` for new feature.
* `fix:` for bug fixes.
* `refactor:` for refactoring.
* `style:` for style changes.


<a name="troubleshooting">Troubleshooting</a>
---------------------

If you encounter errors attempting to set up this database on a Windows PC please read the following.

Ensure that Git, VirtualBox and Vagrant are all up to date and installed for the correct operating system you are currently using if you receive an error message when running vagrant up from the command line

If you receive an error when running vagrant ssh make sure you are using the Git command line interface.

Make sure to have Postgresql installed on your computer. If you receive an error message stating `psql: FATAL:  role "vagrant" does not exist` type the following:

1. `exit`
2. `vagrant halt`
3. `vagrant destroy`
4. `vagrant up`
5. `vagrant ssh`
6. Continue the setup as normal


<a name="">Acknowledgements</a>
---------------------
Vm and google login taken with permission from a project made based on classes from udacity.


<a name="licensing">Copyright and Licensing</a>
---------------------

Code and documentation copyright 2016 Robert King, Jacky Liang, Troy Mullins, and Thomas Norby. Code released under [the MIT license](https://github.com/Mullinst/SER-FP/blob/master/LICENSE).


