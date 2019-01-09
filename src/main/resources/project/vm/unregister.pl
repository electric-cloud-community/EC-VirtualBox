##########################
# unregister.pl
##########################
use warnings;
use strict;

my $opts;

$opts->{vboxmanage_location} = q{$[vboxmanage_location]};
$opts->{virtualbox_vmname} = q{$[virtualbox_vmname]};
$opts->{virtualbox_delete_files} = q{$[virtualbox_delete_files]};

$[/myProject/procedure_helpers/preamble]

$gt->unregister();
exit($opts->{exitcode});