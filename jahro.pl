
# students.pl
use Data::Dumper;
use HTML::Template;
use File::Slurp; 
use JSON;
use JSON::Any;
use URI::Escape;

my $DATAjson = read_file('data.json');
$DATA = decode_json $DATAjson;


# pagina de todas las novedades
my $templates = HTML::Template->new(filename => 'novedades.tmpl');
$templates->param(NOVEDAD => JSON::Any->new->decode($DATAjson));
print 'generando : novedades.html'."\n";

write_file('output/novedades.html', $templates->output);


# pagina individual para cada novedad
my $template = HTML::Template->new(filename => 'novedad.tmpl');
my @novedades = @{ $DATA };

foreach my $f ( @novedades ) {
  	# print $f->{"NAME"} . "\n";

	$template->param(
		NAME => $f->{"NAME"},
		GPA => $f->{"GPA"}

	);

	my $URL = lc($f->{"NAME"});
	$URL=~s/ /-/g;
	print 'generando : '.$URL."\n";


  	write_file('output/'.$URL.'.html', $template->output);

}

