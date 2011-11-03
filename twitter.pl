# A very simple irssi plugin to post a given channel's topic to twitter.
# This script was written by Ari Pollak <ari at debian.org>.
# I hereby place it into the public domain.
#
use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
use Net::Twitter;

$VERSION = '1.00';
%IRSSI = (
    authors     => 'Ari Pollak',
    name        => 'twitter',
    description => "Updates a twitter status when a topic changes",
    license     => 'Public Domain'
);

my $monitor_channel = "#test";
my $monitor_network = "oftc";
my $username = 'user@example.com';
my $password = 'password';

my $twit = Net::Twitter->new(username=>$username, password=>$password);

sub update {
	my ($channame, $chantopic) = @_;

	$twit->update($chantopic);
}

sub new_topic {
	my ($channel) = @_;
	return unless $channel->{name} eq $monitor_channel;
	return unless $channel->{server}->{tag} eq $monitor_network;

	update($channel->{name}, $channel->{topic});
}

my @channels = Irssi::channels () ;

foreach my $channel (@channels) {
	if($channel->{name} eq $monitor_channel) {
		new_topic($channel);
	}
}

# Topic has changed
Irssi::signal_add 'channel topic changed' => \&new_topic;

# We've joined a new channel
Irssi::signal_add 'channel joined' => \&new_topic;
