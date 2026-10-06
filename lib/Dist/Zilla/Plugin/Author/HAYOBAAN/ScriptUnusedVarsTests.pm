package Dist::Zilla::Plugin::Author::HAYOBAAN::ScriptUnusedVarsTests;
use strict;
use warnings;

# ABSTRACT: Add author tests for unused variables in scripts
# VERSION

use Moose;
with 'Dist::Zilla::Role::FileGatherer',
     'Dist::Zilla::Role::PrereqSource';

use Dist::Zilla::File::InMemory;
use Data::Section 0.004 -setup;

sub gather_files {
    my $self = shift;

    $self->add_file(Dist::Zilla::File::InMemory->new(
        name    => 'xt/author/unused-vars-scripts.t',
        content => ${ $self->section_data('xt/author/unused-vars-scripts.t') },
    ));
    return;
}

sub register_prereqs {
    my $self = shift;

    return $self->zilla->register_prereqs(
        { type  => 'requires',
          phase => 'develop', },
        'Test::Perl::Critic' => '0',
        'Perl::Critic::Policy::Variables::ProhibitUnusedVarsStricter' => '0',
    );
}

=pod

=head1 USAGE

Add the following to your F<dist.ini>:

  [Author::HAYOBAAN::ScriptUnusedVarsTests]

=head1 DESCRIPTION

Adds the author test F<xt/author/unused-vars-scripts.t>. It checks the Perl
scripts in the F<bin> and F<script> directories for unused variables, with
the Perl::Critic policy
L<Perl::Critic::Policy::Variables::ProhibitUnusedVarsStricter>.

L<Dist::Zilla::Plugin::Test::UnusedVars> checks the modules, by inspecting
their compiled code. That doesn't work for scripts, as loading a script runs
it. This test checks the scripts statically instead. The policy also catches
variables with an initializer and unused values unpacked from C<@_>.

The test ignores the distribution's Perl::Critic profile, so the rules are
the same in every distribution.

=head1 SEE ALSO

=for :list
* The underlying test L<Test::Perl::Critic>
* The policy L<Perl::Critic::Policy::Variables::ProhibitUnusedVarsStricter>

=cut

=for Pod::Coverage gather_files register_prereqs

=cut

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__DATA__
__[ xt/author/unused-vars-scripts.t ]__
use strict;
use warnings;
use Test::More;
use File::Find;

eval "use Test::Perl::Critic; use Perl::Critic::Policy::Variables::ProhibitUnusedVarsStricter";
plan skip_all => 'Test::Perl::Critic and Perl::Critic::Policy::Variables::ProhibitUnusedVarsStricter '
    . 'required for testing unused variables in scripts' if $@;

# The scripts: files in bin and script with a Perl shebang line
my @scripts;
find({ no_chdir => 1, wanted => sub {
    return if !-f $_;
    open my $fh, '<', $_ or die "Can't read $_: $!";
    my $first_line = <$fh> // '';
    push(@scripts, $_) if $first_line =~ /\A#!\s*(?:\S*\/env\s+)?\S*perl/;
} }, grep { -d } qw(bin script));
plan skip_all => 'No scripts found' if !@scripts;

# The empty profile keeps the distribution's own Perl::Critic settings out of this check
Test::Perl::Critic->import(
    '-profile'       => '',
    '-single-policy' => 'Variables::ProhibitUnusedVarsStricter',
);
plan tests => scalar @scripts;
critic_ok($_) for sort @scripts;
