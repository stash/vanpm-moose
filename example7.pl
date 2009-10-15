#!/usr/bin/env perl
use warnings;
use strict;
use Test::More qw/no_plan/;
use Moose::Util ();

{
    package Base;
    use Moose;
    sub generate {
        print "1. before second\n";
        inner();
        print "6. after second\n";
    }
    sub create {
        print "3. base\n";
    }
}
{
    package Second;
    use Moose;
    extends 'Base';
    augment 'generate' => sub {
        print "2. before third\n";
        inner();
        print "5. after third\n";
    };

    override 'create' => sub {
        print "2. before base\n";
        super();
        print "4. after base\n";
    };
}
{
    package Third;
    use Moose;
    extends 'Second';
    augment 'generate' => sub {
        print "3. end before\n";
        inner(); # No-op
        print "4. end after\n";
    };

    override 'create' => sub {
        print "1. before second\n";
        super();
        print "5. after second\n";
    };
}

my $o = Third->new;
$o->generate;
print "-----------\n";
$o->create;
