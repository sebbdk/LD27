(function() {

/**
 * Initiate the flash etc on page
 * @return void
 */
	$(document).on('ready', function() {
		swfobject.embedSWF("../flash-source/bin-debug/Main.swf", "flash-container", "100%", "600", "11.4.0", "swf/expressInstall.swf");
	});

})();