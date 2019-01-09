##########################
# poweron.pl
##########################
use warnings;
use strict;

my $opts;

$opts->{vboxmanage_location} = q{$[vboxmanage_location]};
$opts->{virtualbox_vmname} = q{$[virtualbox_vmname]};
$opts->{virtualbox_create_resource} = q{$[virtualbox_create_resource]};
$opts->{virtualbox_workspace} = q{$[virtualbox_workspace]};
$opts->{virtualbox_pools} = q{$[virtualbox_pools]};

$[/myProject/procedure_helpers/preamble]

$gt->poweron();
exit($opts->{exitcode});