##########################
# poweroff.pl
##########################
use warnings;
use strict;

my $opts;

$opts->{vboxmanage_location} = q{$[vboxmanage_location]};
$opts->{virtualbox_vmname} = q{$[virtualbox_vmname]};
$opts->{virtualbox_delete_resource} = q{$[virtualbox_delete_resource]};

$[/myProject/procedure_helpers/preamble]

$gt->poweroff();
exit($opts->{exitcode});