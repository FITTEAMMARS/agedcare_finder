<?php
class Rating{

	private $conn;
    private $table_name = "home_facility_rating";

    public $id;
    public $facility_id;
    public $stars;
    public $email;

    public function __construct($db){
        $this->conn = $db;
    }

    // create product
	function create(){
 
    // query to insert record
    $query = "INSERT INTO
                " . $this->table_name . "
            SET
                facility_id=:facility_id, stars=:stars, email=:email, created=:created";
 
    // prepare query
    $stmt = $this->conn->prepare($query);
 
    // sanitize
    $this->facility_id=htmlspecialchars(strip_tags($this->facility_id));
    $this->stars=htmlspecialchars(strip_tags($this->stars));
    $this->email=htmlspecialchars(strip_tags($this->email));
    $this->created=htmlspecialchars(strip_tags($this->created));
 
    // bind values
    $stmt->bindParam(":facility_id", $this->facility_id);
    $stmt->bindParam(":stars", $this->stars);
    $stmt->bindParam(":email", $this->email);
    $stmt->bindParam(":created", $this->created);
 
    // execute query
    if($stmt->execute()){
        return true;
    }
 
    return false;
}

}