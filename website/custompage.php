<?php
/*
Template Name: demo
*/

get_header(); ?>
    <div id="primary" class="content-area">
        <main id="main" class="site-main" role="main">
            <?php
		// Start the loop.
		while ( have_posts() ) :
			the_post();

			// Include the page content template.
			get_template_part( 'template-parts/content', 'page' );

			// If comments are open or we have at least one comment, load up the comment template.
			if ( comments_open() || get_comments_number() ) {
				comments_template();
			}

			// End of the loop.
		endwhile;
		?>
                <!--  my code begin here -->
                <!-- connect to database -->
                <?php

	DEFINE('DB_HOST', 'localhost');
	DEFINE('DB_NAME', 'local');
	DEFINE('DB_USER', 'root');
	DEFINE('DB_PASSWORD','root');
	$dbc = @mysqli_connect(DB_HOST,DB_USER,DB_PASSWORD,DB_NAME)
	OR die('can not connect to mysql' . mysqli_connect_error());
	//connection part end


    $clause = " WHERE ";
    $openparentheses = "(";
	$query = "SELECT * FROM facility_basic_test ";

	//check button event
	if (isset($_POST['search']))
	{ 
        $search_term = mysqli_real_escape_string($dbc,$_POST['search_box']);
        $search_term2 = mysqli_real_escape_string($dbc,$_POST['search_box2']);
        $search_weekend = mysqli_real_escape_string($dbc,$_POST['Weekend']);
        $search_evening = mysqli_real_escape_string($dbc,$_POST['Night']);

        if(isset($_POST['toc']))
        {
            $search_postcode = mysqli_real_escape_string($dbc,$_POST['search_postcode']);
        }
        else
        {
            $search_postcode = "'%'";
        }

        echo $search_postcode;

        if(isset($_POST['toc']))
        {

            foreach($_POST['toc'] as $c)
            {
                if(!empty($c))
                {
                $query .= $clause.$openparentheses."`".$c."` LIKE '%{$c}%'";
                $openparentheses = "";
                $clause = " OR ";//Change  to OR after 1st WHERE
                }
            }
            $query.=") ";

            if($_POST['Weekend']=='dc' && $_POST['Night']=='dc')
            {
                $query.="AND (OPEN_HOUR >= '{$search_term}' AND CLOSE_HOUR <= '{$search_term2}' AND STREET_PCODE LIKE '{$search_postcode}')";
            }
            elseif($_POST['Weekend']=='dc')
            {
                $query.="AND (OPEN_HOUR >= '{$search_term}' AND CLOSE_HOUR <= '{$search_term2}' AND EVENINGS = '{$search_evening}' AND STREET_PCODE LIKE '{$search_postcode}')";
            }
            elseif($_POST['Night']=='dc')
            {
                $query.="AND (OPEN_HOUR >= '{$search_term}' AND CLOSE_HOUR <= '{$search_term2}' AND WEEKENDS = '{$search_weekend}' AND STREET_PCODE LIKE '{$search_postcode}')";
            }
            else
            {
                $query.="AND (OPEN_HOUR >= '{$search_term}' AND CLOSE_HOUR <= '{$search_term2}' AND WEEKENDS = '{$search_weekend}' AND EVENINGS LIKE '{$search_evening}' AND STREET_PCODE = '{$search_postcode}')";
            }
            echo $query;
        }

        else
        {
            if($_POST['Weekend']=='dc' && $_POST['Night']=='dc')
            {
                $query.="WHERE OPEN_HOUR >= '{$search_term}' AND CLOSE_HOUR <= '{$search_term2}' AND STREET_PCODE = '{$search_postcode}'";
            }
            elseif($_POST['Weekend']=='dc')
            {
                $query.="WHERE OPEN_HOUR >= '{$search_term}' AND CLOSE_HOUR <= '{$search_term2}' AND EVENINGS = '{$search_evening}' AND STREET_PCODE LIKE '{$search_postcode}'";
            }
            elseif($_POST['Night']=='dc')
            {
                $query.="WHERE OPEN_HOUR >= '{$search_term}' AND CLOSE_HOUR <= '{$search_term2}' AND WEEKENDS = '{$search_weekend}' AND STREET_PCODE LIKE '{$search_postcode}'";
            }
            else
            {
                 $query.="WHERE OPEN_HOUR >= '{$search_term}' AND CLOSE_HOUR <= '{$search_term2}' AND WEEKENDS = '{$search_weekend}' AND EVENINGS = '{$search_evening}' AND STREET_PCODE LIKE '{$search_postcode}'";
            }
        }
	}

	// getresponse
	$response = @mysqli_query($dbc,$query);
	if (!$response) {
    printf("Error: %s\n", mysqli_error($dbc));
    exit();
	}
	
	?>

        </main>
        <!-- .site-main -->

        <?php get_sidebar( 'content-bottom' ); ?>

    </div>
    <!-- .content-area -->

    <form name="search_form" method="post">
        <h5>POST CODE: </h5><input type="text" name="search_postcode" value="" />
        <h5>Start Time </h5><input type="text" name="search_box" value="" />
        <h5>Finish Time</h5><input type="text" name="search_box2" value="" /> 

        <h5>Weekend</h5>
        <input type="radio" name="Weekend" value="dc" checked /> Not relevant
        <input type="radio" name="Weekend" value="TRUE"  /> Avaliable
        <input type="radio" name="Weekend" value="FALSE" /> Unavaliable
        <br /> 

        <h5>Night  </h5>
        <input type="radio" name="Night" value="dc" checked="" /> Not relevant
        <input type="radio" name="Night" value="TRUE" /> Avaliable
        <input type="radio" name="Night" value="FALSE" /> Unavaliable
        <br />

        <h5>Type of care</h5>
        <label><input type="checkbox" name="toc[]" value="dementia"><a> Dementia</a> </label>
        <label><input type="checkbox" name="toc[]" value="reable"><a> Reable</a> </label>
        <label><input type="checkbox" name="toc[]" value="respite"><a> Respite</a> </label>
        <label><input type="checkbox" name="toc[]" value="terminal"><a> Terminal</a> </label>
        <label><input type="checkbox" name="toc[]" value="mental_health"><a> Mental Health</a> </label><br />

        <input type="submit" name="search" value="search the data">
    </form>

    <table width="100%" cellpadding="6" cellspacing="6">
        <tr>
            <td><h6>Service</h6></td>
            <td><h6>Opening Hours</h6></td>
            <td><h6>Closing Hours</h6></td>
            <td><h6>Weekends</h6></td>
            <td><h6>Evenings</h6></td>
        </tr>
        <?php
$time = 1;
while(($row = mysqli_fetch_array($response)) && ($time < 100)) { ?>
            <tr>
                <td>
                    <?php echo $row['OUTLET_NAME'];?>
                </td>
                <td>
                    <?php echo $row['OPEN_HOUR']; ?>
                </td>
                <td>
                    <?php echo $row['CLOSE_HOUR']; ?>
                </td>
                <td>
                    <?php if($row['WEEKENDS']=='TRUE') {
		echo 'Avaliable';} 
		else{
			echo 'Unavaliable';} ?>
                </td>
                <td>
                    <?php if($row['EVENINGS']=='TRUE') {
		echo 'Avaliable';} 
		else{
			echo 'Unavaliable';} ?>
                </td>
            </tr>
            <?php  $time = $time + 1;} ?>
    </table>

    <?php get_footer(); ?>
