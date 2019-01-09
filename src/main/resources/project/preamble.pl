use ElectricCommander;
use File::Basename;
use ElectricCommander::PropDB;
use ElectricCommander::PropMod;

$|=1;

use constant {
	SUCCESS => 0,
	ERROR   => 1,
};

# Create ElectricCommander instance
my $ec = new ElectricCommander();
$ec->abortOnError(0);

# Load the actual code into this process
if (!ElectricCommander::PropMod::loadPerlCodeFromProperty(
    $ec,'/myProject/virtualbox_driver/VirtualBox') ) {
    print "Could not load VirtualBox.pm\n";
    exit ERROR;
}

# Make an instance of the object, passing in options as a hash
my $gt = new VirtualBox($ec, $opts);
