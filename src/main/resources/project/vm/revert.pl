##########################
# revert.pl
##########################
use warnings;
use strict;

my $opts;

$opts->{vboxmanage_location} = q{$[vboxmanage_location]};
$opts->{virtualbox_vmname} = q{$[virtualbox_vmname]};
$opts->{virtualbox_snapshot} = q{$[virtualbox_snapshot]};

$[/myProject/procedure_helpers/preamble]

$gt->revert();
exit($opts->{exitcode});