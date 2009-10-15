#!/usr/bin/env perl
use warnings;
use strict;

{
  package Point;
  use Moose;

  has 'x' => (
    is => 'rw', isa => 'Int',
    default => 0,
  );
   
  has 'y' => (
    is => 'rw', isa => 'Int',
    default => 0,
  );

  sub string {
     my $self = shift;
     return $self->x . ',' . $self->y;
  }
}

{
  package PointClassic;
  use warnings;
  use strict;

  my $int_pat = qr/^-?[0-9]+$/;

  sub new {
    my $class = shift;
    my %p = @_==1 ? %{$_[0]} : @_;
    my $self = bless {}, $class;
    $self->x($p{x} || 0);
    $self->y($p{y} || 0);
    return $self;
  }

  sub x {
    my $self = shift;
    if (@_) {
      my $x = shift;
      die "x isn't an int" if $x !~ $int_pat;
      $self->{x} = $x;
    }
    return $self->{x};
  }

  sub y {
    my $self = shift;
    if (@_) {
      my $y = shift;
      die "y isn't an int" if $y !~ $int_pat;
      $self->{y} = $y;
    }
    return $self->{y};
  }

  sub string {
     my $self = shift;
     return $self->x . ',' . $self->y;
  }
}

my $point_a = Point->new();
my $point_b = Point->new(x => 5, y => 4);
print $point_a->dump;
print $point_b->dump;

print "assigning string to x...\n";
eval { $point_a->x("foo") };
warn $@ if $@;
print "x is " . $point_a->x . "\n";

print "b is " . $point_b->string . "\n";
