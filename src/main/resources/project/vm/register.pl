##########################
# register.pl
##########################
use warnings;
use strict;

my $opts;

$opts->{vboxmanage_location} = q{$[vboxmanage_location]};
$opts->{virtualbox_vmdefinition} = q{$[virtualbox_vmdefinition]};

$[/myProject/procedure_helpers/preamble]

$gt->register();
exit($opts->{exitcode});