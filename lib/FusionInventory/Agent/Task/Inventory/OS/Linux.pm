package FusionInventory::Agent::Task::Inventory::OS::Linux;

use strict;
use warnings;

use English qw(-no_match_vars);
use XML::TreePP;


use FusionInventory::Agent::Tools;

our $runAfter = ["FusionInventory::Agent::Task::Inventory::OS::Generic"];

sub isInventoryEnabled {
    return $OSNAME eq 'linux';
}

sub doInventory {
    my (%params) = @_;

    my $inventory = $params{inventory};

    my $osversion = getFirstLine(command => 'uname -r');
    my $oscomment = getFirstLine(command => 'uname -v');

    $inventory->setHardware({
        OSNAME     => "Linux",
        OSVERSION  => $osversion,
        OSCOMMENTS => $oscomment,
        WINPRODID => _getRHNSystemId('/etc/sysconfig/rhn/systemid')
    });

}

# Get RedHat Network SystemId
sub _getRHNSystemId {
    my ($file) = @_;

    return unless -f $file;
    my $tpp = XML::TreePP->new();
    my $h = $tpp->parsefile($file);
    use Data::Dumper;
    my $v;
    eval {
        foreach (@{$h->{params}{param}{value}{struct}{member}}) {
            next unless $_->{name} eq 'system_id';
            return $_->{value}{string};
        }
    }
}

1;
