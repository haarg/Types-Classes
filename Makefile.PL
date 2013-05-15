use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

(do 'maint/Makefile.PL.include' or die $@) unless -f 'META.yml';

WriteMakefile(
  NAME => 'Types::Classes',
  VERSION_FROM => 'lib/Types/Classes.pm',

  PREREQ_PM => {
    'Type::Tiny' => 1.000007,
  },
  'BUILD_REQUIRES' => {
    'Test::More' => 0.94,
  },

  META_MERGE => {
    requires => {
      perl => 5.008001,
    },
    dynamic_config => 0,
    resources => {
      repository => 'git://github.com/haarg/Types-Classes.git',
      homepage => 'http://github.com/haarg/Types-Classes',
    },
  },
);
