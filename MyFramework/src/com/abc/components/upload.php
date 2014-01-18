<?php
/*
	$vfp = fopen("check.txt","a+");
	fwrite($vfp,"Upload temp file name ====>".$_FILES['Filedata']['tmp_name']."\r\n");
	fwrite($vfp,"Upload File name ====>".$_FILES['Filedata']['name']."\r\n");
	fclose($vfp);
*/
	
	if ($_FILES['Filedata']['tmp_name'] && $_FILES['Filedata']['name'])
	{
		//#-- upload the image to the volume folder
		$vSourceFile = $_FILES['Filedata']['tmp_name'];
		$vImageName = stripslashes($_FILES['Filedata']['name']);
		$vFoldername = 'UploadedFiles/';
		if(!is_dir($vFoldername))
		{
			mkdir($vFoldername, 0777); //#-- Create a new session directory
			chmod($vFoldername, 0777); //#-- Set all the access permissions to the folder
		}
		if(copy($vSourceFile,$vFoldername.$vImageName))
			$vStatus = 1;
		else
			$vStatus = 0;
	}		
	else
	{
		$vStatus = 0;
	}
	echo '<?xml version="1.0" encoding="UTF-8"?>';
	if($vStatus)
		echo '<status>1</status>';
	else
		echo '<status>0</status>';
?>