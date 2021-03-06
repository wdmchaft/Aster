<?
$xml = '<?xml version="1.0" ?><stars>';
$host = 'localhost';
$user = 'root';
$pass = 'root';
$db = 'sterren';

$connect = mysql_connect($host, $user, $pass);
if(!$connect) {
	echo "Couldn't establish connection.";
}

$select = mysql_select_db($db);
if(!$select) {
	echo "Couldn't select database.";
}


$query = mysql_query("SELECT ProperName,bayerFlamsteed,Hip,Gliese,HR,HD,RA,XDec,Distance,Mag,ColorIndex FROM hyg WHERE Mag < 6 ORDER BY Mag");
$i=0;

while($fetch = mysql_fetch_object($query)) {
	if($fetch->ProperName != "Sol") {
	$ra = (M_PI/12)*preg_replace('/\s+/','',$fetch->RA);
	
	$dec = deg2rad(preg_replace('/\s+/','',$fetch->XDec));
	$dec = M_PI/2 - $dec;
	
	$x = 20*sin($dec)*cos($ra);
	$y = 20*sin($dec)*sin($ra);
	$z = 20*cos($dec);
	
	$xml .= '<star id="'.$i.'">';
	if($fetch->ProperName != "") {
		$xml .= '<name>'.$fetch->ProperName.'</name>';
	}
	else {
		$xml .= '<name />';
	}
	if(preg_replace('/\s+/','',$fetch->bayerFlamsteed) != "" && preg_replace('/\s+/','',$fetch->bayerFlamsteed) != "-" ) {
		$xml .= '<bayer>'.preg_replace('/\s+/','',$fetch->bayerFlamsteed).'</bayer>';
	}
	else {
		$xml .= '<bayer />';
	}
	if(preg_replace('/\s+/','',$fetch->Hip) != "" && preg_replace('/\s+/','',$fetch->Hip) != "-" ) {
		$xml .= '<hip>'.preg_replace('/\s+/','',$fetch->Hip).'</hip>';
	}
	else {
		$xml .= '<hip />';
	}
	if(preg_replace('/\s+/','',$fetch->Gliese) != "" && preg_replace('/\s+/','',$fetch->Gliese) != "-" ) {
		$xml .= '<gliese>'.preg_replace('/\s+/','',$fetch->Gliese).'</gliese>';
	}
	else {
		$xml .= '<gliese />';
	}
		$xml .= '<x>'.$x.'</x><y>'.$y.'</y><z>'.$z.'</z><mag>'.preg_replace('/\s+/','',$fetch->Mag).'</mag><ci>'.preg_replace('/\s+/','',$fetch->ColorIndex).'</ci></star>';
	$i++;
	}
}
$xml .= '</stars>';

$myFile = "../stars.xml";
$fh = fopen($myFile, 'w') or die("can't open file");
fwrite($fh, $xml);
fclose($fh);

echo 'xml opgeslagen';

echo $i;
?>