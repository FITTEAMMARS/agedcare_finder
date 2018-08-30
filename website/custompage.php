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

	$query = "SELECT * FROM facility_basic ";

	//check button event
	if (isset($_POST['search']))
	{

			$search_term = mysqli_real_escape_string($dbc,$_POST['search_box']);
			$search_term2 = mysqli_real_escape_string($dbc,$_POST['search_box2']);
			$search_weekend = mysqli_real_escape_string($dbc,$_POST['Weekend']);
			$search_evening = mysqli_real_escape_string($dbc,$_POST['Night']);
			if($_POST['Weekend']=='dc' && $_POST['Night']=='dc')
			{
				$query.="WHERE OPEN_HOUR >= '{$search_term}' AND CLOSE_HOUR <= '{$search_term2}'";
			}
			elseif($_POST['Weekend']=='dc')
			{
				$query.="WHERE OPEN_HOUR >= '{$search_term}' AND CLOSE_HOUR <= '{$search_term2}' AND EVENINGS = '{$search_evening}'";
			}
			elseif($_POST['Night']=='dc')
			{
				$query.="WHERE OPEN_HOUR >= '{$search_term}' AND CLOSE_HOUR <= '{$search_term2}' AND WEEKENDS = '{$search_weekend}'";
			}
			else
			{
			$query.="WHERE OPEN_HOUR >= '{$search_term}' AND CLOSE_HOUR <= '{$search_term2}' AND WEEKENDS = '{$search_weekend}' AND EVENINGS = '{$search_evening}'";
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

        Search :
        <input type="text" name="search_box" value="" />
        <input type="text" name="search_box2" value="" /> Weekend :
        <input type="radio" name="Weekend" value="dc" /> I don't care
        <input type="radio" name="Weekend" value="TRUE" /> Avaliable
        <input type="radio" name="Weekend" value="FALSE" /> Unavaliable
        <br /> Night :
        <input type="radio" name="Night" value="dc" /> I don't care
        <input type="radio" name="Night" value="TRUE" /> Avaliable
        <input type="radio" name="Night" value="FALSE" /> Unavaliable
        <br />
        <input type="submit" name="search" value="search the data">
    </form>

    <table width="100%" cellpadding="6" cellspacing="6">
        <tr>
            <td>Service</td>
            <td>Opening Hours</td>
            <td>Closing Hours</td>
            <td>Weekends</td>
            <td>Evenings</td>
        </tr>
        <?php
$time = 1;
while(($row = mysqli_fetch_array($response)) && ($time < 50)) { ?>
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
