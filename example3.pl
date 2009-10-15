#!/usr/bin/env perl
use warnings;
use strict;

{
  package MyBase;
  use Moose;
  sub BUILD { print "1. build base\n"; }
  sub DEMOLISH { print "5. destroy base\n"; }
}

{
  package MySub;
  use Moose;
  extends 'MyBase';
  sub BUILD { print "2. build sub\n"; }
  sub DEMOLISH { print "4. destroy sub\n"; }
}

print "0. start\n";
my $o = MySub->new;
print "3. got an object\n";
undef $o;
print "6. done\n";
