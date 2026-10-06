package Dist::Zilla::Plugin::Author::HAYOBAAN::CheckCopyrightYear;
use strict;
use warnings;
use utf8;

# ABSTRACT: Check before a release that the copyright year is up to date
# VERSION

use Moose;
with 'Dist::Zilla::Role::BeforeRelease';

sub before_release {
    my $self = shift;

    my $current_year = (localtime)[5] + 1900;
    my $copyright_year = $self->zilla->copyright_year;
    # The year comes from dist.ini, as characters or as UTF-8 bytes
    utf8::decode($copyright_year);
    my ($first, $separator, $last) = $copyright_year =~ /^\s*(\d{4})(?:(\s*\D+?\s*)(\d{4}))?\s*$/
        or $self->log_fatal("copyright_year in dist.ini isn't a year or a range of years: $copyright_year");
    $last //= $first;
    my $advice = "Set copyright_year in dist.ini to " . ($first == $current_year ? $first : "$first–$current_year");
    $self->log_fatal("The copyright_year range in dist.ini is written with '$separator', not with an en dash "
        . "without spaces. $advice") if defined $separator && $separator ne '–';
    $self->log_fatal("The copyright_year in dist.ini ends in $last, but this release is in $current_year. $advice")
        if $last != $current_year;
    $self->log("The copyright year is up to date ($copyright_year)");
    return;
}

=pod

=head1 USAGE

Add the following to your F<dist.ini>:

  [Author::HAYOBAAN::CheckCopyrightYear]

=head1 DESCRIPTION

Checks before a release that the C<copyright_year> in F<dist.ini> ends with
the current year, the year of the release. Pod::Weaver writes the copyright
notice of every file from this year, so this keeps all notices up to date.

The year is a single year (C<2026>), or a range written with an en dash
without spaces (C<2015–2026>). The release stops when the year is out of date
or written differently, and says how to write it.

=cut

=for Pod::Coverage before_release

=cut

__PACKAGE__->meta->make_immutable;
no Moose;
1;
