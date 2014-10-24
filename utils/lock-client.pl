#!/usr/bin/perl

# work in progress

use strict;
use warnings;
use IO::Socket::INET;
 
# auto-flush on socket
$| = 1;
 
# creating a listening socket
my $socket = IO::Socket::INET->new (
    PeerHost => "0.0.0.0",
    PeerPort => "7777",
    Proto => 'tcp',
) or die "cannot create socket $!\n";
 
#my $client_socket = $socket->connect();
$socket->send($ARGV[0]);
 
# read up to 1024 characters from the connected client
my $data = "";
$socket->recv($data, 1024);
print "received data: $data\n";
# notify client that response has been sent
shutdown($socket, 1);
 
$socket->close();
