use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'LEOCHARRE::Debug',
   VERSION_FROM => 'lib/LEOCHARRE/Debug.pm',
   

   # gen /usr/bin/pmused by Fri May  1 15:33:03 EDT 2009 
   PREREQ_PM => {
      'Carp'                              => '1',
      'Cwd'                               => '3',
      'Exporter'                          => '5',
      'Test::Simple'                      => '0',
   },

   
   LICENSE => 'perl',
   
   
   
   EXE_FILES => [],
);


