#!/usr/bin/perl

use strict;
use warnings;

use English qw(-no_match_vars);
use Test::Deep qw(cmp_deeply);
use Test::Exception;
use Test::More;

use FusionInventory::Agent::Tools;
use FusionInventory::Agent::Message::Inbound;

my %tests = (
    registry => {
        OPTION => [
            {
                NAME => 'REGISTRY',
                PARAM => [
                    {
                        NAME    => 'blablabla',
                        content => '*',
                        REGTREE => '0',
                        REGKEY  => 'SOFTWARE/Mozilla'
                    }
                 ]
            },
            {
                NAME => 'DOWNLOAD',
                PARAM => [
                    {
                         FRAG_LATENCY   => '10',
                         TIMEOUT        => '30',
                         PERIOD_LATENCY => '1',
                         ON             => '1',
                         TYPE           => 'CONF',
                         PERIOD_LENGTH  => '10',
                         CYCLE_LATENCY  => '6'
                    }
                ]
            }
        ],
        RESPONSE => 'SEND',
        PROLOG_FREQ => '1'
    },
    netinventory3 => {
        OPTION => [
            {
                AUTHENTICATION => [
                    {
                        ID             => '1',
                        AUTHPROTOCOL   => '',
                        PRIVPROTOCOL   => '',
                        USERNAME       => '',
                        AUTHPASSPHRASE => '',
                        VERSION        => '1',
                        COMMUNITY      => 'public',
                        PRIVPASSPHRASE => ''
                    },
                ],
                NAME => 'SNMPQUERY',
                MODEL => [
                    {
                    ID   => '196',
                    NAME => '4675719',
                    WALK => [
                        {
                            VLAN   => '0',
                            LINK   => 'ifIndex',
                            OBJECT => 'ifIndex',
                            OID    => '.1.3.6.1.2.1.2.2.1.1'
                        },
                        {
                            VLAN   => '0',
                            LINK   => 'ifName',
                            OBJECT => 'ifName',
                            OID    => '.1.3.6.1.2.1.2.2.1.2'
                        },
                        {
                            VLAN   => '0',
                            LINK   => 'ifType',
                            OBJECT => 'ifType',
                            OID    => '.1.3.6.1.2.1.2.2.1.3'
                        },
                        {
                            VLAN   => '0',
                            LINK   => 'ifPhysAddress',
                            OBJECT => 'ifPhysAddress',
                            OID    => '.1.3.6.1.2.1.2.2.1.6'
                        },
                        {
                            VLAN   => '0',
                            LINK   => 'ifaddr',
                            OBJECT => 'ifaddr',
                            OID    => '.1.3.6.1.2.1.4.20.1.2'
                        }
                    ],
                    GET => [
                        {
                            VLAN   => '0',
                            LINK   => 'comments',
                            OBJECT => 'comments',
                            OID    => '.1.3.6.1.2.1.1.1.0'
                        },
                        {
                            VLAN   => '0',
                            LINK   => 'name',
                            OBJECT => 'name',
                            OID    => '.1.3.6.1.2.1.1.5.0'
                        },
                        {
                            VLAN   => '0',
                            LINK   => 'location',
                            OBJECT => 'location',
                            OID    => '.1.3.6.1.2.1.1.6.0'
                        },
                        {
                            VLAN   => '0',
                            LINK   => 'informations',
                            OBJECT => 'informations',
                            OID    => '.1.3.6.1.4.1.11.2.3.9.1.1.7.0'
                        }
                    ]
                    }
                ],
                DEVICE => [
                    {
                        ID           => '72',
                        IP           => '192.168.0.151',
                        MODELSNMP_ID => '196',
                        TYPE         => 'PRINTER',
                        AUTHSNMP_ID  => '1'
                    }
                ],
                PARAM => [
                    {
                        PID           => '1280265498/024',
                        THREADS_QUERY => '4',
                        CORE_QUERY    => '1'
                    }
                ]
            }
        ],
        PROCESSNUMBER => '1280265498/024'
    },
    netdiscovery => {
        OPTION => [
            {
                AUTHENTICATION => [
                    {
                        ID             => '1',
                        AUTHPROTOCOL   => '',
                        PRIVPROTOCOL   => '',
                        USERNAME       => '',
                        AUTHPASSPHRASE => '',
                        VERSION        => '1',
                        COMMUNITY      => 'public',
                        PRIVPASSPHRASE => ''
                    },
                    {
                        ID             => '2',
                        AUTHPROTOCOL   => '',
                        PRIVPROTOCOL   => '',
                        USERNAME       => '',
                        AUTHPASSPHRASE => '',
                        VERSION        => '2c',
                        COMMUNITY      => 'public',
                        PRIVPASSPHRASE => ''
                    }
                ],
                RANGEIP => [
                    {
                        ID      => '1',
                        ENTITY  => '15',
                        IPSTART => '192.168.0.1',
                        IPEND   => '192.168.0.254'
                    },
                ],
                NAME => 'NETDISCOVERY',
                PARAM => [
                    {
                    CORE_DISCOVERY    => '1',
                    PID               => '1280265592/024',
                    THREADS_DISCOVERY => '10'
                    }
                ]
            }
        ],
        PROCESSNUMBER => '1280265592/024'
    },
    wakeonlan => {
        RESPONSE => 'SEND',
        OPTION => [
            {
                PARAM => [
                    {
                        MAC => '00:1e:c2:0c:36:27'
                    },
                    {
                        MAC => '00:1e:c2:a7:26:6f'
                    },
                    {
                        MAC => '00:1e:52:ff:fe:67'
                    },
                    {
                        MAC => '00:00:39:23:0c:e1'
                    },
                    {
                        MAC => '00:00:39:23:0c:e1'
                    },
                    {
                        MAC => 'f6:68:20:52:41:53'
                    },
                    {
                        MAC => '52:08:19:1f:b6:f6'
                    }
                ],
                NAME => 'WAKEONLAN'
            }
        ],
        PROLOG_FREQ => '24'
    },
);

plan tests => 2 * (scalar keys %tests);

foreach my $test (keys %tests) {
    my $file = "resources/messages/$test.xml";
    my $string = getAllLines(file => $file);
    my $message = FusionInventory::Agent::Message::Inbound->new(
        content => $string
    );

    my $content = $message->getContent();
    cmp_deeply($content, $tests{$test}, $test);

    subtest 'options' => sub {
        my $options = $content->{OPTION};
        plan tests => scalar @$options;
        foreach my $option (@$options) {
            cmp_deeply(
                $message->getOptionsInfoByName($option->{NAME}),
                $option,
                "$test option $option->{NAME}"
            );
        }
    };
}
