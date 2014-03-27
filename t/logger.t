#!/usr/bin/perl -w
use Test::More tests => 5;
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

  my $file = $logpath.'\\'.$logdb;
  
ok(defined $logger, 'Logger->new() returned something' );
ok($logger->log  , 'log()');
ok($logger->log_hash  , 'dev_log()');
ok(unlink $file,'unlinking file [$file]');
ok(rmdir $logpath,'rmdir temp [$logpath]');

#unlink  $file or warn "Could not unlink $file";
