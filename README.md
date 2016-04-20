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
	* `\i filername.sql` to create filername database.
	* `\q` to exit database.
	* `python project.py` to run project.
	* Open browser to `https://localhost:8000`

How to Close Project
--------------------
	1. `control c` to interupt python. 
	2. `exit` to ssh.
	3. `vagrant down` to shutdown virtual machine. 
	
Useful Documentation
---------------------
[Python 2.7](https://www.python.org/download/releases/2.7/)
[PEP 8](https://www.python.org/dev/peps/pep-0008/)
[Flask](http://flask.pocoo.org/docs/0.10/quickstart/)
[jinja2](http://jinja.pocoo.org/docs/dev/)
[Bootstrap](http://getbootstrap.com/)
[MDN](https://developer.mozilla.org/en-US/)

Basic git commands
--------------------
	* `git clone https://github.com/Mullinst/SER-FP.git` to clone this repository.
	* `git pull` to pull recent commits.
	* `git add <filename>` to add file to commit.
	* `git commit -m 'commit message'` to commit changes to local repository.
	* `git push` to push local commits to github.

Commit Message Format
---------------------
	* `docs:` for documentation.
	* `feat:` for new feature.
	* `fix:` for bug fixes.
	* `refactor:` for refactoring.
	* `style:` for style changes.

Copyright and license
---------------------
Code and documentation copyright 2016 Troy Mullins. Code released under [the MIT license](https://github.com/Mullinst/SER-FP/blob/master/LICENSE).