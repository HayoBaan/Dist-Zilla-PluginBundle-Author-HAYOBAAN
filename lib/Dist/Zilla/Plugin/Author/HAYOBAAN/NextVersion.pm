package Dist::Zilla::Plugin::Author::HAYOBAAN::NextVersion;
use strict;
use warnings;

# ABSTRACT: Adapted version of Git::NextVersion to allow influencing version bumping.
# VERSION

=head1 DESCRIPTION

Provides the next version number, just as Git::NextVersion would
do. This module just adds the ability to inhibit bumping the version
by setting the attribute C<inhibit_version_bump> to a true value.

=head1 USAGE

  # In dist.ini
  [Author::HAYOBAAN::NextVersion]
  inhibit_version_bump = 0

=head1 SEE ALSO

L<Dist::Zilla::Plugin::Git::NextVersion>

=cut

use Moose;
use namespace::autoclean 0.09;
use Dist::Zilla 5.014; # default_jobs
extends 'Dist::Zilla::Plugin::Git::NextVersion';

=attr inhibit_version_bump

Specifies that the version should not be increased.

=cut

has inhibit_version_bump => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => 0,
);

# Own version of the provide_version function
sub provide_version {
    my ($self) = @_;

    my $inhibit_bump = $self->inhibit_version_bump;
    my $last_ver = $self->_last_version;
    my $new_ver = $last_ver;

    if (exists $ENV{V}) {
        # Override with value of V from enviroment
        $new_ver = $ENV{V};
    } else {
        if (!defined $last_ver) {
            $new_ver = $self->first_version;
            $inhibit_bump = 1;
        }

        # Bump version
        unless ($inhibit_bump) {
            require Version::Next;
            $new_ver = Version::Next::next_version($new_ver);
        }
    }

    # Inform about what was done
    if (!defined $last_ver) {
        $self->log("Initialising version to $new_ver");
    } elsif ($last_ver eq $new_ver) {
        $self->log("Maintaining version at $new_ver");
    } else {
        $self->log("Updating version from $last_ver to $new_ver");
    }

    return "$new_ver";
}

# Own version of the provide_version function, allows for duplicate
# version when not version bumping
sub before_release {
    my $self = shift;

    # No duplicate version check when not bumping
    unless ($self->inhibit_version_bump) {
        # Make sure we're not duplicating a version
        my $version = version->parse( $self->zilla->version );

        $self->log_fatal("version $version has already been tagged")
            if grep { $_ == $version } @{ $self->_all_versions };
    }

    return;
}

__PACKAGE__->meta->make_immutable;
1;
