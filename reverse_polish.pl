use warnings;
use strict;
use encoding 'utf-8';
use 5.14.0;

my @list=qw/10 4 3 + 2 * -/;
my $stack=[];
foreach (@list) {
	unshift $stack,$_ if(m/\d/);
    if(m/\+|\-|\*|\//){ 
    	my $v1 = shift $stack;
    	my $v2 = shift $stack;	
    	unshift $stack,eval"$v2 $_ $v1";
    }
}
say @$stack;
