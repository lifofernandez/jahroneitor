# jahro.pl

use Data::Dumper;
use HTML::Template;
use File::Slurp; 
use URI::Escape;
use YAML qw(Dump Bless);
use YAML::Node;
use YAML::XS 'LoadFile';
my $DATAyaml = LoadFile('data.yaml');



# template de todas las novedades
my $templates = HTML::Template->new(filename => 'templates/novedades.tmpl');

# template individual para cada novedad
my $template = HTML::Template->new(filename => 'templates/novedad.tmpl');


my @H = ();
foreach my $dk (keys (%$DATAyaml)){
	my %temp_hash = %{ $DATAyaml->{$dk} };
	# paso CODIGO adentro del hash
	$temp_hash{CODIGO} .= $dk;

	#paso hash al array de hashes 
	my $ref_temp_hash = \%temp_hash;
	push(@H,$ref_temp_hash);


	# html individual para cada novedad
	$template->param($ref_temp_hash);
	write_file('output/'.$dk.'.html', $template->output);
}

# html individual de todas las novedades
$templates->param(NOVEDAD => \@H);
write_file('output/novedades.html', $templates->output);



