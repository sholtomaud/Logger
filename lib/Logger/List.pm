package Logger::List;
use Moose;
#use Moose::Util::TypeConstraints;
use DBI;
use DateTime;
use Env;

extends 'Logger';

=head1 List

Custom list module 

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Use this module to list records in the dev db

Code snippet.

  use Logger::List;
  
  my $logger = Logger->new( 
    logpath=> $log_path,
    station => $site,
    date    => substr (NowString(), 0, 8 ),
    time    => substr (NowString(), 8, 6 ),
    comment => $comment,
    status  => $status,
    keyword => $keyword,
    errmsg  => $errmsg
  );

  $logger->log;
     
=cut

=head2 list

Return a list of all logs 
  
=cut

sub list{
  my $self = shift;
  #my $sqlite3path = $self->logpath.'Chromicon\\Log.db';
  my $sqlite3path = $self->logpath;
  print "connecting for find\n";
  my $dbh = DBI->connect(          
      "dbi:SQLite:dbname=$sqlite3path", 
      "",                          
      "",                          
      { RaiseError => 1, AutoCommit => 0},         
  ) or die print $DBI::errstr;
  print "preparing\n";
  my $sth = $dbh->prepare("SELECT * FROM LOG");
  $sth->execute;
  my $hash_ref = $sth->fetchall_hashref( [ qw(Station Keyword Date Time) ]);
  return $hash_ref;
 
  
}
