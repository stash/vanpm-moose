#!/usr/bin/env perl
use warnings;
use strict;
use Test::More qw/no_plan/;
use Moose::Util ();

{
    package RoleA;
    use Moose::Role;
    requires 'generate';
    around 'generate' => sub {
        my $code = shift;
        my $self = shift;
        Test::More::diag "1. before";
        my $rv = $self->$code(@_);
        Test::More::diag "3. after";
        return uc $rv;
    };
}

{
    package Generator;
    use Moose;
    with 'RoleA';
    sub generate {
        Test::More::diag "2. original";
        return "foo";
    }
}

my $gen = Generator->new;
is $gen->generate, 'FOO', "correct result";
