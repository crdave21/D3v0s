#! /usr/bin/perl  

#open (sitio,"sitios.txt");

my @url = ();
my $n;
sub Inicio{
if (@ARGV == 1){
	foreach my $file (@ARGV){
		if (-e $file){
		print "IP's...\n\n";
		open (prueba,">file.csv");
		open (sitios,$ARGV[0]);
			while(<sitios>){
			chomp;
			$n = &limpia(\$_);
				if($n =~ /www./)
				{
				push @url, split(" ",`nslookup "$n\n"`);
				}
				$n =~ s/www.//;
				push @url, split(" ",`nslookup "$n\n"`);
				}
				print "Name final file\n";
				my $entrada = <STDIN>;
				open (final, ">$IN");
	
				foreach my $n (@url){
				$n =~ s/Nombre:/\nSitio:/;
				unless(($n eq "internal DNS ")||($n eq "Internal IPs")||($n eq "Servidor:")||($n eq "Address:")||($n eq "Server:")||($n eq "Name:"))
					{
					if($n =~ /([0-9]{1,3}\.){3}[0-9]{1,3}$/){&ips(\$n);}
					#&ips(\$n);
					print prueba "$n\n";
	
					}
				}
				print "Listo";
		}else{
		ayuda();
		exit 1;
		}	
	}
}else{
	ayuda();
	exit 1;
	}
}


sub limpia{
	my $m = ${+shift};
	$m =~ s/^http[s]{0,1}:\/\///;
	$m =~ s/(\/[a-zA-Z0-9\~\-\_\=\.\&\%\$\#\"\'\?\¿\¡\!]+)+(\.[a-z]+){0,1}$//;
	$m =~ s/\///;
	return $m;
}

sub ips{

	my $p = ${+shift};
	print final "$p\n";
	
}
sub ayuda
{
	print "\nUse: sitios.pl [Files url's]\n\n";
}

Inicio();
close(sitio);
close(prueba);
close(final);
