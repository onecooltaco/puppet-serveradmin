Puppet serveradmin
=================

Provides Management of services on OS X server for Puppet with the serveradmin command.

History
-------
2012-08-16 : jleggat

  * added README

Usage
-----
This module provides a resource types and provider for managing OS X Server configuration:
`serveradmin`

Here's a simple working example:

	serveradmin {
		"afp:guestAccess": settings => "no",
	}

	serveradmin {
		"smb:preferred master": settings => "no",
	}

	serveradmin {
		"ipfilter:standardServices:_array_id:Puppet Master":
			ensure => insync,
			settings => { name => "\"\"", protocol => "\"tcp\"", readOnly => "yes", dest-port => "\"8140\"", },
			notify => Service[ipfilter],
	}

=======
for serveradmin arrays I use a hash for the keys and values.

for more complex configurations, use defined types to build the hash.

Limitations
-----------

### Quoting Strings

Serveradmin puts out strings with quotes so be sure to include excepted quotes as part of strings.


Contributors
=======
Jeremy Leggat <jleggat@asu.edu>
