#!/usr/bin/perl
use strict;
use warnings;

die "Usage: input.csv output.sql\n" unless (@ARGV==2);

print "What would you like to name the database?: ";
my $db = <STDIN>;
chomp $db;

print "What would you like to name the table?: ";
my $table = <STDIN>;
chomp $table;
print "Working...";

open FILE, "<$ARGV[0]";
my @lines = <FILE>;
close FILE;
my $temp = shift @lines;
my @fields = split ",", $temp;
for (@fields) {$_ =~ s/ /_/g;}
chomp $fields[@fields-1];
my $sql = "";

$sql = $sql."CREATE DATABASE \`$db\`;\n";
$sql = $sql."USE \`$db\`;\n";
$sql = $sql."CREATE TABLE \`$table\` (\n";
for (@fields)
{
  $sql = $sql."\t\`$_\` TEXT,\n";
}
chop $sql;
chop $sql;
$sql = $sql."\n";
$sql = $sql.");\n";

for (@lines)
{
  chomp $_;
  my @values = split ",", $_;
  my $valuesString = "";
  for(@values) {$valuesString = $valuesString."\"$_\",";}
  chop $valuesString;
  
  $sql = $sql."INSERT INTO `$table` VALUES ($valuesString);\n";
}

$sql = $sql."SHOW WARNINGS;";

open FILE, ">$ARGV[1]";
print FILE $sql;
close FILE;

print "done!\n";
exit(0);