my $category = "Resource Management";
my %PowerOn = (
    label       => "VirtualBox - PowerOn",
    procedure   => "PowerOn",
    description => "Power on a virtual machine",
    category    => $category
);

my %PowerOff = (
    label       => "VirtualBox - PowerOff",
    procedure   => "PowerOff",
    description => "Power off a virtual machine",
    category    => $category
);

my %Pause = (
    label       => "VirtualBox - Pause",
    procedure   => "Pause",
    description => "Pause a virtual machine",
    category    => $category
);

my %Resume = (
    label       => "VirtualBox - Resume",
    procedure   => "Resume",
    description => "Resume a virtual machine",
    category    => $category
);

my %Snapshot = (
    label       => "VirtualBox - Create Snapshot",
    procedure   => "Snapshot",
    description => "Create a snapshot from a virtual machine",
    category    => $category
);

my %Revert = (
    label       => "VirtualBox - Revert To Snapshot",
    procedure   => "Revert",
    description => "Revert a virtual machine to a snapshot",
    category    => $category
);

my %Register = (
    label       => "VirtualBox - Register",
    procedure   => "Register",
    description => "Register a virtual machine into VB system",
    category    => $category
);

my %Unregister = (
    label       => "VirtualBox - Unregister",
    procedure   => "Unregister",
    description => "Unregister a virtual machine from VB system",
    category    => $category
);

$batch->deleteProperty("/server/ec_customEditors/pickerStep/VirtualBox - PowerOn");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/VirtualBox - PowerOff");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/VirtualBox - Pause");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/VirtualBox - Resume");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/VirtualBox - Create Snapshot");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/VirtualBox - Revert To Snapshot");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/VirtualBox - Register");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/VirtualBox - Unregister");

@::createStepPickerSteps = (\%PowerOn, \%PowerOff, \%Pause, \%Resume,\%Snapshot,\%Revert,\%Register,\%Unregister);
