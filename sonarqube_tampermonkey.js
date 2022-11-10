// ==UserScript==
// @name         New Userscript
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://sonarqube-developer.kinovaapps.com/project/issues*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=kinovaapps.com
// @grant        none
// ==/UserScript==

(function() {
	'use strict';
	let absolute_path_to_scu_folder = "/home/sickl8/workspace/safety_control_unit/"
	
	if (absolute_path_to_scu_folder[0] != "/") {
        absolute_path_to_scu_folder = "/" + absolute_path_to_scu_folder
    }
    if (absolute_path_to_scu_folder[absolute_path_to_scu_folder.length - 1] != "/") {
        absolute_path_to_scu_folder += "/"
    }
    setTimeout(() => {
		let params = new URLSearchParams(window.location.search);
		let filepath = params.get("files");
		try {
			let issue_lists = document.getElementsByClassName("issue-list")
			for (let i in issue_lists) {
				let issue_list = issue_lists[i]
				let linenum = undefined
				try {
					linenum = issue_list.parentElement.getAttribute("data-line-number")
				} catch {}
				let vscodelink = `vscode://file${absolute_path_to_scu_folder}${filepath}${linenum ? ":" + linenum : ""}`
				let anchor = document.createElement("a")
				anchor.href = vscodelink
				anchor.innerText = `${filepath}${linenum ? ":" + linenum : ""}`
				anchor.style.cssText = "padding: 10px; font-size: 16px"
				issue_list.prepend(anchor)
			}
		} catch {}
	}, 5000)
})();