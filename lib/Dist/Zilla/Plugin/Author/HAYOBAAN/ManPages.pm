package Dist::Zilla::Plugin::Author::HAYOBAAN::ManPages;
use strict;
use warnings;

# ABSTRACT: Give the man pages MakeMaker makes the name of their manual, their version, and the release date
# VERSION

use Moose;
with 'Dist::Zilla::Role::InstallTool';

use POSIX qw(strftime);

sub setup_installer {
    my $self = shift;

    my ($makefile) = grep { $_->name eq 'Makefile.PL' } @{ $self->zilla->files };
    $self->log_fatal('No Makefile.PL found, add this plugin after MakeMaker') if !$makefile;
    # The date of the build, which is the date of the release, is fixed in Makefile.PL
    my $date = strftime('%Y-%m-%d', localtime);
    $makefile->content($makefile->content . ${ $self->section_data('manifypods') } =~ s/\{\{DATE\}\}/$date/r);
    return;
}

=pod

=head1 USAGE

Add the following to your F<dist.ini>, after the C<[MakeMaker]> plugin:

  [Author::HAYOBAAN::ManPages]

=head1 DESCRIPTION

MakeMaker makes the man pages of the scripts (section 1) and modules
(section 3) with one B<pod2man> command per section. Their header then reads
"User Contributed Perl Documentation", and their footer the version of Perl.

This plugin adds a C<MY::manifypods> method to F<Makefile.PL>. It defines the
C<POD2MAN> macro as MakeMaker does, and makes each man page with a B<pod2man> command of its own. Each page names:

=for :list
* the kind of manual in its header: "User Commands" in section 1, "Perl
Programmers Reference Guide" in section 3;
* the script or module with the distribution's version in its footer, e.g.
C<imageList 0.018>;
* the date of the build, also in its footer. That's the date of the release,
the date of its version. The date is fixed in F<Makefile.PL>, so everyone who
installs the release gets the same date.

=cut

=for Pod::Coverage setup_installer

=cut

use Data::Section 0.004 -setup;

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__DATA__
__[ manifypods ]__

# Each man page gets a pod2man command of its own, so it names its manual, the
# script or module with the version, and the date of the release. Added by
# Dist::Zilla::Plugin::Author::HAYOBAAN::ManPages.
{
    package MY;

    sub manifypods {
        my ($self) = @_;

        my $date = '{{DATE}}';
        my %center_of = (1 => 'User Commands', 3 => 'Perl Programmers Reference Guide');
        my (@pods, @commands);
        for my $section (1, 3) {
            my $pods = $self->{"MAN${section}PODS"} || {};
            for my $pod (sort keys %$pods) {
                # The man page is e.g. $(INST_MAN1DIR)/imageList.$(MAN1EXT)
                (my $name = $pods->{$pod}) =~ s{^.*/|\.\$\(MAN\dEXT\)$}{}g;
                push @pods, $pod;
                push @commands, "\t\$(NOECHO) \$(POD2MAN) --section=\$(MAN${section}SECTION) --perm_rw=\$(PERM_RW) -u"
                    . qq{ --center="$center_of{$section}" --release="$name \$(VERSION)" --date=$date}
                    . " $pod $pods->{$pod}";
            }
        }
        # The POD2MAN macro, as MakeMaker's own manifypods defines it, and the target
        return $self->POD2MAN_macro . "\nmanifypods : pure_all config " . join(' ', @pods) . "\n"
            . (@commands ? join("\n", @commands) : "\t\$(NOECHO) \$(NOOP)") . "\n";
    }
}
