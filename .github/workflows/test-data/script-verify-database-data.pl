#! /usr/bin/perl -w

use strict;
use DBI;

my $database = $ENV{'DB_DATABASE'};
my $user = $ENV{'DB_USER'};
my $password = $ENV{'DB_PASSWORD'};
my $dsn = "DBI:mysql:database=$database";
my $dbh = DBI->connect($dsn, $user, $password);

my $sth = $dbh->prepare(
    'SELECT * from mytable WHERE foo = ?')
    or die "prepare statement failed: $dbh->errstr()";
$sth->execute() or die "execution failed: $dbh->errstr()";
print $sth->rows . " rows found.\n";
while (my $ref = $sth->fetchrow_hashref()) {
    print "Found row: id = $ref->{'id'}, fn = $ref->{'first_name'}\n";
}
$sth->finish;
