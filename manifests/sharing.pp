# == Define: serveradmin::sharing
#
# Full description of defined resource type example_resource here.
#
# === Parameters
#
# Document parameters here
#
# [*namevar*]
#   If there is a parameter that defaults to the value of the title string
#   when not explicitly set, you must always say so.  This parameter can be
#   referred to as a "namevar," since it's functionally equivalent to the
#   namevar of a core resource type.
#
# [*path*]
#   Description of this variable.  For example, "This parameter sets the
#   base directory for this resource type.  It should not contain a trailing
#   slash."
#
# === Examples
#
# Provide some examples on how to use this type:
#
#   serveradmin::sharing { 'namevar':
#     path => '/tmp/src',
#   }
#
# === Authors
#
# Jeremy Leggat <jleggat@asu.edu>
#
# === Copyright
#
# Copyright 2012 Jeremy Leggat, unless otherwise noted.
#
define serveradmin::sharing (
    $ensure = 'present',
    $path,
    $afpIsGuestAccessEnabled = "no",
    $smbDirectoryMask = "755",
    $ftpIsShared = 'no',
    $afpUseParentOwner = 'yes',
    $ftpIsGuestAccessEnabled = "no",
	$smbCreateMask = "0644",
	$smbUseStrictLocking = "yes",
	$smbIsGuestAccessEnabled = "no",
	$smbInheritPermissions = "yes",
	$smbIsShared = "yes",
	$afpIsShared = "yes",
	$afpUseParentPrivs = "yes",
	$smbUseOplocks = "yes",
	$mountedOnPath = '/',
	$isIndexingEnabled = "no"
) {

    $real_name = "sharing:sharePointList:_array_id:${path}"

	$myhash = { smbName => "\"${name}\"", afpIsGuestAccessEnabled => "${afpIsGuestAccessEnabled}", smbDirectoryMask => "\"${smbDirectoryMask}\"", ftpIsShared => "${ftpIsShared}", afpName => "\"${name}\"", afpUseParentOwner => "${afpUseParentOwner}", ftpIsGuestAccessEnabled => "${ftpIsGuestAccessEnabled}", smbCreateMask => "\"${smbCreateMask}\"", path => "\"${path}\"", smbUseStrictLocking => "${smbUseStrictLocking}", smbIsGuestAccessEnabled => "${smbIsGuestAccessEnabled}", name => "\"${name}\"", smbInheritPermissions => "${smbInheritPermissions}", ftpName => "\"${name}\"", smbIsShared => "${smbIsShared}", afpIsShared => "${afpIsShared}", afpUseParentPrivs => "${afpUseParentPrivs}", smbUseOplocks => "${smbUseOplocks}", mountedOnPath => "\"${mountedOnPath}\"", isIndexingEnabled => "${isIndexingEnabled}", }

	serveradmin {
		"${real_name}":
			ensure => $ensure,
			settings => $myhash,
	}

}
# Define: serveradmin::sharing::group
#
# This module manages sharing settings via serveradmin on OS X server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
define serveradmin::sharing::group (
	$owner = "jrnadmin",
	$group,
	$mode = "770",
    $path = "/JRNFSData/${name}",
    $smbDirectoryMask = "770",
    $afpUseParentOwner = 'yes',
	$smbCreateMask = "0660",
	$afpUseParentPrivs = "yes",
	$smbUseOplocks = "yes",
	$smbUseStrictLocking = "yes",
	$smbInheritPermissions = "yes"
) {
	serveradmin::sharing {
		$name:
			smbDirectoryMask => $smbDirectoryMask,
			afpUseParentOwner => $afpUseParentOwner,
			smbCreateMask => $smbCreateMask,
			path => $path,
			smbUseOplocks => $smbUseOplocks,
			smbUseStrictLocking => $smbUseStrictLocking,
			smbInheritPermissions => $smbInheritPermissions,
			afpUseParentPrivs => $afpUseParentPrivs;
	}
	file {
	$path:
		path => $path,
		ensure => directory,
		recurselimit => 1,
		recurse => true,
		mode => $mode,
		owner => $owner,
		group => $group,
	}
}
# Define: serveradmin::sharing::class
#
# This module manages sharing settings via serveradmin on OS X server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
define serveradmin::sharing::class (
	$owner,
	$group,
    $path = "/Volumes/FSDATA/Classrooms/${name}",
    $smbDirectoryMask = "750",
    $afpUseParentOwner = 'yes',
	$smbCreateMask = "0640",
	$afpIsShared = "yes",
	$smbIsShared = "no",
	$afpUseParentPrivs = "yes",
	$smbUseOplocks = "yes",
	$smbUseStrictLocking = "yes",
	$smbInheritPermissions = "yes",
	$mountedOnPath = "/Volumes/FSDATA"
) {
	serveradmin::sharing {
		$name:
			smbDirectoryMask => $smbDirectoryMask,
			afpUseParentOwner => $afpUseParentOwner,
			smbCreateMask => $smbCreateMask,
			path => $path,
			smbUseOplocks => $smbUseOplocks,
			smbUseStrictLocking => $smbUseStrictLocking,
			smbInheritPermissions => $smbInheritPermissions,
			afpIsShared => $afpIsShared,
			smbIsShared => $smbIsShared,
			afpUseParentPrivs => $afpUseParentPrivs,
			mountedOnPath => $mountedOnPath;
	}

		file {
		$path:
			path => $path,
			ensure => directory,
			mode => 0750,
			owner => $owner,
			group => $group,
		}
		file {
		"${path}/Materials":
			path => "${path}/Materials",
			ensure => directory,
			mode => 0750, owner => $owner, group => $group;
		}
		file {
		"${path}/DropBox":
			path => "${path}/DropBox",
			ensure => directory,
			mode => 0730, owner => $owner, group => $group;
		}
		file {
		"${path}/Shared":
			path => "${path}/Shared",
			ensure => directory,
			mode => 0770, owner => $owner, group => $group;
		}

}
