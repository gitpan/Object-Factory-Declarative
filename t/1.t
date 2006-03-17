#! /usr/bin/perl

use Test;
BEGIN { plan tests => 2 };
use Object::Factory::Declarative;
ok(1); # If we made it this far, we're ok.


my $obj = Class1->method4(arg1 => 'method3');

ok($obj->{arg1} == 19);

# We need to create a class and a few methods to support the tests, so...

package Class1;
use Object::Factory::Declarative
(
    '--defaults' =>
    {
        package => 'Class1',
        constructor => 'new',
        method => 'method1',
    },
    'method4' =>
    {
        constructor_args => { arg1 => 'method2' },
        method_args => { arg1 => 'method3' },
    },
) ;

# Constructor
sub new
{
    my ($self, %args) = @_;
    my $class = ref $self || $self;
    bless { %args }, $class;
}

# Secondary initialization
sub method1
{
    my ($self, %args) = @_;
    $self->{$_} = $args{$_} foreach keys %args;
}

# A transformative method
sub method2
{
    length $_[1];
}

# A transformative method
sub method3
{
    my ($self, $arg) = @_;
    if($self->{$arg})
    {
        return $self->{$arg}*2 + 1;
    }
    $self->method2($arg);
}
