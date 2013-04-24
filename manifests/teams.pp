# == Class: serveradmin::teams
#
# Full description of class serveradmin::teams here.
#
# === Parameters
#
# Document parameters here.
#
# [*parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more entries as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter variable must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  include 'serveradmin::teams'
#
# === Authors
#
# Jeremy Leggat <jleggat@asu.edu>
#
# === Copyright
#
# Copyright 2012 Jeremy Leggat, unless otherwise noted.
#
class serveradmin::teams {
	serveradmin {
		"teams:calendar:enabled": settings => "no",
	}
	serveradmin {
		"teams:wiki:enabled": settings => "no",
	}
	serveradmin {
		"teams:directoryEnabled": settings => "no",
	}
	serveradmin {
		"teams:groupsEnabled": settings => "no",
	}
	serveradmin {
		"teams:usersEnabled": settings => "no",
	}
	serveradmin {
		"teams:weblog:enabled": settings => "no",
	}
}
