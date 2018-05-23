<?php
if( isset($_POST['url']) ){
    $file_name = shell_exec("Rscript sa.R ".$_POST['url']);
    echo "http://localhost/R-Sentimental-Analysis/".$file_name;
}
?>