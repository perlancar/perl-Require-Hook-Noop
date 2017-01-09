package Require::Hook::Noop;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

sub new {
    my ($class, %args) = @_;

    $args->{_filenames} = {};
    for my $e0 (@{ $self->{modules} // [] }) {
        (my $e = "$e0.pm") = s!::!/!g;
        push @{ $args->{_filenames} }, $e;
    }

    bless \%args, $class;
}

my $noop_code = "1;\n";

sub Require::Hook::Noop::INC {
    my ($self, $filename) = @_;

    return \$noop_code if grep { $filename eq $_ } @{ $self->{_filenames} };

    undef;
}

1;
# ABSTRACT: No-op loading of some modules

=head1 SYNOPSIS

 {
     local @INC = (Require::Hook::Noop->new( modules => [qw/Foo::Bar Qux/] ));
     require Foo::Bar; # will be no-op'ed
     require Baz;      # will be loaded
     # ...
 }


=head1 DESCRIPTION

This is a L<Require::Hook> version of L<lib::noop>.


=head1 METHODS

=head2 new([ %args ]) => obj

Constructor. Known arguments:

=over

=item * modules => array

Module names to no-op, e.g. C<< ["Mod::SubMod", "Mod2"] >>.

=back


=head1 SEE ALSO

L<lib::noop>

Other C<Require::Hook::*> modules.
