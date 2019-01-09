##########################
# snapshot.pl
##########################
use warnings;
use strict;

my $opts;

$opts->{vboxmanage_location} = q{$[vboxmanage_location]};
$opts->{virtualbox_vmname} = q{$[virtualbox_vmname]};
$opts->{virtualbox_snapshot} = q{$[virtualbox_snapshot]};
$opts->{virtualbox_description} = q{$[virtualbox_description]};

$[/myProject/procedure_helpers/preamble]

$gt->snapshot();
exit($opts->{exitcode});