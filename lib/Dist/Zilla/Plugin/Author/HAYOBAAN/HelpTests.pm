package Dist::Zilla::Plugin::Author::HAYOBAAN::HelpTests;
use strict;
use warnings;

# ABSTRACT: Add author tests that every script shows its help and version
# VERSION

use Moose;
with 'Dist::Zilla::Role::FileGatherer',
     'Dist::Zilla::Role::PrereqSource';

use Dist::Zilla::File::InMemory;
use Data::Section 0.004 -setup;

sub gather_files {
    my $self = shift;

    $self->add_file(Dist::Zilla::File::InMemory->new(
        name    => 'xt/author/help.t',
        content => ${ $self->section_data('xt/author/help.t') },
    ));
    return;
}

sub register_prereqs {
    my $self = shift;

    return $self->zilla->register_prereqs(
        { type  => 'requires',
          phase => 'develop', },
        'File::Temp' => '0',
        'Test::More' => '0',
    );
}

=pod

=head1 USAGE

Add the following to your F<dist.ini>:

  [Author::HAYOBAAN::HelpTests]

=head1 DESCRIPTION

Adds the author test F<xt/author/help.t>. It checks every Perl script in the
F<bin> directory:

=for :list
* it shows its help with C<--help> and with C<-h>: it exits with status 0,
prints the help on STDOUT, and prints nothing on STDERR;
* it shows its version with C<--version> in the same way. It prints its file
name and the C<$VERSION> of the built script, e.g. C<name 1.000>;
* the first line of its SYNOPSIS is the help line, C<name --help|-h>. The
second line is the version line, C<name --version>. A script named
C<git-name> is a git command, written as C<git name>.

The scripts run with the distribution's F<lib> directory on the module path.

=cut

=for Pod::Coverage gather_files register_prereqs

=cut

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__DATA__
__[ xt/author/help.t ]__
use strict;
use warnings;
use Test::More;

use File::Spec;
use File::Temp;

# Returns the content of a file, also in list context: an empty file gives an
# empty string, not an empty list
sub read_file {
    my ($file) = @_;

    open my $fh, '<', $file or die "Can't read $file: $!";
    my $content = do { local $/ = undef; <$fh> } // '';
    return $content;
}

# Runs the command with STDIN from the null device, and returns its exit
# status and its STDOUT and STDERR output
sub run_capturing {
    my (@command) = @_;

    my $stdout_fh = File::Temp->new;
    my $stderr_fh = File::Temp->new;
    open my $saved_stdin, '<&', \*STDIN or die "Can't save STDIN: $!";
    open my $saved_stdout, '>&', \*STDOUT or die "Can't save STDOUT: $!";
    open my $saved_stderr, '>&', \*STDERR or die "Can't save STDERR: $!";
    open STDIN, '<', File::Spec->devnull or die "Can't open the null device: $!";
    open STDOUT, '>&', $stdout_fh or die "Can't redirect STDOUT: $!";
    open STDERR, '>&', $stderr_fh or die "Can't redirect STDERR: $!";
    my $status = system(@command);
    open STDIN, '<&', $saved_stdin or die "Can't restore STDIN: $!";
    open STDOUT, '>&', $saved_stdout or die "Can't restore STDOUT: $!";
    open STDERR, '>&', $saved_stderr or die "Can't restore STDERR: $!";
    return ($status == -1 ? -1 : $status >> 8, read_file($stdout_fh->filename), read_file($stderr_fh->filename));
}

my @scripts = grep { -f $_ && read_file($_) =~ /\A#!\s*(?:\S*\/env\s+)?\S*perl/ } sort glob('bin/*');
plan skip_all => 'No scripts found' if !@scripts;

plan tests => 5 * @scripts;
for my $script (@scripts) {
    (my $file_name = $script) =~ s{.*/}{};
    (my $name = $file_name) =~ s/^git-/git /;
    my $content = read_file($script);
    my ($synopsis) = $content =~ /^=head1 SYNOPSIS[ \t]*\n(.*?)(?=^=)/ms;
    my ($help_line, $version_line) = map { s/^\s+|\s+$//gr } grep { /\S/ } split(/\n/, $synopsis // '');
    is($help_line // '(no SYNOPSIS found)', "$name --help|-h", "$script: the SYNOPSIS starts with the help line");
    is($version_line // '(no second SYNOPSIS line)', "$name --version", "$script: followed by the version line");
    for my $option ('--help', '-h') {
        my ($status, $stdout, $stderr) = run_capturing($^X, '-Ilib', $script, $option);
        ok($status == 0 && $stdout =~ /\S/ && $stderr eq '', "$script $option shows the help")
            or diag("Exit status: $status\nSTDERR: $stderr");
    }
    my ($version) = $content =~ /^\s*our\s+\$VERSION\s*=\s*['"]?v?([0-9._]+)/m;
    my $expected = "$file_name " . ($version // '(no version declared)') . "\n";
    my ($status, $stdout, $stderr) = run_capturing($^X, '-Ilib', $script, '--version');
    ok($status == 0 && $stdout eq $expected && $stderr eq '', "$script --version shows its version")
        or diag("Expected: ${expected}Exit status: $status\nSTDOUT: ${stdout}STDERR: $stderr");
}
