<?php
// required headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
 
// include database and object files
include_once '../config/database.php';
include_once '../objects/facility.php';
 
// instantiate database and product object
$database = new Database();
$db = $database->getConnection();
 
// initialize object
$facility = new Facility($db);
 
// query products
$stmt = $facility->read();
$num = $stmt->rowCount();
 
// check if more than 0 record found
if($num>0){
 
    // products array
    $facility_arr=array();
    $facility_arr["records"]=array();
 
    // retrieve our table contents
    // fetch() is faster than fetchAll()
    // http://stackoverflow.com/questions/2770630/pdofetchall-vs-pdofetch-in-a-loop
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)){
        // extract row
        // this will make $row['name'] to
        // just $name only
        extract($row);
 
        $facility_item=array(
            "id" => $id,
            "outlet_name" => $OUTLET_NAME,
            "address" => $address,
            "state" => $STREET_STATE,
            "post_code" => $STREET_PCODE,
            "open_hour" => $OPEN_HOUR,
            "close_hour" => $CLOSE_HOUR,
            "weekends" => $WEEKENDS,
            "evenings" => $EVENINGS,
            "dementia" => $dementia,
            "reable" => $reable,
            "respite" => $respite,
            "terminal" => $terminal,
            "mental_health" => $mental_health
        );
 
        array_push($facility_arr["records"], $facility_item);
    }
    echo json_encode($facility_arr);
}

else{
    echo json_encode(
        array("message" => "No products found.")
    );
}
?>