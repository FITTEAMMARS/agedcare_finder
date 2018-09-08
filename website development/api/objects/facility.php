<?php
class Facility{
	// db connection and table name

    // database connection and table name
    private $conn;
    private $table_name = "facility_basic2";
 
    // object properties
    public $id;
    public $outlet_name;
    public $state;
    public $open_hours;
    public $close_hours;
 
    // constructor with $db as database connection
    public function __construct($db){
        $this->conn = $db;
    }
}
}