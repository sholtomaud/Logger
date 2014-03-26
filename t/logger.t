#!/usr/bin/perl -w
use Test::More tests => 3;
use Logger;
use FindBin qw($Bin);
use File::Path 'rmtree';

  my $site    = 'testsite';
  my $comment = 'imported somethink';
  my $status  = 'ok';
  my $keyword = 'IMPTEST';
  my $errmsg  = 'Error message test';
  my $logpath = $Bin.'\\db';
  my $logdb = 'Log.db';
    
  mkdir $logpath if (! -d $logpath ) ;
  
  my $logger = Logger->new( 
    logpath => $logpath,
    logdb => $logdb,
    station => $site,
    comment => $comment,
    status  => $status,
    keyword => $keyword,
    script  => $0,
    errmsg  => $errmsg,
    user    => 'USER'
  );

ok(defined $logger, 'Logger->new() returned something' );
ok($logger->log  , 'log()');
ok($logger->log_hash  , 'dev_log()');

my $file = $logpath.'\\'.$logdb;
unlink  $file or warn "Could not unlink $file";
rmdir $logpath;
