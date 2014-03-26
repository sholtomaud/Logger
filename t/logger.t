#!/usr/bin/perl -w
use Test::More tests => 3;
use Logger;

  my $site    = 'testsite';
  my $comment = 'imported somethink';
  my $status  = 'ok';
  my $keyword = 'IMPTEST';
  my $errmsg  = 'Error message test';

  my $logger = Logger->new( 
    station => $site,
    comment => $comment,
    status  => $status,
    keyword => $keyword,
    script  => $0,
    errmsg  => $errmsg,
    user    => 'USER'
  );

ok( defined $logger, 'Logger->new() returned something' );
ok($logger->log  , 'log()');
ok($logger->log_hash  , 'dev_log()');


