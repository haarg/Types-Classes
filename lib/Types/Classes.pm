package Types::Classes;
use strict;
use warnings FATAL => 'all';

our $VERSION = '0.001000';
$VERSION = eval $VERSION;

use Type::Utils;
use Type::Library -base;
use Types::Standard -all;
use Type::Params qw(compile);

our @EXPORT_OK;

my $parameterized = compile(ArrayRef[Str], slurpy ArrayRef);

sub InstanceOf {
  my ($params, $rest) = $parameterized->(@_);
  my @types = map { class_type { class => $_ } } @$params;
  my $type = @types == 1 ? $types[0] : union \@types;
  return wantarray ? ($type, @$rest) : $type;
}
push @EXPORT_OK, 'InstanceOf';

sub ConsumerOf {
  my ($params, $rest) = $parameterized->(@_);
  my @types = map { role_type { role => $_ } } @$params;
  my $type = @types == 1 ? $types[0] : intersection \@types;
  return wantarray ? ($type, @$rest) : $type;
}
push @EXPORT_OK, 'ConsumerOf';

sub HasMethods {
  my ($params, $rest) = $parameterized->(@_);
  my $type = duck_type $params;
  return wantarray ? ($type, @$rest) : $type;
}
push @EXPORT_OK, 'HasMethods';

sub Enum {
  my ($params, $rest) = $parameterized->(@_);
  my $type = enum $params;
  return wantarray ? ($type, @$rest) : $type;
}
push @EXPORT_OK, 'Enum';

1;

__END__

=head1 NAME

Types::Classes - Parameterizable types for classes and roles

=head1 SYNOPSIS

  package MyClass;
  use Moo;
  use Types::Classes;

  has attr => (
    is => 'ro',
    isa => InstanceOf['OtherClass'],
  );

=head1 DESCRIPTION



=head1 AUTHOR

haarg - Graham Knop (cpan:HAARG) <haarg@haarg.org>

=head2 CONTRIBUTORS

None so far.

=head1 COPYRIGHT

Copyright (c) 2013 the MooX::InsideOut L</AUTHOR> and L</CONTRIBUTORS>
as listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself.

=cut
