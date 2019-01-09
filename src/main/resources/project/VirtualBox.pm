# -------------------------------------------------------------------------
# Package
#    VirtualBox.pm
#
# Dependencies
#    VMware::VIRuntime
#    ElectricCommander.pm
#
# Purpose
#     A perl library that encapsulates the logic to manipulate virtual machines on VirtualBox using VBoxManage
#
# Template Version
#    1.0
#
# Date
#    03/04/2011
#
# Engineer
#    Jose Picado
#
# Copyright (c) 2011 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------

package VirtualBox;

# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use warnings;
use strict;
use ElectricCommander;
use ElectricCommander::PropDB;

# -------------------------------------------------------------------------
# Constants
# -------------------------------------------------------------------------
use constant {
	SUCCESS => 0,
	ERROR   => 1,
	
	TRUE  => 1,
	FALSE => 0,
	
	ALIVE => 1,
	NOT_ALIVE => 0,
	
	DEFAULT_VBOXMANAGE   => 'VBoxManage',
    DEFAULT_DEBUG        => 1,
    DEFAULT_PING_TIMEOUT => 300,
    DEFAULT_PROPERTIES_LOCATION => '/myCall',
    
    RUNNING_STATE => 'running',
};

################################
# new - Object constructor for ESX
#
# Arguments:
#   opts hash
#
# Returns:
#   none
#
################################
sub new {
	my ( $class, $cmdr, $opts ) = @_;
	my $self = { 
		_cmdr => $cmdr,
		_opts => $opts, 
	};
	bless $self, $class;
}

###############################
# myCmdr - Get ElectricCommander instance
#
# Arguments:
#   none
#
# Returns:
#   ElectricCommander instance
#
################################
sub myCmdr {
    my ($self) = @_;
    return $self->{_cmdr};
}

###############################
# myProp - Get PropDB
#
# Arguments:
#   none
#
# Returns:
#   PropDB
#
################################
sub myProp {
    my ($self) = @_;
    return $self->{_props};
}

###############################
# setProp - Use stored property prefix and PropDB to set a property
#
# Arguments:
#   location - relative location to set the property
#   value    - value of the property
#
# Returns:
#   setResult - result returned by PropDB->setProp
#
################################
sub setProp {
    my ($self, $location, $value) = @_;
    my $setResult = $self->myProp->setProp($self->opts->{virtualbox_properties} . $location, $value);
    return $setResult;
}

################################
# opts - Get opts hash
#
# Arguments:
#   none
#
# Returns:
#   opts hash
#
################################
sub opts {
	my ($self) = @_;
	return $self->{_opts};
}

################################
# ecode - Get exit code
#
# Arguments:
#   none
#
# Returns:
#   exit code number
#
################################
sub ecode {
	my ($self) = @_;
	return $self->opts()->{exitcode};
}

################################
# initialize - Set initial values
#
# Arguments:
#   none
#
# Returns:
#   none
#
################################
sub initialize {
	my ($self) = @_;
	
	# Set defaults 
	$self->opts->{Debug} = DEFAULT_DEBUG;
	$self->opts->{exitcode} = SUCCESS;
	$self->opts->{virtualbox_properties} = DEFAULT_PROPERTIES_LOCATION;
	
	if(defined($self->opts->{vboxmanage_location}) && $self->opts->{vboxmanage_location} eq "") {
		$self->opts->{vboxmanage_location} = DEFAULT_VBOXMANAGE;
	}
}

################################
# poweron - Call VBoxManage to poweron a virtual machine
#
# Arguments:
#   none
#
# Returns:
#   none
#
################################
sub poweron {
	my ($self) = @_;
	
	# Initialize 
	$self->initialize();
	my $location = $self->opts->{vboxmanage_location};
    my $vmname   = $self->opts->{virtualbox_vmname};
    # Create command
	my $command = qq{"$location" --nologo startvm "$vmname"};
    
	# Test mode
    if ($::gRunTest) {
		return $command;
	}
    
    # Execute command
    $self->debugMsg(1, 'Powering on virtual machine \''.$self->opts->{virtualbox_vmname}.'\'...');
    my $result = system($command);
    
    # If an error occured
    if ($result) {
    	$self->opts->{exitcode} = $result;
        return;
    }
    
    # Create resource
    if (defined($self->opts->{virtualbox_create_resource}) && $self->opts->{virtualbox_create_resource}) {
    	# Wait virtual machine to be powered on
    	while (TRUE) {
    		$command = 'VBoxManage --nologo showvminfo "'.$self->opts->{virtualbox_vmname}.'"';
			my $out = `$command`;
			$out =~ /State:           ([\w]+)/;
			if ($1 eq RUNNING_STATE) {
				last;
			}
			sleep 1;
    	}
    	
    	# Get IP address from virtual machine and create resource
    	$command = 'VBoxManage guestproperty enumerate "'.$self->opts->{virtualbox_vmname}.'" | grep "V4/IP" | cut -d"," -f2 | cut -d":" -f2 | tr -d " "';
    	$self->opts->{virtualbox_ip} = `$command`;
    	$self->opts->{virtualbox_ip} = $self->trim($self->opts->{virtualbox_ip});
    	
    	if ($self->opts->{virtualbox_ip} ne '') {
    		$self->create_resource;
    		if ($self->ecode) { return; }
    	} else {
    		$self->debugMsg(1, "Unable to create a Commander resource for virtual machine '$self->opts->{virtualbox_vmname}'");
    		$self->opts->{exitcode} =  ERROR;
            return;
    	}
    }
}

################################
# poweroff - Call VBoxManage to poweroff a virtual machine
#
# Arguments:
#   none
#
# Returns:
#   none
#
################################
sub poweroff {
	my ($self) = @_;
	
	# Initialize 
	$self->initialize();
	
    # Create command
	my $command = '"' . $self->opts->{vboxmanage_location} . '" --nologo controlvm "' . $self->opts->{virtualbox_vmname} . '" poweroff';
	
	# Test mode
    if ($::gRunTest) {
		return $command;
	}
    
    # Execute command
    $self->debugMsg(1, 'Powering off virtual machine \''.$self->opts->{virtualbox_vmname}.'\'...');
    my $result = system($command);
    
    # If an error occured
    if ($result) {
    	$self->opts->{exitcode} = $result;
        return;
    }
    $self->debugMsg(1, 'Virtual machine \''.$self->opts->{virtualbox_vmname}.'\' successfully powered off.');
    
    # Delete resource
    if (defined($self->opts->{virtualbox_delete_resource}) && $self->opts->{virtualbox_delete_resource}) {
    	$self->delete_resource;
    	if ($self->ecode) { return; }
    }
}

################################
# pause - Call VBoxManage to pause a virtual machine
#
# Arguments:
#   none
#
# Returns:
#   none
#
################################
sub pause {
	my ($self) = @_;
	
	# Initialize 
	$self->initialize();
	
    # Create command	
	my $command = '"' . $self->opts->{vboxmanage_location} . '" --nologo controlvm "' . $self->opts->{virtualbox_vmname} . '" pause';
	
	# Test mode
    if ($::gRunTest) {
		return $command;
	}
    
    # Execute command
    $self->debugMsg(1, 'Pausing virtual machine \''.$self->opts->{virtualbox_vmname}.'\'...');
    my $result = system($command);
    
    # If an error occured
    if ($result) {
    	$self->opts->{exitcode} = $result;
        return;
    }
    $self->debugMsg(1, 'Virtual machine \''.$self->opts->{virtualbox_vmname}.'\' successfully paused.');
}

################################
# resume - Call VBoxManage to resume a virtual machine
#
# Arguments:
#   none
#
# Returns:
#   none
#
################################
sub resume {
	my ($self) = @_;
	
	# Initialize 
	$self->initialize();
	
    # Create command
	my $command = '"' . $self->opts->{vboxmanage_location} . '" --nologo controlvm "' . $self->opts->{virtualbox_vmname} . '" resume';
	
	# Test mode
    if ($::gRunTest) {
		return $command;
	}
    
    # Execute command
    $self->debugMsg(1, 'Resuming virtual machine \''.$self->opts->{virtualbox_vmname}.'\'...');
    my $result = system($command);
    
    # If an error occured
    if ($result) {
    	$self->opts->{exitcode} = $result;
        return;
    }
    $self->debugMsg(1, 'Virtual machine \''.$self->opts->{virtualbox_vmname}.'\' successfully resumed.');
}

################################
# register - Call VBoxManage to register a virtual machine into VB system
#
# Arguments:
#   none
#
# Returns:
#   none
#
################################
sub register {
	my ($self) = @_;
	
	# Initialize 
	$self->initialize();
	
    # Create command
	my $command = '"' . $self->opts->{vboxmanage_location} . '" --nologo registervm "' . $self->opts->{virtualbox_vmdefinition} . '"';
	
	# Test mode
    if ($::gRunTest) {
		return $command;
	}
    
    # Execute command
    $self->debugMsg(1, 'Registering virtual machine from file \''.$self->opts->{virtualbox_vmdefinition}.'\'...');
    my $result = system($command);
    
    # If an error occured
    if ($result) {
    	$self->opts->{exitcode} = $result;
        return;
    }
    $self->debugMsg(1, 'Virtual machine successfully registered.');
}

################################
# unregister - Call VBoxManage to unregister a virtual machine from VB system
#
# Arguments:
#   none
#
# Returns:
#   none
#
################################
sub unregister {
	my ($self) = @_;
	
	# Initialize 
	$self->initialize();
	
    # Create command
	my $command = '"' . $self->opts->{vboxmanage_location} . '" --nologo unregistervm "' . $self->opts->{virtualbox_vmname}.'"';
	if (defined($self->opts->{virtualbox_delete_files}) && $self->opts->{virtualbox_delete_files}) {
		$command .= ' --delete';
	}
	
	# Test mode
    if ($::gRunTest) {
		return $command;
	}
    
    # Execute command
    $self->debugMsg(1, 'Unregistering virtual machine \''.$self->opts->{virtualbox_vmname}.'\'...');
    my $result = system($command);
    
    # If an error occured
    if ($result) {
    	$self->opts->{exitcode} = $result;
        return;
    }
    $self->debugMsg(1, 'Virtual machine successfully unregistered.');
}

################################
# snapshot - Call VBoxManage to create a snapshot of a virtual machine
#
# Arguments:
#   none
#
# Returns:
#   none
#
################################
sub snapshot {
	my ($self) = @_;
	
	# Initialize 
	$self->initialize();
	
    # Create command
	my $command = '"' . $self->opts->{vboxmanage_location} . '" --nologo snapshot "' . $self->opts->{virtualbox_vmname} . '" take "' . $self->opts->{virtualbox_snapshot}.'"';
	if (defined($self->opts->{virtualbox_description}) && $self->opts->{virtualbox_description} ne '') {
		$command .= ' --description "' . $self->opts->{virtualbox_description}.'"'; 
	}
	
	# Test mode
    if ($::gRunTest) {
		return $command;
	}
    
    # Execute command
    $self->debugMsg(1, 'Creating snapshot \''.$self->opts->{virtualbox_snapshot}.'\' for virtual machine \''.$self->opts->{virtualbox_vmname}.'\'...');
    my $result = system($command);
    
    # If an error occured
    if ($result) {
    	$self->opts->{exitcode} = $result;
        return;
    }
    $self->debugMsg(1, 'Successfully created snapshot \''.$self->opts->{virtualbox_snapshot}.'\' of virtual machine \''.$self->opts->{virtualbox_vmname}.'\'.');
}

################################
# revert - Call VBoxManage to revert a virtual machine to a snapshot
#
# Arguments:
#   none
#
# Returns:
#   none
#
################################
sub revert {
	my ($self) = @_;
	
	# Initialize 
	$self->initialize();
	
    # Create command
	my $command = '"' . $self->opts->{vboxmanage_location} . '" --nologo snapshot "' . $self->opts->{virtualbox_vmname} . '" restore "' . $self->opts->{virtualbox_snapshot}.'"';
	
	# Test mode
    if ($::gRunTest) {
		return $command;
	}
    
    # Execute command
    $self->debugMsg(1, 'Reverting virtual machine \''.$self->opts->{virtualbox_vmname}.'\' to snapshot \''.$self->opts->{virtualbox_snapshot}.'\'...');
    my $result = system($command);
    
    # If an error occured
    if ($result) {
    	$self->opts->{exitcode} = $result;
        return;
    }
    $self->debugMsg(1, 'Virtual machine \''.$self->opts->{virtualbox_vmname}.'\' successfully reverted to snapshot \''.$self->opts->{virtualbox_snapshot}.'\'.');
}

################################
# create_resource - Create a Commander resource with the paremeters contained in $opts
#
# Arguments:
#   none
#
# Returns:
#   none
#
################################
sub create_resource {
	my ($self) = @_;
	
	$self->debugMsg(1, 'Creating resource for virtual machine \''.$self->opts->{virtualbox_vmname}.'\'...');
    my $cmdrresult = $self->myCmdr()->createResource(
        $self->opts->{virtualbox_vmname},
        {description => 'VirtualBox created resource',
         workspaceName => $self->opts->{virtualbox_workspace},
         hostName => $self->opts->{virtualbox_ip},
         pools => $self->opts->{virtualbox_pools} } );

    # Check for error return
    my $errMsg = $self->myCmdr()->checkAllErrors($cmdrresult);
    if ($errMsg ne "") {
        $self->debugMsg(1, "Error: $errMsg");
        $self->opts->{exitcode} =  ERROR;
        return;
    }
    
    $self->debugMsg(1, 'Resource created');
    
    # Test connection to virtual machine
    my $resStarted = 0;
    my $try  = DEFAULT_PING_TIMEOUT;
    while ($try > 0) {
        $self->debugMsg(1, "Waiting for ping response #($try) of resource " . $self->opts->{virtualbox_vmname});
        my $pingresult = $self->pingResource($self->opts->{virtualbox_vmname});
        if ($pingresult == 1) {
            $resStarted = 1;
            last;
        }
        sleep(1);
        $try -= 1;
    }
    if ($resStarted == 0) {
        $self->debugMsg(1, 'Unable to ping virtual machine');
        $self->opts->{exitcode} =  ERROR;
    } else {
        $self->debugMsg(1, 'Ping response succesfully received');
    }
}

################################
# delete_resource - Delete the specified Commander resource 
#
# Arguments:
#   none
#
# Returns:
#   none
#
################################
sub delete_resource {
	my ($self) = @_;
	
	$self->debugMsg(1, 'Deleting resource ' . $self->opts->{virtualbox_vmname} .' (if existing)...');
	my $cmdrresult = $self->myCmdr()->deleteResource($self->opts->{virtualbox_vmname});
	
	# Check for error return
	my $errMsg = $self->myCmdr()->checkAllErrors($cmdrresult);
	if ($errMsg ne "") {
		$self->debugMsg(1, "Error: $errMsg");
		$self->opts->{exitcode} = ERROR;
		return;
	}
	$self->debugMsg(1, 'Resource deleted');
}

# -------------------------------------------------------------------------
# Helper functions
# -------------------------------------------------------------------------

###############################
# pingResource - Use commander to ping a resource
#
# Arguments:
#   resource - string
#
# Returns:
#   1 if alive, 0 otherwise
#
################################
sub pingResource {
    my ($self, $resource) = @_;

    my $alive = "0";
    my $result = $self->myCmdr()->pingResource($resource);
    if (!$result) { return NOT_ALIVE; }
    $alive = $result->findvalue('//alive');
    if ($alive eq "1") { return ALIVE;}
    return NOT_ALIVE;
}

###############################
# trim - deletes blank spaces before and after the entered value in 
# the argument
#
# Arguments:
#   untrimmedString: string that will be trimmed
#
# Returns:
#   trimmed string
#
###############################
sub trim($) {
	my ($self, $untrimmedString) = @_;
    my $string = $untrimmedString;
    $string =~ s/^\s+//;  
    $string =~ s/\s+$//; 
    return $string;
}

###############################
# debugMsg - Print a debug message
#
# Arguments:
#   errorlevel - number compared to $self->opts->{Debug}
#   msg        - string message
#
# Returns:
#   none
#
################################
sub debugMsg {
	my ( $self, $errlev, $msg ) = @_;
	if ( $self->opts->{Debug} >= $errlev ) { print "$msg\n"; }
}
