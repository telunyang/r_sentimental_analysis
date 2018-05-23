<?php
if( isset($_POST['url']) ){
    $file_name = shell_exec("Rscript sa.R ".$_POST['url']);
    echo "http://210.242.90.110/R/".$file_name;
}
?>