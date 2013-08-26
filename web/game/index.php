<!DOCTYPE html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>Sebb - Reactor madness!</title>
	<link rel="stylesheet" href="">

	<meta property="og:title" content="Sebb - Reactor madness!"/>
	<meta property="og:image" content="http://<?php echo $_SERVER['HTTP_HOST'] ?>/flash/ld27/web/game/img/facebook_new.png"/>
	<meta property="og:url" content="http://<?php echo $_SERVER['HTTP_HOST'] ?>/flash/ld27/web/game/"/>
	<meta name="description" property="og:description" content="The entity knows not what who/what/where he is, the only thing he knows is that that big blue thing is important."/> 

	<link href="css/bootstrap.min.css" rel="stylesheet">

	<!-- Custom styles for this template -->
	<link href="css/jumbotron-narrow.css" rel="stylesheet">

	<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
	<!--[if lt IE 9]>
		<script src="js/html5shiv.js"></script>
		<script src="js/respond.min.js"></script>
	<![endif]-->

</head>
<body>

	<div class="container">
		<div class="header">
			<ul class="nav nav-pills pull-right">
				<li class="active"><a href="#">Home</a></li>
				<!--
					<li><a href="#">About</a></li>
					<li><a href="#">Contact</a></li>
				--> 
			</ul>

			<h3 class="text-muted">Sebb Games - Reactor madness!</h3>
		</div>

		<div class="jumbotron" id="flash-container">

		</div>

		<div class="row marketing">
			<div class="col-lg-6">
				<h4>About</h4>
				<p>In a not so ordinary place a entity suddonly appears. <br />
The entity knows not what who/what/where he is, the only thing he knows is that that big blue thing is important.  <br />
 <br />
A moment later portals open up and creatures come out, they charge him, leaving him no other option than to fight to protect himself and the precious blue structure.  <br />
 <br />
PS:  <br />
Controls are WASD to move and hold arrow keys down to shoot!  <br />
 <br />
PPS:  <br />
Keep strong, and stay alive!

</p>

			</div>

		

			<div class="col-lg-6"> 
				<h4>Like what you see!</h4>
				<p>
					<div class="fb-like" data-href="https://www.facebook.com/pages/Sebb-games/257966274328084" data-width="450" data-show-faces="true" data-send="true"></div>
				</p>
			</div>

			<div class="col-lg-6"> 
				<h4>Links</h4>
				<p>
					<a href="http://www.ludumdare.com/compo/ludum-dare-27/?action=preview&uid=24416" target="_blank">Ludum dare entry page</a>
				</p>
			</div>
		</div>

		<div class="fb-comments" data-href="http://<?php echo $_SERVER['HTTP_HOST'] ?>/flash/ld27/web/game/" data-width="810"></div>

		<div class="footer">
			<p>&copy; Sebb 2013</p>
		</div>

	</div>

	<!-- Scripts -->
	<script type="text/javascript" src="js/jquery-2.0.3.min.js"></script>
	<script type="text/javascript" src="js/swfobject.js"></script>
	<script type="text/javascript" src="js/app.js"></script>

	<div id="fb-root"></div>
	<script>
	  window.fbAsyncInit = function() {
	    // init the FB JS SDK
	    FB.init({
	      appId      : '598778433498694',                        // App ID from the app dashboard
	     // channelUrl : '//WWW.YOUR_DOMAIN.COM/channel.html', // Channel file for x-domain comms
	      status     : true,                                 // Check Facebook Login status
	      xfbml      : true                                  // Look for social plugins on the page
	    });

	    // Additional initialization code such as adding Event Listeners goes here
	  };

	  // Load the SDK asynchronously
	  (function(d, s, id){
	     var js, fjs = d.getElementsByTagName(s)[0];
	     if (d.getElementById(id)) {return;}
	     js = d.createElement(s); js.id = id;
	     js.src = "//connect.facebook.net/en_US/all.js";
	     fjs.parentNode.insertBefore(js, fjs);
	   }(document, 'script', 'facebook-jssdk'));
	</script>

</body>
</html>