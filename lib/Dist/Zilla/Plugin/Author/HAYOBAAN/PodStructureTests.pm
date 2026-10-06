package Dist::Zilla::Plugin::Author::HAYOBAAN::PodStructureTests;
use strict;
use warnings;

# ABSTRACT: Add author tests for the structure of the POD
# VERSION

use Moose;
with 'Dist::Zilla::Role::FileGatherer',
     'Dist::Zilla::Role::PrereqSource';

use Dist::Zilla::File::InMemory;
use Data::Section 0.004 -setup;

sub gather_files {
    my $self = shift;

    $self->add_file(Dist::Zilla::File::InMemory->new(
        name    => 'xt/author/pod-structure.t',
        content => ${ $self->section_data('xt/author/pod-structure.t') },
    ));
    return;
}

sub register_prereqs {
    my $self = shift;

    return $self->zilla->register_prereqs(
        { type  => 'requires',
          phase => 'develop', },
        'File::Find' => '0',
        'Test::More' => '0',
    );
}

=pod

=head1 USAGE

Add the following to your F<dist.ini>:

  [Author::HAYOBAAN::PodStructureTests]

=head1 DESCRIPTION

Adds the author test F<xt/author/pod-structure.t>. It checks the POD of the
modules in F<lib>, and of the Perl scripts in F<bin> and F<script>. The test
runs on the built distribution, so it sees the sections that
L<Pod::Weaver> adds. It checks that:

=for :list
* the POD has the sections NAME, SYNOPSIS (or USAGE), DESCRIPTION (or
OVERVIEW), AUTHOR (or AUTHORS), and COPYRIGHT AND LICENSE;
* no section appears twice;
* no paragraph outside a list starts with C<* >. Such a paragraph is meant as
a list item, for instance after a C<=for :list> whose items are separated by
blank lines, but shows a literal C<*>;
* NAME starts with the name of the module or script;
* the authors have the layout Pod::Weaver gives them: one author is a
paragraph in an AUTHOR section, more authors are a list in an AUTHORS
section, with an C<=item *> per author;
* each author is written as C<Name (user at domain)>, or as C<Name> for an
author without a public address;
* the POD holds no e-mail addresses, except ones at the reserved example
domains (such as C<example.com>). Write an address as C<user at domain> in
the C<author> lines of F<dist.ini>, so scrapers don't find it.

=cut

=for Pod::Coverage gather_files register_prereqs

=cut

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__DATA__
__[ xt/author/pod-structure.t ]__
use strict;
use warnings;
use Test::More;
use File::Find;

# Returns the content of a file, decoded from UTF-8 when it is valid UTF-8
sub read_file {
    my ($file) = @_;

    open my $fh, '<:raw', $file or die "Can't read $file: $!";
    my $content = do { local $/ = undef; <$fh> };
    utf8::decode($content);
    return $content;
}

# Returns the name of a module (from its path) or of a script
sub pod_name {
    my ($file) = @_;

    return $file =~ m{^lib/(.+)\.pm$} ? $1 =~ s{/}{::}gr : $file =~ s{.*/}{}r;
}

# Returns the start of each paragraph that starts with "* " outside a list or
# region. Such a paragraph is meant as a list item, but shows a literal "*".
sub stray_items {
    my ($pod) = @_;

    my ($depth, @items) = (0);
    for my $paragraph (split /\n[ \t]*\n/, $pod) {
        if ($paragraph =~ /^=(?:over|begin)\b/) {
            $depth++;
        } elsif ($paragraph =~ /^=(?:back|end)\b/) {
            $depth-- if $depth > 0;
        } elsif (!$depth && $paragraph =~ /^\*\s+(\S.{0,39})/) {
            push(@items, "* $1" =~ s/\s*\n.*//sr);
        }
    }
    return @items;
}

# Returns the problems with the AUTHOR or AUTHORS section
sub author_problems {
    my ($section) = @_;

    my @headings = grep { exists $section->{$_} } ('AUTHOR', 'AUTHORS');
    return ('no AUTHOR section') if !@headings;
    return ('both an AUTHOR and an AUTHORS section') if @headings > 1;
    my $heading = $headings[0];
    # The authors are the paragraphs, without the list commands
    my $text = $section->{$heading};
    my $is_list = $text =~ /^=over\b/m;
    my $items = () = $text =~ /^=item[ \t]+\*[ \t]*$/mg;
    $text =~ s/^=(?:over|back|item)\b.*$//mg;
    my @authors = grep { /\S/ } split(/\n\s*\n/, $text);
    s/^\s+|\s+$//g for @authors;
    return ("the $heading section is empty") if !@authors;

    my @problems;
    my $expected = @authors == 1 ? 'AUTHOR' : 'AUTHORS';
    push(@problems, "the section with " . (@authors == 1 ? 'one author' : scalar(@authors) . ' authors')
        . " is $heading, but should be $expected") if $heading ne $expected;
    # The layout Pod::Weaver writes: one author as a paragraph, more as a list with an item per author
    if (@authors == 1) {
        push(@problems, 'a single author is written as a paragraph, not as a list') if $is_list;
    } elsif (!$is_list || $items != @authors) {
        push(@problems, 'several authors are written as a list: =over 4, then =item * and the author for each '
            . 'author, and =back');
    }
    # A name holds letters (with accents), spaces, dots, hyphens and apostrophes
    push(@problems, map { "author '$_' isn't written as 'Name' or 'Name (user at domain)'" }
        grep { !/^\p{L}[\p{L}\p{M}.' -]*?(?: \([^\s()\@]+ at [^\s()\@]+\.[^\s()\@]+\))?$/ } @authors);
    return @problems;
}

# Returns the problems with the POD structure of a module or script
sub pod_problems {
    my ($file) = @_;

    my $content = read_file($file);
    my $pod = join("\n", $content =~ /^(=(?!cut\b)\w.*?)(?:^=cut\b|\z)/msg);
    my (%section, %count);
    while ($pod =~ /^=head1\s+(.+?)\s*\n(.*?)(?=^=head1\s|\z)/msg) {
        $section{$1} = $2;
        $count{$1}++;
    }
    # Each section, or one of its alternatives
    my @required = (['NAME'], ['SYNOPSIS', 'USAGE'], ['DESCRIPTION', 'OVERVIEW'], ['COPYRIGHT AND LICENSE']);
    my @problems = map { "no $_->[0] section" . (@$_ > 1 ? " (or $_->[1])" : '') }
        grep { my $names = $_; !grep { exists $section{$_} } @$names } @required;
    push(@problems, map { "$count{$_} $_ sections" } grep { $count{$_} > 1 } sort keys %count);
    push(@problems, map { "'$_' looks like a list item, but isn't in a list" } stray_items($pod));
    push(@problems, author_problems(\%section));
    my $name = pod_name($file);
    push(@problems, "the NAME section doesn't start with '$name -'")
        if exists $section{NAME} && $section{NAME} !~ /^\s*\Q$name\E\s+-/;
    my @addresses = grep { !/\@(?:(?:[\w-]+\.)*example\.(?:com|net|org)|[\w.-]+\.(?:example|test|invalid|localhost))$/i }
        $pod =~ /([\w.+-]+\@[\w-]+(?:\.[\w-]+)+)/g;
    push(@problems, map { "e-mail address $_ in the POD (write it as user at domain)" } @addresses);
    return @problems;
}

my @files;
find({ no_chdir => 1, wanted => sub { push(@files, $_) if -f $_ && /\.pm$/ } }, 'lib') if -d 'lib';
find({ no_chdir => 1, wanted => sub {
    return if !-f $_;
    open my $fh, '<', $_ or die "Can't read $_: $!";
    my $first_line = <$fh> // '';
    push(@files, $_) if $first_line =~ /\A#!\s*(?:\S*\/env\s+)?\S*perl/;
} }, grep { -d } qw(bin script));
plan skip_all => 'No modules or scripts found' if !@files;

binmode(Test::More->builder->$_, ':encoding(UTF-8)') for qw(output failure_output todo_output);
plan tests => scalar @files;
for my $file (sort @files) {
    my @problems = pod_problems($file);
    ok(!@problems, "$file has the standard POD structure") or diag(join("\n", map { "$file: $_" } @problems));
}
