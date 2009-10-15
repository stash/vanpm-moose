#!/usr/bin/env perl
use warnings;
use strict;

{
  package Wrapper;
  use Moose;

  has 'coeff' => (
    is => 'rw', isa => 'Num',
    default => sqrt(2), lazy => 1,
  );

  has 'expensive' => (
    is => 'ro', isa => 'Expensive',
    lazy_build => 1,
    handles => [qw(result)],
  );

  sub _build_expensive {
      my $self = shift;
      return Expensive->new(
          wrapper => $self,
      );
  }
}

{
  package Expensive;
  use Moose;

  has 'result' => (
    is => 'rw', isa => 'Num', builder => 'calculate_result',
  );
   
  has 'wrapper' => (
    is => 'ro', isa => 'Wrapper',
    required => 1,
    weak_ref => 1,
  );

  sub calculate_result {
      my $self = shift;
      return $self->wrapper->coeff * 3.14159;
  }

  sub BUILD { print "2. construct expensive\n"; }
  sub DEMOLISH { print "4. destruct expensive\n"; }
}

print "0. start\n";
my $w = Wrapper->new;
print "1. got a wrapper\n";
print "3. result: ",$w->result,$/;
undef $w;
print "5. done\n";
