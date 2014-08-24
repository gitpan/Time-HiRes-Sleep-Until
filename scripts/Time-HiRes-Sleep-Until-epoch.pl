#!/usr/bin/perl
use strict;
use warnings;
use Time::HiRes qw{time};
use DateTime;
use Time::HiRes::Sleep::Until;

my $start=DateTime->now;
printf "%s (%s): Start\n", $start, time;

my $later=$start->clone->add(minutes=>1)->truncate(to=>"minute");
my $su=Time::HiRes::Sleep::Until->new;
$su->epoch($later->epoch);

printf "%s (%s): Finish\n", DateTime->now, time;

__END__

=head1 NAME

Time-HiRes-Sleep-Until-example.pl - Time::HiRes::Sleep::Until example at 20 second mark

=cut
