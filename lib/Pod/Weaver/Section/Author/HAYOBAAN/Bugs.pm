package Pod::Weaver::Section::Author::HAYOBAAN::Bugs;
use strict;
use warnings;

# ABSTRACT: Improved version of Pod::Weaver::Section::Bugs, adds proper links to the BUGS pod section
# VERSION

use Moose;
use namespace::autoclean;
with 'Pod::Weaver::Role::Section';

=head1 OVERVIEW

Just like the original L<Section::Bugs|Pod::Weaver::Section::Bugs>
plugin, this section plugin will produce a hunk of Pod giving bug
reporting information for the document. However, instead of a
text-only link, this plugin will create a proper, clickable, link.

=head1 USAGE

Add the following line to your F<weaver.ini>:

    [Author::HAYOBAAN::Bugs]

=head1 SEE ALSO

=for :list
* The original L<Section::Bugs|Pod::Weaver::Section::Bugs> plugin.

=cut

=attr header

The title of the header to be added.

Default: C<BUGS>

=cut

has header => (
  is      => 'ro',
  isa     => 'Str',
  default => 'BUGS',
);

=for Pod::Coverage weave_section

=cut

sub weave_section {
    my ($self, $document, $input) = @_;

    return unless exists $input->{distmeta}{resources}{bugtracker};

    my $bugtracker = $input->{distmeta}{resources}{bugtracker};
    my ($web,$mailto) = @{$bugtracker}{qw/web mailto/};
    return unless defined $web || defined $mailto;

    my $text = "Please report any bugs or feature requests ";

    if (defined $web) {
        $text .= "on the bugtracker\nL<website|$web>";
        $text .= defined $mailto ? "\n or " : ".\n";
    }

    if (defined $mailto) {
        $text .= "by L<email|mailto:$mailto>.\n";
    }

    $text .= <<'HERE';

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.
HERE

    push @{ $document->children },
        Pod::Elemental::Element::Nested->new({
            command  => 'head1',
            content  => $self->header,
            children => [
                Pod::Elemental::Element::Pod5::Ordinary->new({ content => $text }),
            ],
        });

    return;
}

__PACKAGE__->meta->make_immutable;
1;
