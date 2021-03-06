package Dist::Zilla::Plugin::Author::HAYOBAAN::NextVersion;
use strict;
use warnings;

# ABSTRACT: Adapted version of the Git::NextVersion plugin to allow influencing version bumping.
# VERSION

=head1 DESCRIPTION

Provides the next version number, just as
L<Git::NextVersion|Dist::Zilla::Plugin::Git::NextVersion> would do,
including specifying the version using the C<V> environment variable.

Unlike L<Git::NextVersion|Dist::Zilla::Plugin::Git::NextVersion>, you are, however, able to influence I<if> and I<how> the version is bumped:

=begin :list

=*

By setting the attribute L</include_minor_version> to I<true> you specify that the version string should include a minor version (i.e., end in C<_I<xxx>>).

=*

Likewise, setting L</remove_minor_version> to I<true>, will remove any existing minor version.

=*

Finally, setting the attribute L</keep_version> to a I<true> value will keep the version as is (ignoring above settings).

=end :list

Specifying a specific version using the C<V> environment variable,
overrides all of these settings.

=head1 USAGE

Add the following to your F<dist.ini>:

  [Author::HAYOBAAN::NextVersion]
  include_minor_version = 0
  remove_minor_version  = 0
  keep_version          = 0

=head1 SEE ALSO

=for :list
* The original L<Git::NextVersion|Dist::Zilla::Plugin::Git::NextVersion> plugin.

=cut

use Moose;
use namespace::autoclean 0.09;
use Dist::Zilla 5.014; # default_jobs
extends 'Dist::Zilla::Plugin::Git::NextVersion';

=attr include_minor_version

Specifies that a minor version should be included in the version
string.  This will add C<_001> to the current version if the current
version string did not already end in C<_I<xxx>>.

Default: I<false>

=cut

has include_minor_version => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => 0,
);

=attr remove_minor_version

Specifies that an existing minor version should be removed from the existing version
string.  This will remove any C<_I<xxx>> from the end of the current version string.

Note: overrides L</include_minor_version>.

Default: I<false>

=cut

has remove_minor_version => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => 0,
);

=attr keep_version

Specifies that the version should be kept the same.

Default: I<false>

=cut

has keep_version => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => 0,
);

# Own version of the provide_version function
sub provide_version {
    my ($self) = @_;

    my $keep_version = $self->keep_version;
    my $remove_minor_version = $self->remove_minor_version;
    my $include_minor_version = $self->include_minor_version && !$remove_minor_version;
    my $last_ver = $self->_last_version;
    my $new_ver = $last_ver;

    if (exists $ENV{V}) {
        # Override with value of V from enviroment
        $new_ver = $ENV{V};
    } elsif (!defined $last_ver) {
        # Initialise if no version set
        $new_ver = $self->first_version;
    } elsif (!$keep_version) {
        $new_ver .= '_000' if $include_minor_version && $last_ver !~ /_\d+$/;
        $new_ver =~ s/_\d+$// if $remove_minor_version;

        require Version::Next;
        $new_ver = Version::Next::next_version($new_ver);
    }

    # Inform about what was done
    if (!defined $last_ver) {
        $self->log("Initialising version to $new_ver");
    } elsif ($last_ver eq $new_ver) {
        $self->log("Keeping version at $new_ver");
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
    unless ($self->keep_version) {
        # Make sure we're not duplicating a version
        my $version = version->parse( $self->zilla->version );

        $self->log_fatal("version $version has already been tagged")
            if grep { $_ == $version } @{ $self->_all_versions };
    }

    return;
}

__PACKAGE__->meta->make_immutable;
1;
