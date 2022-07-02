#! /usr/bin/perl -w

use strict;
use DBI;

my $database = $ENV{'DB_DATABASE'};
my $user = $ENV{'DB_USER'};
my $password = $ENV{'DB_PASSWORD'};
my $dsn = "DBI:mysql:database=$database";
my $dbh = DBI->connect($dsn, $user, $password);

my $failed = 0;

my $sth = $dbh->prepare(
    'SELECT * from mytable WHERE foo = ?')
    or die "prepare statement failed: $dbh->errstr()";
$sth->execute('asdf') or die "execution failed: $dbh->errstr()";
print $sth->rows . " rows found.\n";
if (1 != $sth->rows) {
    $failed ++;
    print STDERR "'asdf' row not found\n";
}
while (my $ref = $sth->fetchrow_hashref()) {
    print "Found row: foo = $ref->{'foo'}, bar = $ref->{'bar'}\n";
}
$sth->finish;

$sth = $dbh->prepare(
    'SELECT * from mytable WHERE foo = ?')
    or die "prepare statement failed: $dbh->errstr()";
$sth->execute('lmno') or die "execution failed: $dbh->errstr()";
print $sth->rows . " rows found.\n";
if (1 != $sth->rows) {
    $failed ++;
    print STDERR "'lmno' row not found\n";
}
while (my $ref = $sth->fetchrow_hashref()) {
    print "Found row: foo = $ref->{'foo'}, bar = $ref->{'bar'}\n";
}
$sth->finish;

$sth = $dbh->prepare(
    'SELECT * from mytable WHERE foo = ?')
    or die "prepare statement failed: $dbh->errstr()";
$sth->execute('nosuchrow') or die "execution failed: $dbh->errstr()";
print $sth->rows . " rows found.\n";
if (0 != $sth->rows) {
    $failed ++;
    print STDERR "'nosuchrow' row found\n";
}
while (my $ref = $sth->fetchrow_hashref()) {
    print "Found row: foo = $ref->{'foo'}, bar = $ref->{'bar'}\n";
}
$sth->finish;

# goal: check for failed testw

if (0 != $failed) {
    die "Tests failed: ", $failed, "\n";
}
