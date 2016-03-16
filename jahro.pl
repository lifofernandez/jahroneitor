# jahro.pl

use Data::Dumper;
use HTML::Template;
use File::Slurp; 
use URI::Escape;
use YAML qw(Dump Bless);
use YAML::Node;
use YAML::XS 'LoadFile';
my $DATAyaml = LoadFile('data.yaml');
use Text::Markdown 'markdown';
use HTML::Tidy;

my $tidy = 'HTML::Tidy'->new({INDENT => 1,tidy_mark => 0,});
#  $tidy->ignore( text => qr/p/ );


# template de todas las novedades
my $templates = HTML::Template->new(filename => 'templates/novedades.tmpl');

# template individual para cada novedad
my $template = HTML::Template->new(filename => 'templates/novedad.tmpl');


my @H = ();

foreach my $dk (keys (%$DATAyaml)){
	my %temp_hash = %{$DATAyaml->{$dk}};
	
	$temp_hash{DESCRIPCION} = markdown($temp_hash{DESCRIPCION});

	# paso c/CODIGO adentro de c/hash
	$temp_hash{CODIGO} .= $dk;

	#paso hashderef al array de hashes @H
	my $ref_temp_hash = \%temp_hash;
	push(@H,$ref_temp_hash);


	# genero html individual para cada novedad
	$template->param($ref_temp_hash);
	write_file('output/'.$dk.'.html', $tidy->clean($template->output));
}

# html individual de todas las novedades
$templates->param(NOVEDAD => \@H);
write_file('output/novedades.html', $tidy->clean($templates->output));


# print $tidy->clean($templates->output);



