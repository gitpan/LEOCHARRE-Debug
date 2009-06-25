package LEOCHARRE::Debug;
use strict;
use vars qw($VERSION @ISA $DEBUG @EXPORT);
use Exporter;
use Carp;
$VERSION = sprintf "%d.%02d", q$Revision: 1.2 $ =~ /(\d+)/g;
@ISA = qw/Exporter/;
@EXPORT = qw/$DEBUG &debug &warnf/;
$DEBUG = 0;


=pod

sub import {
   my $caller = scalar(caller);
   no strict 'refs';
   my ($name_debug_flag, $name_debug_sub) = ("$caller\:\:DEBUG", "$caller\:\:debug");
   *{$name_debug_flag} = 0;
   *{$name_debug_sub} = sub { $DEBUG or return 1; printf STDERR "%s() @_\n", (caller(1))[3] };
}
=cut


sub debug { $DEBUG or return 1; printf STDERR "%s() @_\n", (caller(1))[3] };

sub warnf;
sub warnf { 
   my $msg = sprintf +shift, @_;
   if( $msg!~/\n$/ ){
      $msg.= sprintf " at %s line %s\n", (caller(0))[1], (caller(0))[2] ;
   }
   print STDERR $msg;
}





#3 at lib/LEOCHARRE/Debug.pm line 27.




1;

__END__

=pod

=head1 NAME

LEOCHARRE::Debug - debug sub

=head1 SYNOPSIS

   use LEOCHARRE::Debug;

   debug('hey there');

   warnf '%s %s %s\n', 'this', 'is', 'a value';

=head1 SUBS

Exported.

=head2 debug()

=head2 warnf()

Works like 

   warn sprintf '', @args


=head1 CAVEATS

=head1 AUTHOR

Leo Charre leocharre at cpan dot org

=head1 LICENSE

This package is free software; you can redistribute it and/or modify it under the same terms as Perl itself, i.e., under the terms of the "Artistic License" or the "GNU General Public License".

=head1 DISCLAIMER

This package is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the "GNU General Public License" for more details.

=cut

