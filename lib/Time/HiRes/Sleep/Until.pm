package Time::HiRes::Sleep::Until;
use strict;
use warnings;
use base qw{Package::New};
use Time::HiRes qw{sleep time};
use Math::Round qw{nhimult}; 

our $VERSION = '0.03';

=head1 NAME

Time::HiRes::Sleep::Until - Provides common ways to sleep until...

=head1 SYNOPSIS

  use Time::HiRes::Sleep::Until;
  my $su=Time::HiRes::Sleep::Until->new;
  $su->epoch(1420070400.0);       # sleep until 2015-01-01 00:00
  $su->mark(20);                  # sleep until 20 second mark of the clock :00, :20, or :40
  $su->second(45);                # sleep until 45 seconds after the minute

=head1 DESCRIPTION

Sleep Until provides sleep wrappers for common sleep functions that I typically need.  These methods are simply wrappers around L<Time::HiRes> and L<Math::Round>.

We use this package to make measurements at the same time within the minute for integration with RRDtool.

=head1 USAGE

  use strict;
  use warnings;
  use DateTime;
  use Time::HiRes::Sleep::Until;
  my $su=Time::HiRes::Sleep::Until->new;
  do {
    print DateTime->now, "\n"; #make a measurment three times a minute
  } while ($su->mark(20));

=head1 CONSTRUCTOR

=head2 new

  use Time::HiRes::Sleep::Until;
  my $su=Time::HiRes::Sleep::Until->new;

=head1 METHODS

=head2 epoch

Sleep until provided epoch in float seconds.

  my $slept=$su->epoch($epoch); #epoch is simply a calculated time + $seconds

=cut

sub epoch {
  my $self  = shift;
  my $epoch = shift || 0; #default is 1970-01-01 00:00
  my $sleep = $epoch - time;
  return $sleep <= 0 ? 0 : sleep($sleep);
}

=head2 mark

Sleep until next second mark;

  my $slept=$su->mark(20); # 20 second mark, i.e.  3 times a minute on the 20s
  my $slept=$su->mark(10); # 10 second mark, i.e.  6 times a minute on the 10s
  my $slept=$su->mark(6);  #  6 second mark, i.e. 10 times a minute on 0,6,12,...

=cut

sub mark {
  my $time  = time;
  my $self  = shift;
  my $mark  = shift || 0;
  die("Error: mark requires parameter to be greater than zero.") unless $mark > 0;
  my $epoch = nhimult($mark => $time); #next mark
  return $self->epoch($epoch);
}

=head2 second

Sleep until the provided seconds after the minute

  my $slept=$su->second(0);  #sleep until top of minute
  my $slept=$su->second(30); #sleep until bottom of minute

=cut

sub second {
  my $time     = time;
  my $self     = shift;
  my $second   = shift || 0; #default is top of the minute
  my $min_next = nhimult(60 => $time);
  my $min_last = $min_next - 60;
  return $time < $min_last + $second
           ? $self->epoch($min_last + $second)
           : $self->epoch($min_next + $second);
}

=head2 top

Sleep until the top of the minute

  my $slept=$su->top; #alias for $su->second(0);

=cut

sub top {
  my $self=shift;
  return $self->second(0);
}

=head1 LIMITATIONS

The mathematics adds a small amount of delay for which we do not account.  Testing routinely passes with 100th of a second accuracy and typically with millisecond accuracy.

=head1 BUGS

Please log on RT and send an email to the author.

=head1 SUPPORT

DavisNetworks.com supports all Perl applications including this package.

=head1 AUTHOR

  Michael R. Davis
  CPAN ID: MRDVT
  Satellite Tracking of People, LLC
  mdavis@stopllc.com
  http://www.stopllc.com/

=head1 COPYRIGHT

This program is free software licensed under the...

The General Public License (GPL), Version 2, June 1991

The full text of the license can be found in the LICENSE file included with this module.

=head1 SEE ALSO

L<Time::HiRes>, L<Math::Round>

=cut

1;
