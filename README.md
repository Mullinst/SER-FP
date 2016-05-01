SER Final Project - Group 18
Thomas Norby, Troy Mullins, Robert King, Jacky Liang
==============================================


Table of Contents
-----------------------------------

Introduction
Contribution
Required Libraries and Dependencies
Installation
Terminating executables 
Useful Documentation
Useful Git commands
Commit Message Syntax
Troubleshooting
Copyright and license


Introduction
-----------------------------------

This program represents a scheduling application for a consulting company. Users can log in and select shift information to display current, available and owned shifts.


Contribution
-----------------------------------

<Team Member 1 Thomas Norby>: <Contribution>
<Team Member 2 Troy Mullins>: <Contribution>
<Team Member 3 Robert King>: <Contribution>
<Team Member 4 Jacky Liang>: <Contribution>


Required Libraries and Dependencies
-----------------------------------

1. [Git](http://git-scm.com/downloads)
2. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
3. [Vagrant](https://www.vagrantup.com)


Installation
------------------

To install and access the database use the following steps:
1. Download project repository.
2. In terminal (or equivalent command line application), navigate to the repository directory.
3. Navigate to the vagrant directory.
4. Execute the following commands in order:
	* `vagrant up` (powers on the virtual machine)
	* `vagrant ssh` (logs into the virtual machine)
	* `cd /vagrant` to change directory to the synced folders.
	* `cd src/` to change directory to src.
	* `psql` to access postgresql.
	* `\i filername.sql` to create filername database.
	* `\q` to exit database.
	* `python project.py` to run project.
	* Open browser to `http://localhost:8000`

You should now be able to access the database and select and view queries.

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


Copyright and license
---------------------

Code and documentation copyright 2016 Robert King, Jacky Liang, Troy Mullins, and Thomas Norby. Code released under [the MIT license](https://github.com/Mullinst/SER-FP/blob/master/LICENSE).
