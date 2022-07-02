#! /usr/bin/perl -w

use strict;
use DBI;

my $database = $ENV{'DB_DATABASE'};
my $user = $ENV{'DB_USER'};
my $password = $ENV{'DB_PASSWORD'};
my $dsn = "DBI:mysql:database=$database";
my $dbh = DBI->connect($dsn, $user, $password);

my $failed = 0;

sub look_for_row_foo($);

my $row_count = look_for_row_foo('asdf');
if (1 != $row_count) {
    $failed ++;
    print STDERR "'asdf' row not found\n";
}


# goal: check for failed testw

if (0 != $failed) {
    die "Tests failed: ", $failed, "\n";
}


sub look_for_row_foo() {

    my $foo = shift;

    print "looking for $foo\n";
    my $sth = $dbh->prepare(
        'SELECT * from mytable WHERE foo = ?')
        or die "prepare statement failed: $dbh->errstr()";
    $sth->execute($foo) or die "execution failed: $dbh->errstr()";
    my $row_count = $sth->rows;
    while (my $ref = $sth->fetchrow_hashref()) {
        print "Found row: foo = $ref->{'foo'}, bar = $ref->{'bar'}\n";
    }
    $sth->finish;

    return  $row_count;
}
