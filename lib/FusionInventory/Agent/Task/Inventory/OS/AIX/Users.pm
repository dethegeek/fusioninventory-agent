package FusionInventory::Agent::Task::Inventory::OS::AIX::Users;

use strict;
use warnings;

use FusionInventory::Agent::Tools;

sub isInventoryEnabled {
# Useless check for a posix system i guess
    my @who = `who 2>/dev/null`;
    return 1 if @who;
    return;
}

# Initialise the distro entry
sub doInventory {
    my $params = shift;
    my $inventory = $params->{inventory};

    my %user;
    # Logged on users
    for(`who`){
        $inventory->addUser($1) if /^(\S+)./;
    }

}

1;
