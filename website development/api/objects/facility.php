<?php
class Facility{
	// db connection and table name
    // database connection and table name

    private $conn;
    private $table_name = "facility_basic_test";
 
    // object properties
    public $id;
    public $outlet_name;
    public $address;
    public $STREET_STATE;
    public $OPEN_HOUR;
    public $CLOSE_HOUR;
    public $weekends;

 
    // constructor with $db as database connection
    public function __construct($db){
        $this->conn = $db;
    }

    function read(){
 
    // select all query
    $query = "SELECT * FROM facility_basic_test";
 
    // prepare query statement
    $stmt = $this->conn->prepare($query);
 
    // execute query
    $stmt->execute();
 
    return $stmt;
}

    function search($pcode,$stime,$ftime,$weekend,$night,$dementia,$reable,$respite,$terminal,$mental_health){
 
    // select all query
    $query = "SELECT * FROM facility_basic_test WHERE
                STREET_PCODE LIKE ? AND OPEN_HOUR >= ? AND CLOSE_HOUR <= ? AND WEEKENDS LIKE ? AND EVENINGS LIKE ? AND dementia LIKE ? AND reable LIKE ? AND respite LIKE ? AND terminal LIKE ? AND mental_health LIKE ?";
 
    // prepare query statement
    $stmt = $this->conn->prepare($query);
 
    // sanitize
    $pcode=htmlspecialchars(strip_tags($pcode));
    $pcode = "%{$pcode}%";

    // bind
    $stmt->bindParam(1, $pcode);
    $stmt->bindParam(2, $stime);
    $stmt->bindParam(3, $ftime);
    $stmt->bindParam(4, $weekend);
    $stmt->bindParam(5, $night);
    $stmt->bindParam(6, $dementia);
    $stmt->bindParam(7, $reable);
    $stmt->bindParam(8, $respite);
    $stmt->bindParam(9, $terminal);
    $stmt->bindParam(10, $mental_health);
 
    // execute query
    $stmt->execute();
 
    return $stmt;
    }

}