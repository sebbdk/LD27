(function() {

/**
 * Initiate the flash etc on page
 * @return void
 */
	$(document).on('ready', function() {
		swfobject.embedSWF("../../flash-source/bin-release/Main.swf", "flash-container", "100%", "600", "9.0.0", "swf/expressInstall.swf");
	});

})();

function saveScore(user, score) {
	console.log('saving score:' + user + ', ' + score);
}