use strict;
use ExtUtils::MakeMaker;

WriteMakefile (
  AUTHOR        => 'Casey West <casey@geeknest.com>',
  ABSTRACT      => "Reply to a Message",
  NAME          => 'Email::Reply',
  (eval { ExtUtils::MakeMaker->VERSION(6.21) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM     => {
    'Email::Abstract' => '2.01',
    'Email::Address'  => '1.80',
    'Email::MIME'     => '1.82',
    'Test::More'      => '0.47',
    'Email::MIME::Creator' => '1.41',
    'Email::MIME::Modifier' => '1.42',
  },
  VERSION_FROM  => 'lib/Email/Reply.pm',
);
