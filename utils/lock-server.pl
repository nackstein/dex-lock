#!/usr/bin/perl

#work in progress

#use strict;
#use warnings;
use IO::Socket::INET;
 
# auto-flush on socket
$| = 1;
 
# creating a listening socket
my $socket = new IO::Socket::INET (
    LocalHost => '0.0.0.0',
    LocalPort => '7777',
    Proto => 'tcp',
    Listen => 5,
    Reuse => 1
);

die "cannot create socket $!\n" unless $socket;
print "server waiting for client connection on port 7777\n";
 
$SIG{PIPE} = "IGNORE";

while(1)
{
    # waiting for a new client connection
    my $client_socket = $socket->accept() or die "error in accept";
 
    # read up to 1024 characters from the connected client
    my $data = "";
    eval { $client_socket->recv($data, 1024) };

    my $cmd = "";

    if ($data =~ "^who" ) {
        $cmd="who";
    } elsif ( $data =~ "^cal" ) {
        $cmd="cal";
    } else {
        $cmd="true";
    }

    open DATA, "$cmd |" or die "Couldn't execute program: $!";
    while ( my $line = <DATA> ) {
        eval { $client_socket->send($line) } or last;
    }

    close DATA;

    # notify client that response has been sent
    eval { shutdown($client_socket, 1) };
}
 
$socket->close();
