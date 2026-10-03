package Dist::Zilla::Plugin::Author::HAYOBAAN::NamingTests;
use strict;
use warnings;

# ABSTRACT: Add author tests for Perl naming conventions
# VERSION

use Moose;
with 'Dist::Zilla::Role::FileGatherer',
     'Dist::Zilla::Role::TextTemplate',
     'Dist::Zilla::Role::PrereqSource';

use Dist::Zilla::File::InMemory;
use Data::Section 0.004 -setup;

=attr package_exemptions

Space-separated regular expressions of package name components the test
accepts despite not starting with an uppercase letter. The policy checks
each component of a package name separately, so to accept
C<File::stat::Extra>, exempt C<stat>. These are added to the policy's own
default (C<main>).

=cut

has package_exemptions => (
    is      => 'ro',
    isa     => 'Str',
    default => '',
);

=attr subroutine_exemptions

Space-separated regular expressions of subroutine names the test accepts
despite being mixed case, e.g. camelCase aliases kept for backward
compatibility. These are added to the policy's own defaults (C<AUTOLOAD>,
C<DESTROY>, the tie and Moose methods, etc.).

=cut

has subroutine_exemptions => (
    is      => 'ro',
    isa     => 'Str',
    default => '',
);

sub gather_files {
    my $self = shift;

    my $template = ${ $self->section_data('xt/author/naming.t') };
    $self->add_file(Dist::Zilla::File::InMemory->new(
        name    => 'xt/author/naming.t',
        content => $self->fill_in_string($template, {
            package_exemptions    => $self->package_exemptions,
            subroutine_exemptions => $self->subroutine_exemptions,
        }),
    ));
    return;
}

sub register_prereqs {
    my $self = shift;

    return $self->zilla->register_prereqs(
        { type  => 'requires',
          phase => 'develop', },
        'Test::Perl::Critic' => '0',
        'Perl::Critic::Policy::NamingConventions::Capitalization' => '0',
    );
}

=pod

=head1 USAGE

Add the following to your F<dist.ini>:

  [Author::HAYOBAAN::NamingTests]
  ; Optional exemptions
  package_exemptions    = stat
  subroutine_exemptions = isFile isDir

=head1 DESCRIPTION

Adds the author test F<xt/author/naming.t>. It checks that names follow
Perl's naming conventions, using the Perl::Critic policy
L<Perl::Critic::Policy::NamingConventions::Capitalization>:

=for :list
* subs and variables are all lowercase (snake_case), or all uppercase;
* package names start with an uppercase letter (UpperCamelCase);
* constants are all uppercase.

This catches mixed-case names such as C<readFile>, but not run-together
lowercase names such as C<headerlinetext>. The test ignores the
distribution's Perl::Critic profile, so the rules are the same in every
distribution. Names that must stay as they are can be exempted with
L</package_exemptions> and L</subroutine_exemptions>.

=head1 SEE ALSO

=for :list
* The underlying test L<Test::Perl::Critic>
* The policy L<Perl::Critic::Policy::NamingConventions::Capitalization>

=cut

=for Pod::Coverage gather_files register_prereqs

=cut

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__DATA__
__[ xt/author/naming.t ]__
use strict;
use warnings;
use Test::More;

eval "use Test::Perl::Critic; use Perl::Critic::Policy::NamingConventions::Capitalization";
plan skip_all => 'Test::Perl::Critic required for testing naming conventions' if $@;

# Names this distribution exempts, added to the policy's own default exemptions
my %extra_exemptions = (
    package_exemptions    => '{{ $package_exemptions }}',
    subroutine_exemptions => '{{ $subroutine_exemptions }}',
);
my %default = map { ($_->{name} => $_->{default_string} // '') }
    Perl::Critic::Policy::NamingConventions::Capitalization->supported_parameters;
my $profile = "[NamingConventions::Capitalization]\n"
    . join('', map { "$_ = $default{$_} $extra_exemptions{$_}\n" } sort keys %extra_exemptions);

# The in-memory profile keeps the distribution's own Perl::Critic settings out of this check
Test::Perl::Critic->import(
    '-profile'       => \$profile,
    '-single-policy' => 'NamingConventions::Capitalization',
);
all_critic_ok(grep { -d } qw(lib bin script));
