package FusionInventory::Agent::Task::Inventory::OS::Generic::Packaging;

use strict;
use warnings;

use FusionInventory::Agent::Tools;

sub isInventoryEnabled {
    my $params = shift;

    # Do not run an package inventory if there is the --nosoft parameter
    return if ($params->{config}->{'no-software'});

    1;
}

1;
