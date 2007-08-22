package inherit_debug;
use lib './lib';
use LEOCHARRE::DEBUG;
use strict;


sub new {

   my $class = shift;
   my $self ={};
   bless $self, $class;
   return $self;   
}

sub debug_is_on {
   my $self = shift;
   debug("as func\n");
   $self->debug("as method\n");
   DEBUG or return 0;
   return 1;
}




1;
