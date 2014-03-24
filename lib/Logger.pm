package Logger;
use Moose;
#use Moose::Util::TypeConstraints;
use DBI;
use JSON;
use DateTime;
use Env;

=head1 NAME

Logger - Custom logger module for import and export scripts

=head1 VERSION

Version 0.10

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Use this module to log a transaction to a specified database location

Code snippet.

    use Logger;
    
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
  
    my $all = $logger->log_hash(logpath=>$log_path);
=cut

 has 'station' => ( is => 'rw', isa => 'Str', required => 1); 
 has 'keyword' => ( is => 'rw', isa => 'Str', required => 1); 
 has 'logpath' => ( is => 'rw', isa => 'Str', required => 1); 
 has 'status'  => ( is => 'rw', isa => 'Str'); 
 has 'date'  => ( is => 'rw', isa => 'Num'); 
 has 'time'  => ( is => 'rw', isa => 'Num'); 
 has 'errmsg' => ( is => 'rw', isa => 'Str', required => 1); 
 has 'script' => ( is => 'rw', isa => 'Str'); 
 has 'comment' => ( is => 'rw', isa => 'Str'); 
 has 'user' => ( is => 'rw', isa => 'Str', default => $ENV{'USERNAME'} ); 
 
=head1 EXPORT

log()
log_hash()
dev_log()

=head1 SUBROUTINES/METHODS

=head2 new()
  New instance of logger 
=cut

sub log{
  my $self = shift;
  my $sqlite3path = $self->logpath.'Chromicon\\Log.db';
  my $dbh = DBI->connect(          
      "dbi:SQLite:dbname=$sqlite3path", 
      "",                          
      "",                          
      { RaiseError => 1, AutoCommit => 0},         
  ) or die print $DBI::errstr;
  
  my $primary_key = 'PRIMARY KEY (Station, Date, Time, Keyword)';
  $dbh->do("CREATE TABLE IF NOT EXISTS LOG(
    Station   TEXT, 
    Keyword   TEXT, 
    Status    TEXT, 
    Comment   TEXT, 
    Errmsg    TEXT,
    Date      TEXT, 
    Time      TEXT, 
    Script    TEXT,
    User      TEXT,
    $primary_key
  )");
    
  my $sth = $dbh->prepare("INSERT INTO LOG VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ? )");
  my @values = ($self->station, $self->keyword, $self->status, $self->comment, $self->errmsg, $self->date, $self->time, $self->script, $self->user );
  $sth->execute(@values) or die return $sth->errstr;
  $dbh->commit;  
  $dbh->disconnect();
  return 1;    
}

=head2 new()
  Creates a logging database for tracking development 
=cut

sub dev_log{
  my $self = shift;
  my $sqlite3path = $self->logpath.'Chromicon\\DevLog.db';
  my $dbh = DBI->connect(          
      "dbi:SQLite:dbname=$sqlite3path", 
      "",                          
      "",                          
      { RaiseError => 1, AutoCommit => 0},         
  ) or die print $DBI::errstr;
  
  my $primary_key = 'PRIMARY KEY (Script, Date, Time, Keyword)';
  $dbh->do("CREATE TABLE IF NOT EXISTS LOG(
    Script    TEXT,
    Keyword   TEXT, 
    Status    TEXT, 
    Comment   TEXT, 
    Errmsg    TEXT,
    Date      TEXT, 
    Time      TEXT, 
    User      TEXT,
    $primary_key
  )");
    
  my $sth = $dbh->prepare("INSERT INTO LOG VALUES ( ?, ?, ?, ?, ?, ?, ?, ? )");
  my @values = ($self->script, $self->keyword, $self->status, $self->comment, $self->errmsg, $self->date, $self->time, $self->user );
  $sth->execute(@values) or die return $sth->errstr;
  $dbh->commit;  
  $dbh->disconnect();
  return 1;    
}

=head2 log_hash

Return a hash of all logs within the Sqlite database
  
=cut

sub log_hash{
  my $self = shift;
  my $sqlite3path = $self->logpath.'Chromicon\\Log.db';
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

=head1 AUTHOR

Sholto Maud, C<< <sholto.maud at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-logger at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Logger>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Logger


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Logger>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Logger>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Logger>

=item * Search CPAN

L<http://search.cpan.org/dist/Logger/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2014 Sholto Maud.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of Logger
