package Dist::Zilla::PluginBundle::Author::HAYOBAAN;
use 5.010;                      # For // operator
use strict;
use warnings;

# ABSTRACT: Hayo Baan's Dist::Zilla configuration
# VERSION

=head1 DESCRIPTION

This is a L<Dist::Zilla> PluginBundle. It installs and configures
L<Dist::Zilla> plugins according to HAYOBAAN's preferences. The
following plugins are (conditionally) installed and configured:

=for :list
* L<AutoVersion|Dist::Zilla::Plugin::AutoVersion>
* L<Author::HAYOBAAN::NextVersion|Dist::Zilla::Plugin::Author::HAYOBAAN::NextVersion>
* L<OurPkgVersion|Dist::Zilla::Plugin::OurPkgVersion>
* L<GatherDir|Dist::Zilla::Plugin::GatherDir>
* L<Git::GatherDir|Dist::Zilla::Plugin::Git::GatherDir>
* L<PruneCruft|Dist::Zilla::Plugin::PruneCruft>
* L<ManifestSkip|Dist::Zilla::Plugin::ManifestSkip>
* L<PodWeaver|Dist::Zilla::Plugin::PodWeaver> (and L<SurgicalPodWeaver|Dist::Zilla::Plugin::SurgicalPodWeaver> when enabled)
* L<ReadmeAnyFromPod|Dist::Zilla::Plugin::ReadmeAnyFromPod> (both Text and Markdown generation are configured)
* L<Dist::Zilla::Plugin::MetaYAML>
* L<License|Dist::Zilla::Plugin::License>
* L<InstallGuide|Dist::Zilla::Plugin::InstallGuide>
* L<MinimumPerl|Dist::Zilla::Plugin::MinimumPerl>
* L<AutoPrereqs|Dist::Zilla::Plugin::AutoPrereqs>
* L<MetaNoIndex|Dist::Zilla::Plugin::MetaNoIndex>
* L<GitHub::Meta|Dist::Zilla::Plugin::GitHub::Meta>
* L<MetaJSON|Dist::Zilla::Plugin::MetaJSON>
* L<MetaYAML|Dist::Zilla::Plugin::MetaYAML>
* L<MetaProvides::Package|Dist::Zilla::Plugin::MetaProvides::Package>
* L<MetaProvides::Class|Dist::Zilla::Plugin::MetaProvides::Class>
* L<ExecDir|Dist::Zilla::Plugin::ExecDir>
* L<ShareDir|Dist::Zilla::Plugin::ShareDir>
* L<MakeMaker|Dist::Zilla::Plugin::MakeMaker> (default)
* L<ModuleBuild|Dist::Zilla::Plugin::ModuleBuild> (optional)
* L<Manifest|Dist::Zilla::Plugin::Manifest>
* L<CopyFilesFromBuild|Dist::Zilla::Plugin::CopyFilesFromBuild>
* L<Run::AfterBuild|Dist::Zilla::Plugin::Run::AfterBuild>
* L<GitHubREADME::Badge|Dist::Zilla::Plugin::GitHubREADME::Badge>
* L<CheckChangesHasContent|Dist::Zilla::Plugin::CheckChangesHasContent>
* L<Git::CheckFor::CorrectBranch|Dist::Zilla::Plugin::Git::CheckFor::CorrectBranch>
* L<Git::Check|Dist::Zilla::Plugin::Git::Check>
* L<CheckMetaResources|Dist::Zilla::Plugin::CheckMetaResources>
* L<CheckPrereqsIndexed|Dist::Zilla::Plugin::CheckPrereqsIndexed>
* L<Test::Compile|Dist::Zilla::Plugin::Test::Compile>
* L<Test::Perl::Critic|Dist::Zilla::Plugin::Test::Perl::Critic>
* L<Test::EOL|Dist::Zilla::Plugin::Test::EOL>
* L<Test::NoTabs|Dist::Zilla::Plugin::Test::NoTabs>
* L<Test::Version|Dist::Zilla::Plugin::Test::Version>
* L<Test::MinimumVersion|Dist::Zilla::Plugin::Test::MinimumVersion>
* L<MojibakeTests|Dist::Zilla::Plugin::MojibakeTests>
* L<Test::Kwalitee|Dist::Zilla::Plugin::Test::Kwalitee>
* L<Test::Portability|Dist::Zilla::Plugin::Test::Portability>
* L<Test::UnusedVars|Dist::Zilla::Plugin::Test::UnusedVars>
* L<Test::CPAN::Changes|Dist::Zilla::Plugin::Test::CPAN::Changes>
* L<Test::DistManifest|Dist::Zilla::Plugin::Test::DistManifest>
* L<Test::CPAN::Meta::JSON|Dist::Zilla::Plugin::Test::CPAN::Meta::JSON>
* L<MetaTests|Dist::Zilla::Plugin::MetaTests>
* L<PodSyntaxTests|Dist::Zilla::Plugin::PodSyntaxTests>
* L<PodCoverageTests|Dist::Zilla::Plugin::PodCoverageTests>
* L<Author::HAYOBAAN::LinkCheck|Dist::Zilla::Plugin::Author::HAYOBAAN::LinkCheck>
* L<Test::Synopsis|Dist::Zilla::Plugin::Test::Synopsis>
* L<TestRelease|Dist::Zilla::Plugin::TestRelease>
* L<RunExtraTests|Dist::Zilla::Plugin::RunExtraTests>
* L<ConfirmRelease|Dist::Zilla::Plugin::ConfirmRelease>
* L<UploadToCPAN|Dist::Zilla::Plugin::UploadToCPAN>
* L<FakeRelease|Dist::Zilla::Plugin::FakeRelease>
* L<NextRelease|Dist::Zilla::Plugin::NextRelease>
* L<Git::Commit|Dist::Zilla::Plugin::Git::Commit>
* L<Git::Tag|Dist::Zilla::Plugin::Git::Tag>
* L<Git::Push|Dist::Zilla::Plugin::Git::Push>
* L<GitHub::Update|Dist::Zilla::Plugin::GitHub::Update>
* L<Run::AfterRelease|Dist::Zilla::Plugin::Run::AfterRelease>
* L<Clean|Dist::Zilla::Plugin::Clean>

=head1 USAGE

  # In dist.ini
  [@Author::HAYOBAAN]

=head1 OPTIONS

The following additional command-line option is available for the C<dzil> command.

=head2 --local-release-only

Adding this option to the C<dzil> command will set the
L</local_release_only> attribute to I<true>.

C<--local>, C<--local-only>, and C<--local-release> are synonyms for
this option.

=head2 --make-minor-release

Adding this option to the C<dzil> command will set the
L</make_minor_release> attribute to I<true>.

C<--minor>, C<--minor-release>, and C<--make-minor> are synonyms for
this option.

Note: Implied with L</--local-release-only>, overriden by L</--make-major-release>.

=head2 --make-major-release

Adding this option to the C<dzil> command will set the
L</make_major_release> attribute to true.

C<--major>, C<--major-release>, and C<--make-major> are synonyms for
this option.

Note: Overrides L<--make-minor-release>.

=head2 --keep-version

Adding this option will force keep the version number the same (regardless of the other settings above!).

C<--keep> is a synonym for this option.

=head1 CREDITS

I took inspiration from many people's L<Dist::Zilla> and L<Pod::Weaver> PluginBundles. Most notably from:

=for :list
* David Golden L<DAGOLDEN|Dist::Zilla::PluginBundle::DAGOLDEN>
* Mike Doherty L<DOHERTY|Dist::Zilla::PluginBundle::Author::DOHERTY>

=cut

use Getopt::Long;

use Moose 0.99;
use namespace::autoclean 0.09;
use Dist::Zilla 5.014; # default_jobs
with 'Dist::Zilla::Role::PluginBundle::Easy';

# Required non-core Dist::Zilla plugins:
require Dist::Zilla::Plugin::OurPkgVersion;
require Dist::Zilla::Plugin::Git::GatherDir;
require Dist::Zilla::Plugin::PodWeaver; # And Dist::Zilla::Plugin::SurgicalPodWeaver if enabled
use     Dist::Zilla::Plugin::ReadmeAnyFromPod 0.161150;
require Dist::Zilla::Plugin::MetaYAML;
require Dist::Zilla::Plugin::InstallGuide;
require Dist::Zilla::Plugin::MinimumPerl;
require Dist::Zilla::Plugin::GitHub::Meta;
require Dist::Zilla::Plugin::MetaProvides::Package;
require Dist::Zilla::Plugin::MetaProvides::Class;
require Dist::Zilla::Plugin::CopyFilesFromBuild;
require Dist::Zilla::Plugin::Run;
require Dist::Zilla::Plugin::GitHubREADME::Badge;
require Dist::Zilla::Plugin::CheckChangesHasContent;
require Dist::Zilla::Plugin::Git::CheckFor::CorrectBranch;
require Dist::Zilla::Plugin::Git::Check;
require Dist::Zilla::Plugin::CheckMetaResources;
require Dist::Zilla::Plugin::CheckPrereqsIndexed;
require Dist::Zilla::Plugin::Test::Compile;
require Dist::Zilla::Plugin::Test::Perl::Critic;
require Test::Perl::Critic;
require Dist::Zilla::Plugin::Test::EOL;
require Dist::Zilla::Plugin::Test::NoTabs;
require Dist::Zilla::Plugin::Test::Version;
require Dist::Zilla::Plugin::Test::MinimumVersion;
require Dist::Zilla::Plugin::MojibakeTests;
require Dist::Zilla::Plugin::Test::Kwalitee;
require Dist::Zilla::Plugin::Test::Portability;
require Dist::Zilla::Plugin::Test::UnusedVars;
require Dist::Zilla::Plugin::Test::CPAN::Changes;
require Dist::Zilla::Plugin::Test::DistManifest;
require Dist::Zilla::Plugin::Test::CPAN::Meta::JSON;
require Test::CPAN::Meta::JSON;
require Test::CPAN::Meta;
require Test::Pod::Coverage;
require Pod::Coverage::TrustPod;
require Dist::Zilla::Plugin::Author::HAYOBAAN::LinkCheck;
require Pod::Weaver::PluginBundle::Author::HAYOBAAN;
require Pod::Weaver::Section::Author::HAYOBAAN::Bugs;
require Dist::Zilla::Plugin::Test::Synopsis;
require Dist::Zilla::Plugin::RunExtraTests;
require Dist::Zilla::Plugin::Git::Commit;
require Dist::Zilla::Plugin::Git::Tag;
require Dist::Zilla::Plugin::Git::Push;
require Dist::Zilla::Plugin::GitHub::Update;
require Dist::Zilla::Plugin::Clean;

sub mvp_multivalue_args { return qw(git_remote run_after_build run_after_release additional_test disable_test) }

sub mvp_aliases {
    return {
        local         => "local_release_only",
        local_only    => "local_release_only",
        local_release => "local_release_only",
        minor         => "make_minor_release",
        minor_relase  => "make_minor_release",
        make_minor    => "make_minor_release",
        major         => "make_major_release",
        major_relase  => "make_major_release",
        make_major    => "make_major_release",
    }
}

=for Pod::Coverage mvp_multivalue_args mvp_aliases

=attr is_cpan

Specifies that this is a distribution that is destined for CPAN. When
true, releases are uploaded to CPAN using
L<UploadToCPAN|Dist::Zilla::Plugin::UploadToCPAN>. If false, releases
are made using L<FakeRelease|Dist::Zilla::Plugin::FakeRelease>.

Default: I<false>.

=cut

has is_cpan => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub { $_[0]->payload->{is_cpan} },
);

=attr is_github_hosted

Specifies that the distribution's repository is hosted on GitHub.

Default: I<false> (note: setting L</is_cpan> enforces L</is_github_hosted>
to I<true>)

=cut

has is_github_hosted => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub { $_[0]->payload->{is_github} || $_[0]->is_cpan },
);

=attr git_remote

Specifies where to push the distribution on GitHub. Can be used
multiple times to upload to multiple branches.

Default: C<origin>

=cut

has git_remote => (
    is      => 'ro',
    isa     => 'ArrayRef',
    lazy    => 1,
    default => sub { $_[0]->payload->{git_remote} // [ 'origin' ] },
);

=attr no_git

Specifies that the distribution is not under git version control.

Default: I<false> (note: setting L</is_github_hosted> enforces this
setting to I<false>)

=cut

has no_git => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub { $_[0]->payload->{no_git} && !$_[0]->is_github_hosted },
);

=attr local_release_only

Setting this to I<true> will:

=for :list
* inhibit uploading to CPAN,
* inhibit git checking, tagging, commiting, and pushing,
* inhibit checking the F<Changes> file,
* include a minor version number (e.g., C<_001>) in the version string (see L</make_minor_release>).

When releasing, the L</run_after_release> code is still run so you can
use this flag to I<release> a development version locally for further
use or testing, without e.g., fixing a new major version number.

C<local>, C<local_only>, and C<local_release> are synonyms for
this setting.

Default: I<false>

=cut

has local_release_only => (
    is      => 'rw',
    isa     => 'Bool',
    lazy    => 1,
    default => sub { $_[0]->payload->{local_release_only} }
);

=attr make_minor_release

If the version string does not yet have a minor release number, this will add one with the value of C<_001>.

C<minor>, C<minor_release>, and C<make_minor> are synonyms for this
setting.

Default: value of L</local_release_only>

Note: Overridden by L</make_major_release>.

=cut

has make_minor_release => (
    is      => 'rw',
    isa     => 'Bool',
    lazy    => 1,
    default => sub { exists $_[0]->payload->{make_minor_release} ? $_[0]->payload->{make_minor_release} : $_[0]->local_release_only }
);

=attr make_major_release

Removes any minor version from the version string.

C<major>, C<major_release>, and C<make_major> are synonyms for this
setting.

Default: I<false>

Note: Overrides L</make_minor_release>.

=cut

has make_major_release => (
    is      => 'rw',
    isa     => 'Bool',
    lazy    => 1,
    default => sub { $_[0]->payload->{make_major_release} }
);

=attr keep_version

Will keep the current version number the same when building/releasing.

=cut

has keep_version => (
    is      => 'rw',
    isa     => 'Bool',
    lazy    => 1,
    default => sub { $_[0]->payload->{keep_version} }
);

=attr use_makemaker

Uses MakeMaker as build method.

Default: I<true>

Note: When both C<use_makemaker> and C<use_modulebuild> are I<false>, MakeMaker will be used!

=cut

has use_makemaker => (
    is      => 'rw',
    isa     => 'Bool',
    lazy    => 1,
    default => sub { ($_[0]->payload->{use_makemaker} // 1) || !$_[0]->payload->{use_modulebuild} }
);

=attr use_modulebuild

Uses L<Module::Build> as build method.

Default: I<false>

=cut

has use_modulebuild => (
    is      => 'rw',
    isa     => 'Bool',
    lazy    => 1,
    default => sub { $_[0]->payload->{use_modulebuild} }
);

=attr run_after_build

Specifies commands to run after the release has been built (but not yet released). Multiple
L</run_after_build> commands can be specified.

The commands are run from the root of your development tree and has the following special symbols available:

=for :list
* C<%d> the directory in which the distribution was built
* C<%n> the name of the distribution
* C<%p> path separator ('/' on Unix, '\\' on Win32... useful for cross-platform dist.ini files)
* C<%v> the version of the distribution
* C<%t> -TRIAL if the release is a trial release, otherwise the empty string
* C<%x> full path to the current perl interpreter (like $^X but from Config)

Default: I<nothing>

=cut

has run_after_build => (
    is      => 'ro',
    isa     => 'ArrayRef',
    lazy    => 1,
    default => sub { $_[0]->payload->{run_after_build} // [] },
);

=attr run_after_release

Specifies commands to run after the release has been made. Use it to e.g.,
automatically install your distibution after releasing. Multiple
run_after_release commands can be specified.

The commands are run from the root of your development tree and has
the same symbols available as the L</run_after_build>, plus the
following:

=for :list
* C<%a> the archive of the release

Default: C<cpanm './%d'>

=head3 Examples:

To install using cpanm (this is the default):

  run_after_release = cpanm './%d'

To install using cpan:

  run_after_release = %x -MCPAN -einstall './%d'

To not do anything:

  run_after_release =

=cut

has run_after_release => (
    is      => 'ro',
    isa     => 'ArrayRef',
    lazy    => 1,
    default => sub { exists $_[0]->payload->{run_after_release} ? $_[0]->payload->{run_after_release} : [ 'cpanm ./%d' ] },
);

=attr additional_test

Additional test plugin to use. Can be used multiple times to add more
than one additional test.

By default the following tests are executed:

=for :list
* L<Test::Compile|Dist::Zilla::Plugin::Test::Compile> -- Checks if perl code compiles correctly
* L<Test::Perl::Critic|Dist::Zilla::Plugin::Test::Perl::Critic> -- Checks Perl source code for best-practices
* L<Test::EOL|Dist::Zilla::Plugin::Test::EOL> -- Checks line endings
* L<Test::NoTabs|Dist::Zilla::Plugin::Test::NoTabs> -- Checks for the use of tabs
* L<Test::Version|Dist::Zilla::Plugin::Test::Version> -- Checks to see if each module has the correct version set
* L<Test::MinimumVersion|Dist::Zilla::Plugin::Test::MinimumVersion> -- Checks the minimum perl version, using L</max_target_perl>
* L<MojibakeTests|Dist::Zilla::Plugin::MojibakeTests> -- Checks source encoding
* L<Test::Kwalitee|Dist::Zilla::Plugin::Test::Kwalitee> -- Checks the Kwalitee
* L<Test::Portability|Dist::Zilla::Plugin::Test::Portability> -- Checks portability of code
* L<Test::UnusedVars|Dist::Zilla::Plugin::Test::UnusedVars> -- Checks for unused variables
* L<Test::CPAN::Changes|Dist::Zilla::Plugin::Test::CPAN::Changes> -- Validation of the Changes file
* L<Test::DistManifest|Dist::Zilla::Plugin::Test::DistManifest> -- Validation of the MANIFEST file
* L<Test::CPAN::Meta::JSON|Dist::Zilla::Plugin::Test::CPAN::Meta::JSON> -- Validation of the META.json file -- only when hosted on GitHub
* L<MetaTests|Dist::Zilla::Plugin::MetaTests> -- Validation of the META.yml file -- only when hosted on GitHub
* L<PodSyntaxTests|Dist::Zilla::Plugin::PodSyntaxTests> -- Checks pod syntax
* L<PodCoverageTests|Dist::Zilla::Plugin::PodCoverageTests> -- Checks pod coverage
* L<LinkCheck|Dist::Zilla::Plugin::Author::HAYOBAAN::LinkCheck> -- Checks pod links
* L<Test::Synopsis|Dist::Zilla::Plugin::Test::Synopsis> -- Checks the pod synopsis

=cut

has additional_test => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    lazy    => 1,
    default => sub { $_[0]->payload->{additional_test} // [] },
);

=attr disable_test

Specifies the test you don't want to be run. Can bu used more than
once to disable multiple tests.

Default: I<none> (i.e., run all default and L</additional_test> tests).

=cut

has disable_test => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    lazy    => 1,
    default => sub { $_[0]->payload->{disable_test} // [] },
);

=attr max_target_perl

Defines the highest minimum version of perl you intend to require.
This is passed to L<Test::MinimumVersion|Dist::Zilla::Plugin::Test::MinimumVersion>, which generates
a F<minimum-version.t> test that'll warn you if you accidentally used features
from a higher version of perl than you wanted. (Having a lower required version
of perl is okay.)

Default: C<5.006>

=cut

has max_target_perl => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { $_[0]->payload->{max_target_perl} // '5.006' },
);

=attr surgical

If this is set to I<true>,
L<SurgicalPodWeaver|Dist::Zilla::Plugin::SurgicalPodWeaver> is used
instead of the standard L<PodWeaver|Dist::Zilla::Plugin::PodWeaver>
plugin. L<SurgicalPodWeaver|Dist::Zilla::Plugin::SurgicalPodWeaver>
only munges files that contain either a C<# ABSTRACT> or a C<#
Dist::Zilla: +PodWeaver> line.

Default: I<false>

=cut

has surgicalpod => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { $_[0]->payload->{surgicalpod} // 0 },
);

=attr weaver_config

Specifies the configuration for L<Pod::Weaver>.

Default: C<@Author::HAYOBAAN>.

=cut

has weaver_config => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { $_[0]->payload->{weaver_config} // '@Author::HAYOBAAN' },
);

=attr tag_format

Specifies the format for tagging a release (see
L<Git::Tag|Dist::Zilla::Plugin::Git::Tag> for details).

Default: C<v%v%t>

=cut

has tag_format => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { $_[0]->payload->{tag_format} // 'v%v%t' },
);

=attr version_regexp

Specifies the regexp for versions (see
L<Git::NextVersion|Dist::Zilla::Plugin::Git::NextVersion> for details).

Default: C<^v?([\d.]+(?:_\d+)?)(?:-TRIAL)?$>

Note: Only used in case of git version controlled repositories
(L<AutoVersion|Dist::Zilla::Plugin::AutoVersion> is used in case of
non-git version controlled repositories).

=cut

has version_regexp => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { $_[0]->payload->{version_regexp} // '^v?([\d.]+(?:_\d+)?)(?:-TRIAL)?$' },
);

################################################################################

# List of files to copy to the root after they were built.
has copy_build_files => (
    is  => 'ro',
    isa => 'ArrayRef[Str]',
    lazy => 1,
    default => sub { [ ($_[0]->use_modulebuild ? qw(Build.PL) : ()),
                       ($_[0]->use_makemaker ? qw(Makefile.PL) : ()),
                       qw(README README.mkdn) ] },
);

# Files to exclude from gatherer
has exclude_files => (
    is  => 'ro',
    isa => 'ArrayRef[Str]',
    lazy => 1,
    default => sub { [
        @{$_[0]->copy_build_files},
        qw(MANIFEST),
    ] },
);

# Files that can be "dirty"
has allow_dirty => (
    is  => 'ro',
    isa => 'ArrayRef[Str]',
    lazy => 1,
    default => sub { [
        @{$_[0]->copy_build_files},
        qw(dist.ini Changes),
    ] },
);

# Directories that should not be indexed
has meta_no_index_dirs => (
    is  => 'ro',
    isa => 'ArrayRef[Str]',
    lazy => 1,
    default => sub { [ qw(corpus) ] },
);

sub _is_disabled {
    my $self = shift;
    my $plugin = shift;
    return grep { $_ eq $plugin } @{$self->disable_test}
}

# Helper function to add a test, checks for disabled tests
sub _add_test {
    my $self = shift;
    return grep { ! $self->_is_disabled(ref $_ ? $_->[0] : $_) } @_;
}

=for Pod::Coverage configure

=cut

# Returns the value of a boolean command-line option
sub getBooleanCommandlineOption {
    my $option = $_[0];
    my @result = grep { /^--?(no-)?$option$/ } @ARGV;
    return @result ? $result[$#result] !~ /^--?no-/ : undef;
}

sub configure {
    my $self = shift;

    {
        # Command-line argument processing

        # Local-relase-only
        my $local = getBooleanCommandlineOption('local|local-only|local-release|local-release-only');
        $self->local_release_only($local) if defined $local;

        # Make-minor-release
        my $minor = getBooleanCommandlineOption('minor|minor-relase|make-minor|make-minor-release');
        $self->make_minor_release($minor) if defined $minor;

        # Make-major-release
        my $major = getBooleanCommandlineOption('major|major-relase|make-major|make-major-release');
        $self->make_major_release($major) if defined $major;

        # Keep-version
        my $keep = getBooleanCommandlineOption('keep|keep-version');
        $self->keep_version($keep) if defined $keep;
    }

    return $self->add_plugins(
        #### Version ####
        $self->no_git ? (
            # Provide automatic version based on date
            'AutoVersion'
        ) : (
            # Provide a version number by bumping the last git release tag
            [
                'Author::HAYOBAAN::NextVersion' => {
                    first_version         => '0.001',                    # First version = 0.001
                    version_by_branch     => 0,                          # Set to 1 if doing maintenance branch
                    version_regexp        => $self->version_regexp,      # Regexp for version format
                    include_minor_version => $self->make_minor_release,  # Minor release?
                    remove_minor_version  => $self->make_major_release,  # Force major release?
                    keep_version          => $self->keep_version,        # Keep release number?
                },
            ],
        ),

        # Adds version to file (no line insertion, using our)
        'OurPkgVersion',

        #### Gather & Prune ####
        # Gather files to include
        [ $self->no_git ? 'GatherDir' : 'Git::GatherDir' => { exclude_filename => $self->exclude_files } ],
        # Remove cruft
        'PruneCruft',
        # Skip files in MANIFEST.SKIP
        'ManifestSkip',

        #### PodWeaver ####
        # Automatically extends POD
        [
            ($self->surgicalpod ? 'SurgicalPodWeaver' : 'PodWeaver') => {
                config_plugin      => $self->weaver_config,
                replacer           => 'replace_with_comment',
                post_code_replacer => 'replace_with_nothing',
            }
        ],

        #### Distribution Files & Metadata ####
        # Create README and README.mkdn from POD
        [ 'ReadmeAnyFromPod', 'Text' ],
        [ 'ReadmeAnyFromPod', 'Markdown' ],

        $self->is_github_hosted ? (
            # Create a LICENSE file
            'License',
            # Create an INSTALL file
            'InstallGuide',
        ) : (),

        # Automatically determine minimum perl version
        'MinimumPerl',
        # Automatically determine prerequisites
        'AutoPrereqs',

        # Do not index certain dirs",
        [ 'MetaNoIndex' => { dir => $self->meta_no_index_dirs } ],

        $self->is_github_hosted ? (
            # Add GitHub metadata",
            'GitHub::Meta',
            # Add META.json",
            'MetaJSON',
            # Add META.yml",
            'MetaYAML',
            # Add provided Packages to META.*",
            'MetaProvides::Package',
            # Add provided Classes to META.*",
            'MetaProvides::Class',
        ) : (),

        #### Build System ####
        # Install content of bin directory as executables
        'ExecDir',
        # Install content of share directory as sharedir
        'ShareDir',
        $self->use_makemaker ? (
            # Build a Makefile.PL that uses ExtUtils::MakeMaker
            [ 'MakeMaker', { default_jobs => 9 } ],
        ) : (),
        $self->use_modulebuild ? (
            # Build a Build.PL that uses Module::Build
            'ModuleBuild',
        ) : (),

        # Add Manifest
        'Manifest',

        #### After Build ####
        # Copy/move specific files after building them
        [ 'CopyFilesFromBuild' => { copy => $self->copy_build_files } ],

        @{$self->run_after_build} ? (
            # Run specified commands
            [ 'Run::AfterBuild' => { run => $self->run_after_build } ],
        ) : (),

        $self->is_github_hosted && $self->is_cpan ? (
            # Add status badges to README.mkdn
            [ 'GitHubREADME::Badge' => { ':version' => '0.16', badges => [ qw(cpants) ] } ],
        ) : (),

        #### Before Release Tests ####
        !$self->local_release_only ? (
            # Check if Changes file has content
            'CheckChangesHasContent',
        ) : (),

        !$self->no_git && !$self->local_release_only ? (
            # Check if we're on the correct git branch
            'Git::CheckFor::CorrectBranch',
            # Check git repository for uncommitted files before releasing
            [ 'Git::Check' => { allow_dirty => $self->allow_dirty } ],
            $self->is_cpan ? (
                # Check resources section of meta files
                'CheckMetaResources',
                # Check if prereqs are available on CPAN
                'CheckPrereqsIndexed',
            ) : (),
        ) : (),

        # Extra test (gatherdir)
        # Checks if perl code compiles correctly
        $self->_add_test('Test::Compile'),

        # Extra tests (author)
        # Checks Perl source code for best-practices
        $self->_add_test('Test::Perl::Critic'),
        # Checks line endings
        $self->_add_test('Test::EOL'),
        # Checks for the use of tabs
        $self->_add_test('Test::NoTabs'),

        # Extra tests (release)
        # Checks to see if each module has the correct version set
        $self->_add_test('Test::Version'),
        # Checks the minimum perl version
        $self->_add_test([ 'Test::MinimumVersion' => { max_target_perl => $self->max_target_perl } ]),
        # Checks source encoding
        $self->_add_test('MojibakeTests'),
        # Checks the Kwalitee
        $self->_add_test([ 'Test::Kwalitee' => { $self->is_github_hosted ? () : (skiptest => [ qw(has_meta_yml) ]) } ]),
        # Checks portability of code
        $self->_add_test('Test::Portability'),
        # Checks for unused variables
        $self->_add_test('Test::UnusedVars'),
        !$self->local_release_only ? (
            # Validation of the Changes file
            $self->_add_test('Test::CPAN::Changes'),
        ) : (),
        # Validation of the MANIFEST file
        $self->_add_test('Test::DistManifest'),

        $self->is_github_hosted ? (
            # Validation of the META.json file
            $self->_add_test('Test::CPAN::Meta::JSON'),
            # Validation of the META.yml file
            $self->_add_test('MetaTests'),
        ) : (),

        # Checks pod syntax
        $self->_add_test('PodSyntaxTests'),
        # Checks pod coverage
        $self->_add_test('PodCoverageTests'),
        # Checks pod links
        $self->_add_test('Author::HAYOBAAN::LinkCheck'),
        # Checks the pod synopsis
        $self->_add_test('Test::Synopsis'),

        # Add the additional tests specified
        @{$self->additional_test} ? $self->_add_test(@{$self->additional_test}) : (),

        #### Run tests ####
        # Run provided tests in /t directory before releasing
        'TestRelease',
        # Run the extra tests
        [ 'RunExtraTests' => { default_jobs => 9 } ],

        #### Release ####
        !$self->local_release_only ? (
            # Prompt for confirmation before releasing
            'ConfirmRelease',
        ) : (),
        $self->is_cpan && !$self->local_release_only ? (
            # Upload release to CPAN,
            'UploadToCPAN',
        ) : (
            # Fake release
            'FakeRelease',
        ),

        #### After release ###
        !$self->local_release_only ? (
            # Update the next release number in the changelog
            [ 'NextRelease' => { format => '%-9v %{yyyy-MM-dd}d' } ],
        ) : (),

        !$self->no_git && !$self->local_release_only ? (
            # Commit dirty files
            [ 'Git::Commit' => { allow_dirty => $self->allow_dirty } ],
            # Tag the new version
            [
                'Git::Tag' => {
                    tag_format  => $self->tag_format,
                    tag_message => 'Released ' . $self->tag_format,
                }
            ],
        ) : (),

        $self->is_github_hosted && @{$self->git_remote} && !$self->local_release_only ? (
            # Push current branch
            [ 'Git::Push', { push_to => $self->git_remote } ],
        ) : (),

        $self->is_cpan && !$self->local_release_only ? (
            # Update GitHub repository info on release
            [ 'GitHub::Update' => { metacpan => 1 } ]
        ) : (),

        @{$self->run_after_release} ? (
            # Install the release
            [ 'Run::AfterRelease' => { run => $self->run_after_release } ],
        ) : (),

        # Cleanup
        'Clean',
    );
}

__PACKAGE__->meta->make_immutable;
1;
