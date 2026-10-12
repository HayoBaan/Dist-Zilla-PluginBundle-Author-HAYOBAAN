use strict;
use warnings;
use utf8;
use Test::More 0.96;
use File::pushd qw/tempd/;
use IPC::Open3;
use Config;
use Path::Tiny;

use Test::DZil;

use Dist::Zilla::Plugin::Author::HAYOBAAN::HelpTests;
use Dist::Zilla::Plugin::Author::HAYOBAAN::PodStructureTests;

# Tests of the bundle's own plugins:
# - a build with @Author::HAYOBAAN adds their author tests
# - ManPages makes the man pages name their manual, version and date
# - CheckCopyrightYear stops a release when the copyright year isn't up to date
# - the generated pod-structure and help tests pass and fail the right files

binmode(Test::More->builder->$_, ':encoding(UTF-8)') for qw(output failure_output todo_output);

my $corpus = path('corpus/DZT')->absolute;
my $current_year = (localtime)[5] + 1900;

# Runs the test script in the directory, and returns a hash with the names of
# its tests that passed (ok) and failed (not ok), and its whole output
sub run_test_script {
    my ($dir, $script) = @_;

    my $wd = File::pushd::pushd($dir);
    open my $stdin, '<', File::Spec->devnull or die "Can't open the null device: $!";
    my $pid = open3($stdin, my $output_fh, undef, $^X, $script);
    binmode($output_fh, ':encoding(UTF-8)');
    my $output = do { local $/ = undef; <$output_fh> } // '';
    waitpid($pid, 0);
    # On Windows the output has CRLF line endings, which would end up in the test names
    $output =~ s/\r\n/\n/g;
    my %result = (ok => [], 'not ok' => [], output => $output);
    while ($output =~ /^(ok|not ok) \d+ - (.*)$/mg) {
        push(@{ $result{$1} }, $2);
    }
    return \%result;
}

# Writes the files (path => content) to a new temporary directory, together
# with the test script the plugin generates, and returns the directory
sub sample_dist {
    my ($plugin, $script, %files) = @_;

    my $dir = Path::Tiny->tempdir;
    $dir->child($script)->touchpath->spew_utf8(${ $plugin->section_data($script) });
    $dir->child($_)->touchpath->spew_utf8($files{$_}) for keys %files;
    $dir->child($_)->chmod(0755) for grep { m{^bin/} } keys %files;
    return $dir;
}

# The OPTIONS section of a script with only --help and --version, and one with
# the given extra items
sub options_pod {
    my (@items) = @_;

    return "=head1 OPTIONS\n\n=over 4\n\n" . join('', map { "=item $_\n\nDoes something.\n\n" }
        ('B<--help>, B<-h>', 'B<--version>', @items)) . "=back\n\n";
}

# Returns the POD of a script or module with the given sections
sub pod {
    my ($name, %options) = @_;

    my $authors = $options{authors} // "=head1 AUTHOR\n\nSome Author (someone at example.com)\n\n";
    my $description = exists $options{description} ? $options{description} : "=head1 DESCRIPTION\n\nDoes something.\n\n";
    my $name_line = $options{name_line} // "$name - Does something";
    my $synopsis = $options{synopsis} // "  $name --help|-h\n\n  $name --version\n\n";
    my $options = $options{options} // '';
    return "=head1 NAME\n\n$name_line\n\n=head1 SYNOPSIS\n\n$synopsis"
        . "$description$options$authors=head1 COPYRIGHT AND LICENSE\n\nThis software is copyright (c) $current_year.\n\n=cut\n";
}

subtest 'the bundle adds the author tests' => sub {
    my $wd = tempd;
    my $tzil = Builder->from_config({ dist_root => "$corpus" });
    $tzil->build;
    my %files = map { ($_->name => 1) } @{ $tzil->files };
    ok($files{$_}, "the build has $_") for qw(xt/author/help.t xt/author/pod-structure.t xt/author/unused-vars-scripts.t);
};

subtest 'ManPages' => sub {
    my $wd = tempd;
    my $tzil = Builder->from_config({ dist_root => 'does-not-exist' }, {
        add_files => {
            'source/dist.ini'          => simple_ini({ version => '0.018' }, 'GatherDir', 'ExecDir', 'MakeMaker',
                'Author::HAYOBAAN::ManPages'),
            'source/lib/Foo.pm'        => "package Foo;\n1;\n\n=head1 NAME\n\nFoo - Does something\n\n=cut\n",
            'source/bin/some_script'   => "#!/usr/bin/env perl\n\n=head1 NAME\n\nsome_script - Does something\n\n=cut\n",
        },
    });
    $tzil->build;
    my $build_dir = path($tzil->tempdir)->child('build');
    my $makefile = $build_dir->child('Makefile.PL')->slurp_utf8;
    like($makefile, qr/^\s+sub manifypods \{/m, 'Makefile.PL gets its own manifypods');
    my @now = localtime;
    my $today = sprintf('%04d-%02d-%02d', $now[5] + 1900, $now[4] + 1, $now[3]);
    like($makefile, qr/^\s+my \$date = '\Q$today\E';$/m, 'with the date of the build fixed in it');
    my $built = File::pushd::pushd($build_dir);
    my $make = $Config::Config{make};
    my $output = `"$^X" Makefile.PL 2>&1 && $make manifypods 2>&1`;
    is($?, 0, 'make manifypods succeeds') or diag($output);
    SKIP: {
        # Perl installations without man directories, such as Strawberry Perl on Windows, make no man pages
        skip 'This perl makes no man pages', 2 if ($Config::Config{installman1dir} // '') =~ /^(?:|none)$/;
        my $th_line = sub { my ($page) = @_; my ($line) = grep { /^\.TH / } path($page)->lines_utf8; return $line // '' };
        like($th_line->('blib/man1/some_script.1'), qr/^\.TH SOME_SCRIPT 1 \Q$today\E "some_script 0\.018" "User Commands"$/,
            'a script has its name in uppercase, and names its manual, its name with the version, and the date');
        like($th_line->((glob('blib/man3/Foo.*'))[0]),
            qr/^\.TH Foo 3(?:pm)? \Q$today\E "Foo 0\.018" "Perl Programmers Reference Guide"$/, 'a module too');
    }
};

subtest 'CheckCopyrightYear' => sub {
    for my $case (
        [ "$current_year",         1, 'the current year' ],
        [ "2015–$current_year",    1, 'a range up to the current year' ],
        [ "2015",                  0, 'an old year' ],
        [ "2015–" . ($current_year - 1), 0, 'a range up to an old year' ],
        [ "2015-$current_year",    0, 'a range with a hyphen' ],
    ) {
        my ($year, $passes, $what) = @$case;
        my $wd = tempd;
        my $tzil = Builder->from_config({ dist_root => 'does-not-exist' }, {
            add_files => {
                'source/dist.ini'   => simple_ini({ copyright_year => $year }, 'GatherDir',
                    'Author::HAYOBAAN::CheckCopyrightYear', 'FakeRelease'),
                'source/lib/Foo.pm' => "package Foo;\n1;\n",
            },
        });
        my $released = eval { $tzil->release; 1 };
        if ($passes) {
            ok($released, "releases with $what") or diag($@);
        } else {
            ok(!$released, "stops the release with $what");
            like($@, qr/copyright_year/, 'and says why');
        }
    }
};

subtest 'the pod-structure test' => sub {
    my $dir = sample_dist('Dist::Zilla::Plugin::Author::HAYOBAAN::PodStructureTests', 'xt/author/pod-structure.t',
        'lib/Good.pm'           => "package Good;\n1;\n\n" . pod('Good'),
        'lib/Listed.pm'         => "package Listed;\n1;\n\n"
            . pod('Listed', authors => "=head1 AUTHORS\n\n=over 4\n\n=item *\n\nSome Author (someone at example.com)\n\n"
                . "=item *\n\nJosé O'Brien\n\n=back\n\n"),
        'lib/NoDescription.pm'  => "package NoDescription;\n1;\n\n" . pod('NoDescription', description => ''),
        'lib/OneOfAuthors.pm'   => "package OneOfAuthors;\n1;\n\n"
            . pod('OneOfAuthors', authors => "=head1 AUTHORS\n\nSome Author\n\n"),
        'lib/RealAddress.pm'    => "package RealAddress;\n1;\n\n"
            . pod('RealAddress', authors => "=head1 AUTHOR\n\nSome Author <someone\@realdomain.nl>\n\n"),
        'bin/some_script'       => "#!/usr/bin/env perl\n\n" . pod('some_script', options => options_pod(
            'B<--target> I<dir>, B<-t> I<dir>', 'B<--[no-]colorize>', 'B<--output>=I<base>'),
            synopsis => "  some_script --help|-h\n\n  some_script --version\n\n  cat file | some_script [--long-option]\n"
                . "      [--other]\n\n"),
        'bin/no_options'        => "#!/usr/bin/env perl\n\n" . pod('no_options'),
        'bin/summary'           => "#!/usr/bin/env perl\n\n" . pod('summary', options => options_pod(),
            synopsis => "  summary --help|-h\n\n  summary --version\n\n  Options:\n    --target  the target\n\n"),
        'bin/bad_items'         => "#!/usr/bin/env perl\n\n" . pod('bad_items', options => options_pod('B<-t>, B<--target>', 'B<--dir> DIR')),
        'bin/no_help_item'      => "#!/usr/bin/env perl\n\n" . pod('no_help_item',
            options => "=head1 OPTIONS\n\n=over 4\n\n=item B<--version>\n\nShows it.\n\n=back\n\n"),
        'lib/DoubleDash.pm'     => "package DoubleDash;\n1;\n\n" . pod('DoubleDash', name_line => 'DoubleDash -- Does something'),
        'lib/Twice.pm'          => "package Twice;\n1;\n\n" . pod('Twice') . "\n=head1 NAME\n\nTwice - Again\n\n=cut\n",
        'lib/StrayItem.pm'      => "package StrayItem;\n1;\n\n" . pod('StrayItem')
            . "\n=head1 SEE ALSO\n\n=over 4\n\n=item *\n\nIn a list\n\n=back\n\n* Outside the list\n\n=cut\n",
        'lib/Paragraphs.pm'     => "package Paragraphs;\n1;\n\n"
            . pod('Paragraphs', authors => "=head1 AUTHORS\n\nSome Author\n\nOther Author\n\n"),
    );
    my $result = run_test_script($dir, 'xt/author/pod-structure.t');
    is_deeply([sort @{ $result->{ok} }], [sort map { "$_ has the standard POD structure" } qw(lib/Good.pm lib/Listed.pm bin/some_script)],
        'complete PODs pass, also with authors as list items, and names with accents') or diag($result->{output});
    is_deeply([sort @{ $result->{'not ok'} }],
        [sort map { "$_ has the standard POD structure" } qw(lib/NoDescription.pm lib/OneOfAuthors.pm lib/Paragraphs.pm lib/RealAddress.pm lib/StrayItem.pm lib/Twice.pm
            bin/no_options bin/summary bin/bad_items bin/no_help_item lib/DoubleDash.pm)],
        'a missing section, a wrong heading, authors not in a list, a real address, a list item outside a list, '
        . 'and a section that appears twice fail');
    like($result->{output}, qr/lib\/StrayItem\.pm: '\* Outside the list' looks like a list item, but isn't in a list/,
        'naming the list item');
    like($result->{output}, qr/lib\/RealAddress\.pm: e-mail address someone\@realdomain\.nl in the POD/, 'naming the address');
    like($result->{output}, qr/bin\/no_options: no OPTIONS section/, 'a script needs an OPTIONS section');
    like($result->{output}, qr/bin\/summary: the SYNOPSIS line 'Options:' isn't a usage line of summary/,
        'a SYNOPSIS holds only usage lines');
    like($result->{output}, qr/bin\/bad_items: the option item 'B<-t>, B<--target>' doesn't have its long form first/,
        'an option item has its long form first');
    like($result->{output}, qr/bin\/bad_items: the option item 'B<--dir> DIR' isn't written as B<--long>, B<-s> I<ARG>/,
        'and its argument in I<>');
    like($result->{output}, qr/bin\/no_help_item: no '=item B<--help>, B<-h>' in the OPTIONS section/, 'there is a help item');
    like($result->{output}, qr/lib\/DoubleDash\.pm: the NAME section isn't 'DoubleDash - what it does'/, 'NAME has a single hyphen');
    unlike($result->{output}, qr/^Use of uninitialized value/m, 'without warnings');
};

subtest 'the help test' => sub {
    # A script with help and version, printing the version with the given code
    my $script = sub {
        my ($name, $version_output) = @_;
        return "#!/usr/bin/env perl\nuse strict;\nuse warnings;\nuse Pod::Usage;\nour \$VERSION = '1.002'; # VERSION\n"
            . "pod2usage(-exitval => 0, -verbose => 2) if \@ARGV && \$ARGV[0] =~ /^(?:--help|-h)\$/;\n"
            . "if (\@ARGV && \$ARGV[0] eq '--version') { print $version_output; exit 0 }\n\n" . pod($name);
    };
    my $dir = sample_dist('Dist::Zilla::Plugin::Author::HAYOBAAN::HelpTests', 'xt/author/help.t',
        'bin/good_script'   => $script->('good_script', '"good_script $VERSION\n"'),
        'bin/sub/sub_script' => $script->('sub_script', '"sub_script $VERSION\n"'),
        'bin/wrong_version' => $script->('wrong_version', '"$VERSION\n"'),
        'bin/no_help'       => "#!/usr/bin/env perl\nwarn \"no help\\n\";\nexit 1;\n\n" . pod('no_help'),
        'bin/no_version_line' => $script->('no_version_line', '"no_version_line $VERSION\n"')
            =~ s/\n  no_version_line --version\n//r,
    );
    my $result = run_test_script($dir, 'xt/author/help.t');
    is_deeply([sort @{ $result->{'not ok'} }],
        [sort('bin/no_help --help shows the help', 'bin/no_help -h shows the help', 'bin/no_help --version shows its version',
            'bin/no_version_line: followed by the version line', 'bin/wrong_version --version shows its version')],
        'a script without help, without the version line, or with a wrong version fails') or diag($result->{output});
    is(scalar @{ $result->{ok} }, 20, 'the other tests pass');
    ok((grep { $_ eq 'bin/sub/sub_script --version shows its version' } @{ $result->{ok} }),
        'also for a script in a subdirectory');
    ok((grep { $_ eq 'bin/good_script --version shows its version' } @{ $result->{ok} }),
        'a script that prints its name and version passes');
    like($result->{output}, qr/Expected: wrong_version 1\.002\n# Exit status: 0\n# STDOUT: 1\.002\n/,
        'a wrong version output shows the expected one');
    unlike($result->{output}, qr/^Use of uninitialized value/m, 'without warnings, also when a script writes nothing to STDERR');
};

done_testing;
