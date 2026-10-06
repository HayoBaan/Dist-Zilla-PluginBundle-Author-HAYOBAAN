package Dist::Zilla::Plugin::Author::HAYOBAAN::LinkCheck;
use strict;
use warnings;

# ABSTRACT: Add author tests for POD links
# VERSION

use Moose;
extends 'Dist::Zilla::Plugin::InlineFiles';
with 'Dist::Zilla::Role::PrereqSource';

sub register_prereqs {
    my $self = shift;

    return $self->zilla->register_prereqs(
        { type  => 'requires',
          phase => 'develop', },
        'Test::Pod::LinkCheck' => '0',
    );
}

=pod

=encoding UTF-8

=for :stopwords Randy Stauner ACKNOWLEDGEMENTS cpan testmatrix url annocpan anno bugtracker
rt cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 USAGE

Add the following to your F<dist.ini>:

  [Author::HAYOBAAN::LinkCheck]

=head1 DESCRIPTION

Adds the author test F<xt/author/pod-linkcheck.t>, which checks that the
links in the POD resolve. It is Randy Stauner's
L<Test::Pod::LinkCheck|Dist::Zilla::Plugin::Test::Pod::LinkCheck> plugin,
modified by Hayo Baan. The test looks up modules on CPAN, instead of with the
deprecated CPANPLUS.

=head1 SEE ALSO

=for :list
* The original L<Test::Pod::LinkCheck|Dist::Zilla::Plugin::Test::Pod::LinkCheck> plugin
* The underlying test L<Test::Pod::LinkCheck>

=cut

=for Pod::Coverage register_prereqs

=head1 ACKNOWLEDGEMENTS

This plugin is based on the
L<Test::Pod::LinkCheck|Dist::Zilla::Plugin::Test::Pod::LinkCheck> plugin by
Randy Stauner (rwstauner at cpan.org). That plugin is copyright (c) 2011 by
Randy Stauner, under the same terms as the Perl 5 programming language
system itself.

=cut

__PACKAGE__->meta->make_immutable;
no Moose;

1;

__DATA__
___[ xt/author/pod-linkcheck.t ]___
#!perl

use strict;
use warnings;
use Test::More;

foreach my $env_skip ( qw(SKIP_POD_LINKCHECK) ) {
    plan skip_all => "\$ENV{$env_skip} is set, skipping" if $ENV{$env_skip};
}

eval "use Test::Pod::LinkCheck";
if ( $@ ) {
    plan skip_all => 'Test::Pod::LinkCheck required for testing POD';
} else {
    my $linktest = Test::Pod::LinkCheck->new;
    $linktest->cpan_backend('CPAN');
    $linktest->all_pod_ok;
}
