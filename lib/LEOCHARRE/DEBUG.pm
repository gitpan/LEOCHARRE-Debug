package LEOCHARRE::DEBUG;
use strict;
our $VERSION = sprintf "%d.%02d", q$Revision: 1.3 $ =~ /(\d+)/g;

$LEOCHARRE::DEBUG::DEBUG_LEVEL = 1;
$LEOCHARRE::DEBUG::DEBUG = 0;
$LEOCHARRE::DEBUG::_LAST_DEBUG_HAD_NEWLINE=1;

sub DEBUG {
   my $val = ref $_[0] ? $_[1] : $_[0];
   $LEOCHARRE::DEBUG::DEBUG = $val if defined $val;   
   return $LEOCHARRE::DEBUG::DEBUG;
}

sub debug {
   my $val = ref $_[0] ? $_[1] : $_[0];   # so that $self->debug() works like debug()
   DEBUG or return 1;

   if ( !$LEOCHARRE::DEBUG::DEBUG_LEVEL ){
      $val=~/\n$/;
      print STDERR " $val\n";
      return 1;
   }   
   
   my $sub = (caller(1))[3];
   # if used in a script, caller wont be there
   $sub ||= 'main';

   if ($LEOCHARRE::DEBUG::DEBUG_LEVEL == 1){      
   
      $sub=~s/^.*:://; # just want last part
   
   }      

   if( $LEOCHARRE::DEBUG::_LAST_DEBUG_HAD_NEWLINE ){
      print STDERR " $sub(),";
   }
   
   print STDERR " $val";

   $LEOCHARRE::DEBUG::_LAST_DEBUG_HAD_NEWLINE = ( $val=~/\n$/ ? 1 : 0  );
   
   return 1;   
}


sub import {
    ## find out who is calling us
    my $pkg = caller;

    ## while strict doesn't deal with globs, it still
    ## catches symbolic de/referencing
    no strict 'refs';

    ## iterate through all the globs in the symbol table
    foreach my $glob (keys %LEOCHARRE::DEBUG::) {
        ## skip anything without a subroutine and 'import'
        next if not defined *{$LEOCHARRE::DEBUG::{$glob}}{CODE}
                or $glob eq 'import';

        ## assign subroutine into caller's package
        *{$pkg . "::$glob"} = \&{"LEOCHARRE::DEBUG::$glob"};
    }

   # ABUSE CALLING PACKAGE, these are scalars we want
   for (qw(DEBUG _LAST_DEBUG_HAD_NEWLINE DEBUG_LEVEL)){
      my $glob = $_;   
      *{$pkg . "::$glob"} = \${"LEOCHARRE::DEBUG::$glob"};
   }   
    
}










1;

=pod

=head1 NAME

LEOCHARRE::DEBUG - my default debug subroutines

=head1 SYNOPSIS

In A.pm

   package A;
   use LEOCHARRE::DEBUG;
   use strict;


   sub new {
      my $class = shift;
      my $self ={};
      bless $self, $class;
      return $self;   
   }

   sub test {
      my $self = shift;
      DEBUG or return 0;
      return 1;
   }

In script.t

   use Test::Simple 'no_plan';
   use strict;
   use A;

   my $o = new A;

   $A::DEBUG = 1;
   ok( $o->test );

   $A::DEBUG = 0;
   ok( !($o->test) );


=head1 DEBUG()

returns boolean

   print STDERR "oops" if DEBUG;

=head1 debug()

argument is message, will only print to STDERR if  DEBUG is on.

   debug('only show this if DEBUG is on');

If your message argument does not end in a newline, next message will not be prepended with
the subroutine name.

   sub dostuff {
      debug("This is..");

      # ...

      debug("done.\n");

      debug("ok?");      
   }

Would print

   dostuff(), This is.. done.
   dostuff(), ok?



=head1 DESCRIPTION

I want to be able in my code to do this


   package My::Module;
   
   sub run {
      print STDERR "ok\n" if DEBUG;
   }     
   
   
   package main;
   
   $My::Module::DEBUG = 1;
   
   My::Module::run();

And I am tired of coding this

   $My::ModuleName::DEBUG = 0;
   sub DEBUG : lvalue { $My::ModuleName::DEBUG }

Using this module the subroutine DEBUG will return true or false, and it can be set via the
namespace of the package using it.

=head1 NOTES

This package, alike LEOCHARRE::CLI, are under the author's name because the code herein comprises 
his particular mode of work. These modules are used throughout his works, and in no way interfere
with usage of those more general modules.

=head1 DEBUG_LEVEL

Just message and newline:

   $MYMOD::DEBUG_LEVEL = 0;

Show calling sub (default):

   $MYMOD::DEBUG_LEVEL = 1;
   

Show calling full name:

   $MYMOD::DEBUG_LEVEL = 2;

Show tons of garble:

   $MYMOD::DEBUG_LEVEL = 3;   

=head1 SEE ALSO

L<LEOCHARRE::CLI>

=head1 AUTHOR

Leo Charre leocharre at cpan dot org

=cut
