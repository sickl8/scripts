// ==UserScript==
// @name         New Userscript
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://www.google.com/search?q=food&biw=1920&bih=367&tbm=vid&ei=VWy8Y-jhN6mhptQPyLWFgAE&ved=0ahUKEwio4Mfgnbv8AhWpkIkEHchaARAQ4dUDCA0&uact=5&oq=food&gs_lcp=Cg1nd3Mtd2l6LXZpZGVvEAMyBAgAEEMyBAgAEEMyCwgAEIAEELEDEIMBMggIABCABBCxAzIFCAAQgAQyCAgAEIAEELEDMgsIABCABBCxAxCDATIFCAAQgAQyBQgAEIAEMggIABCABBCxAzoGCAAQFhAeOgoIABCxAxCDARBDOggIABCxAxCDAToFCAAQkQJQogdY0Q1gpw9oAHAAeACAAfkCiAGNDZIBBzAuMS4yLjOYAQCgAQHAAQE&sclient=gws-wiz-video
// @icon         https://www.google.com/s2/favicons?sz=64&domain=google.com
// @grant        none
// ==/UserScript==

(function () {
	'use strict';

	function decode(base64) {
		// remove 1st char and add removed '=' at end
		base64 = (base64 + "===").slice(1, base64.length + 3 - (base64.length + 2) % 4)
		base64 = base64
			.replace(/\-/g, '+') // Convert '-' to '+'
			.replace(/\_/g, '/'); // Convert '_' to '/'
		return base64js.toByteArray(base64);
	};

	let links = document.querySelectorAll("a[data-ved]");
	console.log({links})

})();