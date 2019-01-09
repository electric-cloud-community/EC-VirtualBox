##########################
# resume.pl
##########################
use warnings;
use strict;

my $opts;

$opts->{vboxmanage_location} = q{$[vboxmanage_location]};
$opts->{virtualbox_vmname} = q{$[virtualbox_vmname]};

$[/myProject/procedure_helpers/preamble]

$gt->resume();
exit($opts->{exitcode});