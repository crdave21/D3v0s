#!/usr/bin/perl
#Code to check various sites and obtain a report of those available 

use strict;
use warnings;
require Text::CSV;
require LWP::Simple;
require HTTP::Request;
require HTML::Parser;
require HTML::TokeParser;

my $P = "V";
my $R = "X";

#abrir acrhivos
my $file_url = "url.txt";
my $file_csv = "browser.csv";

open my $info, $file_url or die "No se pudo abrir $file_url: $!";

my $csv = Text::CSV->new ( { binary => 1 , quote_char => "'", escape_char => "\\" } )  # should set binary attribute.
	or die "Error al crear CSV: " . Text::CSV->error_diag();
$csv->eol ("\n");
open my $fh, ">:encoding(utf8)",$file_csv or die "Error al abrir $file_csv: $!";

#obtener URL
my $i = 0;
my @cat;

while( my $url = <$info>)  { 
	chomp($url);
	#print "$url\n";
	#my @registro = ("URL", "Code Response", "Estatus Acceso");
	my @registro;
	push(@registro, $url);

#enviar request
	my $request = HTTP::Request->new(GET => $url);
	my $ua = LWP::UserAgent->new;
	$ua->agent('Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.21 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.21');
	$ua->show_progress('TRUE');
	$ua->default_header('Accept' => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
	$ua->default_header('Accept-Language' => "es,en-us;q=0.7,en");
	$ua->default_header('Accept-Encoding' => "gzip, deflate");
	$ua->timeout(20);
	$ua->ssl_opts(verify_hostname => 0);
	$ua->max_redirect( 3 );
	my $response = $ua->request($request);

#evaluar response
	push(@registro, $response->code());
        my $parser = HTML::TokeParser->new(\$response->content) or
    die "Can not code content";

	if ($response->code() >= 200  && $response->code() <= 207){
		print "$P\n";
		push(@registro, $P);
		push(@cat, $P);
	}
	elsif ($response->code() == 403 ){
                $parser->get_tag("title");
                if ( $parser->get_text() eq "Navegaci&oacute;n Segura en Internet" ){ #evaluar banner restriccion 
			print "$R\n";
			push(@registro, $R);
			push(@cat, $R);
		}	
		else{
			print "$P\n";
			push(@registro, $P);
			push(@cat, $P);
		}
	}
	else{
		print "$P\n";
		push(@registro, $P);
		push(@cat, $P);
	}
	push(@registro, $response->message);
	$i++;
	if ($i >= 3){
		$i = 0;
		my %nums;
		++$nums{$_} for @cat;
		@cat=();
		if ( exists $nums{$P} ){
			if ( $nums{$P} == 2 || $nums{$P} == 3){
				push(@registro, $P);
			}
		}
		if ( exists $nums{$R} ){
			if ( $nums{$R} == 2 || $nums{$R} == 3){
				push(@registro, $R);
                        }
                }
	}
	$csv->print ($fh,$_) for \@registro;
}

#cerrar archivos
#close $fh or die "$file_csv: $!";
#close $info or die "$file_url: $!";
