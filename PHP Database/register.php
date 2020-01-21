<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
require"connect.php";

if($_SERVER['REQUEST_METHOD']=="POST"){
    #code...
    $response = array();
    $nik = $_POST['nik'];
    $telp = $_POST['telp'];
    $foto = $_FILES['foto']['name'];
    $username = $_POST['username'];
    $password = md5($_POST['password']);
    $nama = $_POST['nama'];
    
    $imagePath = "image/".$foto;
    
    move_uploaded_file($_FILES['foto']['tmp_name'],$imagePath);
    
    $cek = "SELECT * FROM user WHERE username='$username'";
    $result = mysqli_fetch_array(mysqli_query($con, $cek));
    
    if (isset($result)){
        $response['value']='2';
        $response['message']="Username sudah ada";
        echo json_encode($response);
    }else{
        $insert = "INSERT INTO user VALUE(NULL,'$username','$password','0','$nama','$nik','$telp','$foto')";
        if (mysqli_query($con, $insert)){
        $response['value']=1;
        $response['message']="Berhasil mendaftar";
        echo json_encode($response);
        } else {
        $response['value']=0;
        $response['message']="Gagal mendaftar";
        echo json_encode($response);
        }
    }
    
    
    
}

?>