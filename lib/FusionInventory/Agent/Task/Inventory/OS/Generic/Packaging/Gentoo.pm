package FusionInventory::Agent::Task::Inventory::OS::Generic::Packaging::Gentoo;

use strict;
use warnings;

use FusionInventory::Agent::Tools;

sub isInventoryEnabled {
    return can_run("equery");
}

sub doInventory {
    my $params = shift;
    my $inventory = $params->{inventory};

# TODO: This had been rewrite from the Linux agent _WITHOUT_ being checked!
    foreach (`equery list -i`){
        if (/^(.*)-([0-9]+.*)/) {
            $inventory->addSoftware({
                'NAME'          => $1,
                'VERSION'       => $2,
            });
        }
    }
}

1;
