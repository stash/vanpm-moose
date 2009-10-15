#!/usr/bin/env perl
use warnings;
use strict;

{
    package AxisVector;
    use Moose;
    use Moose::Util::TypeConstraints;

    enum 'AxisName' => qw(x y z);

    subtype 'WholeNumber'
        => as 'Int'
        => where { $_ >= 0 };

    has 'magnitude' => (is => 'rw', isa => 'WholeNumber');
    has 'axis' => (is => 'rw', isa => 'AxisName');
}

my $av = AxisVector->new(magnitude => 3, axis => 'z');

eval { AxisVector->new(magnitude => 3,    axis => 'r'); }; warn $@;
eval { AxisVector->new(magnitude => -3,   axis => 'x'); }; warn $@;
eval { AxisVector->new(magnitude => 3.14, axis => 'x'); }; warn $@;
