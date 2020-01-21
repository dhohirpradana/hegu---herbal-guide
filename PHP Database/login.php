<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
require"connect.php";

if($_SERVER['REQUEST_METHOD']=="POST"){
    #code...
    $response = array();
    $username = $_POST['username'];
    $password = md5($_POST['password']);
    
    $cek = "SELECT * FROM user WHERE username='$username' and password='$password'";
    $result = mysqli_fetch_array(mysqli_query($con, $cek));
    
    if (isset($result)){
        $response['value']=1;
        $response['levelUser']=$result['level'];
        
        $response['message']="Login Berhasil";
        $response['username']=$result['username'];
        $response['nama']=$result['nama'];
        
        $response['foto']=$result['foto'];
        
        echo json_encode($response);
    }else{
        $response['value']=0;
        $response['message']="Login Gagal";
        echo json_encode($response);
    }
    
    
    
}

?>