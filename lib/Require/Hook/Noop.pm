package Require::Hook::Noop;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

sub new {
    my ($class, %args) = @_;

    $args{_filenames} = [];
    for my $e0 (@{ $args{modules} // [] }) {
        (my $e = "$e0.pm") =~ s!::!/!g;
        push @{ $args{_filenames} }, $e;
    }

    bless \%args, $class;
}

my $noop_code = "1;\n";

sub Require::Hook::Noop::INC {
    my ($self, $filename) = @_;

    if (grep { $filename eq $_ } @{ $self->{_filenames} }) {
        print STDERR __PACKAGE__ . ": require($filename) no-op'ed\n" if $self->{debug};
        return \$noop_code;
    }

    print STDERR __PACKAGE__ . ": declined handling require($filename)\n" if $self->{debug};
    undef;
}

1;
# ABSTRACT: No-op loading of some modules

=for Pod::Coverage .+

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

=item * debug => bool

If set to true, will print debug statements to STDERR.

=back


=head1 SEE ALSO

L<lib::noop>

Other C<Require::Hook::*> modules.
