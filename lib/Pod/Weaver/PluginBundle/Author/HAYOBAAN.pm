package Pod::Weaver::PluginBundle::Author::HAYOBAAN;
use strict;
use warnings;

# ABSTRACT: HAYOBAAN's Pod::Weaver configuration
# VERSION

=head1 DESCRIPTION

This is a L<Pod::Weaver> PluginBundle, set up according to HAYOBAAN's
preferences.

It's main features are:

=begin :list

* Specific sequence of headings

* Region collectors for:

=for :list
* requires (Requirements)
* var (Variables)
* func (Functions)
* c_attr (Class Attributes)
* attr (Attributes)
* construct (Constructors)
* c_method (Class Methods)
* method (Methods)

* Replacing the original pod statements with comments, allowing line
  numbers to stay the same between development and build versions.

=end :list

It is roughly equivalent to the following weaver.ini:

  [@CorePrep]

  [-SingleEncoding]
  [-Transformer]
  transformer = List

  [Name]
  [Version]

  [Region / prelude]

  [Generic / SYNOPSIS]
  [Generic / DESCRIPTION]
  [Generic / OVERVIEW]
  [Generic / USAGE]
  [Generic / OPTIONS]

  [Collect / REQUIREMENTS]
  command = requires

  [Collect / VARIABLES]
  command = var

  [Collect / FUNCTIONS]
  command = func

  [Collect / CLASS ATTRIBUTES]
  command = c_attr

  [Collect / ATTRIBUTES]
  command = attr

  [Collect / CONSTRUCTORS]
  command = construct

  [Collect / CLASS METHODS]
  command = c_method

  [Collect / METHODS]
  command = method

  [Leftovers]

  [Region /postlude]

  [Bugs]
  [Generic / STABILITY]
  [Generic / COMPATIBILITY]
  [Generic / SEE ALSO]
  [Generic / CREDITS]
  [Authors]
  [Legal]

=head1 USAGE

Add the following line to your F<weaver.ini>:

  [@Author::HAYOBAAN]

or, these lines to your F<dist.ini> file:

  [PodWeaver]
  config_plugin = @Author::HAYOBAAN

Alternatively you can also add the following line to your F<dist.ini>
(this will also enable HAYOBAAN's L<Dist::Zilla> setup):

  [@Author::HAYOBAAN]


=head1 SEE ALSO

=for :list
* L<Pod::Weaver>
* L<Pod::Elemental::Transformer::List>
* L<Pod::Elemental::PerlMunger>
* L<Pod::Weaver::Section::Bugs>
* L<Dist::Zilla::Plugin::PodWeaver>

=for Pod::Coverage mvp_bundle_config

=cut

use Pod::Weaver::Config::Assembler;
sub _exp { return Pod::Weaver::Config::Assembler->expand_package( $_[0] ) }

# Required non-core Pod Weaver modules
use Pod::Elemental::Transformer::List ();
use Pod::Elemental::PerlMunger ();

sub mvp_bundle_config {
    my @plugins;
    push @plugins, (
        [ '@HAYOBAAN/CorePrep',       _exp('@CorePrep'),       {} ],

        [ '@HAYOBAAN/SingleEncoding', _exp('-SingleEncoding'), {} ],
        [ '@HAYOBAAN/List',           _exp('-Transformer'),    { 'transformer' => 'List' } ],

        [ '@HAYOBAAN/Name',           _exp('Name'),            {} ],
        [ '@HAYOBAAN/Version',        _exp('Version'),         {} ],

        [ '@HAYOBAAN/Prelude',        _exp('Region'),          { region_name => 'prelude' } ],

        [ '@HAYOBAAN/Synopsis',       _exp('Generic'),         { header      => 'SYNOPSIS' } ],
        [ '@HAYOBAAN/Description',    _exp('Generic'),         { header      => 'DESCRIPTION' } ],
        [ '@HAYOBAAN/Overview',       _exp('Generic'),         { header      => 'OVERVIEW' } ],
        [ '@HAYOBAAN/Usage',          _exp('Generic'),         { header      => 'USAGE' } ],
        [ '@HAYOBAAN/Options',        _exp('Generic'),         { header      => 'OPTIONS' } ],
    );

    for my $plugin (
        [ 'Requirements',     _exp('Collect'), { command => 'requires' } ],
        [ 'Variables',        _exp('Collect'), { command => 'var' } ],
        [ 'Functions',        _exp('Collect'), { command => 'func' } ],
        [ 'Class Attributes', _exp('Collect'), { command => 'c_attr' } ],
        [ 'Attributes',       _exp('Collect'), { command => 'attr' } ],
        [ 'Constructors',     _exp('Collect'), { command => 'construct' } ],
        [ 'Class Methods',    _exp('Collect'), { command => 'c_method' } ],
        [ 'Methods',          _exp('Collect'), { command => 'method' } ],
    ) {
        $plugin->[2]{header} = uc $plugin->[0];
        push @plugins, $plugin;
    }

    push @plugins, (
        [ '@HAYOBAAN/Leftovers',      _exp('Leftovers'),       {} ],

        [ '@HAYOBAAN/postlude',       _exp('Region'),          { region_name => 'postlude' } ],

        [ '@HAYOBAAN/Bugs',           _exp('Bugs'),            {} ],

        [ '@HAYOBAAN/Stability',      _exp('Generic'),         { header      => 'STABILITY' } ],
        [ '@HAYOBAAN/Compatibility',  _exp('Generic'),         { header      => 'COMPATIBILITY' } ],

        [ '@HAYOBAAN/SeeAlso',        _exp('Generic'),         { header      => 'SEE ALSO' } ],
        [ '@HAYOBAAN/Credits',        _exp('Generic'),         { header      => 'CREDITS' } ],

        [ '@HAYOBAAN/Authors',        _exp('Authors'),         {} ],
        [ '@HAYOBAAN/Legal',          _exp('Legal'),           {} ],
      );

    return @plugins;
}

1;
