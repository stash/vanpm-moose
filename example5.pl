#!/usr/bin/env perl
use warnings;
use strict;
use Test::More qw/no_plan/;
use Moose::Util ();

{
    package Uppercaser;
    use Moose::Role;
    requires 'string';
    sub to_uppercase {
        my $self = shift;
        return uc $self->string;
    }
}
{
    package Lowercaser;
    use Moose::Role;
    requires 'string';
    sub to_lowercase {
        my $self = shift;
        return lc $self->string;
    }
}
{
    package Undecorated;
    use Moose;
    has 'string' => (is => 'rw', isa => 'Str', default => 'foo');
}
{
    package Decorated;
    use Moose;
    extends 'Undecorated';
    with 'Uppercaser', 'Lowercaser';
}
{
    package Decorated2;
    use Moose;
    # NOTE: no extends, has must come before with
    has 'string' => (is => 'rw', isa => 'Str', default => 'foo');
    with 'Uppercaser', 'Lowercaser';
}

my $deco = Decorated->new();
my $deco2 = Decorated2->new();

ok $deco->does("Lowercaser"), 'Decorated does Lowercaser';
ok $deco->does("Uppercaser"), 'Decorated does Uppercaser';
ok $deco2->does("Lowercaser"), 'Decorated does Lowercaser';
ok $deco2->does("Uppercaser"), 'Decorated does Uppercaser';

my $undeco = Undecorated->new();
ok !$undeco->does("Lowercaser"), 'Undecorated doesnt do Lowercaser';
ok !$undeco->does("Uppercaser"), 'Undecorated doesnt do Uppercaser';

Moose::Util::apply_all_roles($undeco, qw(Uppercaser Lowercaser));
ok $undeco->does("Lowercaser"), 'Now does Lowercaser!';
ok $undeco->does("Uppercaser"), 'Now does Uppercaser!';
warn ref($deco2);
warn ref($undeco);

