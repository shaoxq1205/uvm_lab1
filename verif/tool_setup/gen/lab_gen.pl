#!/pkg/qct/software/perl/current/bin/perl
### Usage: $0 <lab name>

my $user = $ENV{USER};
my $lab_string = $ARGV[0];

$string = "${user}_${lab_string}_";
my $num = &numit($string);


$diff = 1800 - $num;
$app_str = &rand_char($diff);

print "\n\n-------------------------------------------------------------------------------\n";
print " Please enter the following into your lesson to get credit for the lab\n\n";
print "                  ${string}${app_str}                                              \n\n";
print "-----------------------------------------------------------------------------------\n";



sub rand_char {
	my ($req_val) = @_;
	$chr = $req_val;
	$chrs = 1;
	foreach $i ( 1..20 ) {
		$div = $req_val / ($i*2);
		$idiv = int $div;
		$rem = $req_val - $idiv * $i *2;
#		print "req: $req_val     div : $div      idiv : $idiv\n";
		if( $idiv >= 58 && $idiv <= 116 ) { 
			$chr = $idiv;
			$chrs = $i*2;
#			print "chr : $chr       num_of_chr : $chrs     remain: $rem\n";
			last;
		}
	}
#	$atr = sprintf chr($chr) x $chrs;
	@arr = split(//,chr($chr) x $chrs);
#	print "DBG1: @arr        chrs: $#arr    $atr\n";
	$arr[$chrs-1] = chr((ord($arr[$chrs-1]))+$rem);
#	print "DBG2: @arr        chrs: $#arr\n";
	$chrs--;

	foreach $i ( 1..int($chrs/2) ) {
		$rand_num = int rand(6);
		while (1) { 
			$rnd = int rand($chrs);
#			print "DB1: $rnd    adj_num : $rand_num\n";
			if ( ! defined $adj{$rnd}) {
				$arr[$rnd] = chr(ord($arr[$rnd]) + $rand_num);
				$adj{$rnd} =1; last;
			};
		}
		while (1) { 
			$rnd = int rand($chrs);
#			print "DB2: $rnd\n";
			if ( ! defined $adj{$rnd}) {
				$arr[$rnd] = chr(ord($arr[$rnd]) - $rand_num);
				$adj{$rnd} =1; last;
			};
		}
	}
	return join("",@arr);
}


sub numit {
	my $str = @_[0];
	my $tot =0;
	foreach my $ele ( split(//,$str) ) {
		$tot += ord($ele);
	}
	return $tot;
}
