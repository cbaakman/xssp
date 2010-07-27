#!perl

use strict;
use warnings;

my $dir = shift;
$dir = "." unless defined $dir;

my %skip = map { $_ => 1 } ( '.', '..', '.svn', 'mkmat_h.pl', 'matrices.h' );

opendir(my $d, $dir) or die "kon dir $dir niet openen: $!\n";
my @m = grep { not $skip{$_} } readdir($d);
closedir($d);

open(my $out, ">$dir/matrices.h") or die "kon matrices.h bestand niet aanmaken: $!\n";

print $out
	"// Matrices as const char strings, generated by mkmat_h.pl using\n",
	"// '$dir' as input directory\n",
	"\n";

foreach my $mat (@m) {
	open(my $fh, "<$dir/$mat") or die "kon matrix $mat niet openen: $!\n";
	local($/) = undef;
	my $text = <$fh>;
	close($fh);
	
	$text =~ s/.+/  "$&\\n"/g;
	print $out
		"const char k${mat}\[\] = \n",
		$text, ";\n\n";
}

close($out);
