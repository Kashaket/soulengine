<? 

//Load extension here... etc.... 
 
if(!extension_loaded('rarp')) {
	dl('rarp.dll');
}

$a = blah(1,array('a','b','c')); 
echo $a;

?> 
 