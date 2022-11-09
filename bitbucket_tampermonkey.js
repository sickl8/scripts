// ==UserScript==
// @name         New Userscript
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://bitbucket.kinovaapps.com/projects/SCU/repos/safety_control_unit/pull-requests/*/overview*
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
        let els = document.getElementsByClassName("file-breadcrumbs")
        console.log({els})
        for (let i in els) {
            let el = els[i]
            console.log({textcontent: el.textContent})
            if (el.textContent) {
                let linenum = undefined
				try {
					linenum = el.parentElement?.parentElement?.parentElement?.
									getElementsByClassName("additional-line-content")[0].
									parentElement?.parentElement?.firstChild?.firstChild?.innerText.match(/\d+/)[0];
				} catch {}
                el.appendChild(document.createElement("br"))
                let a = document.createElement("a");
                let vscodelink = `vscode://file${absolute_path_to_scu_folder}${el.textContent}${linenum ? ":" + linenum: ""}`
                a.innerText = `${el.textContent}${linenum ? ":" + linenum: ""}`;
                a.href = vscodelink;
                el.appendChild(a)
            }
        }
        let cs = document.getElementsByTagName("code")
        for (let i in cs) {
            let code = cs[i]
            if (code.innerText && code.innerText.includes("/")) {
                let hr = document.createElement("a")
                let vscodelink = `vscode://file${absolute_path_to_scu_folder}${code.innerText}`
                hr.href = vscodelink
                let img = document.createElement("img")
                img.src = "https://www.freeiconspng.com/uploads/link-icon-png-14.png"
                img.width = 10
                img.height = 10
				hr.innerText = "🔗"
				hr.style.fontSize = "10px"
                // hr.appendChild(img)
                code.appendChild(hr)
            }
        }
        let title = document.getElementsByClassName("ref-lozenge-content")[0]
		if (title) {
			window.history.pushState(window.history.state, document.title, window.location.pathname + "?KOR=" + encodeURI(title.textContent).replace(/%[0-9a-fA-F][0-9a-fA-F]/g, "-"));
			let branchName = document.createElement("p")
			branchName.innerText = title.textContent.match(/KOR-\d+/)[0]
			branchName.style.position = "fixed"
			branchName.style.top = 0
			branchName.style.left = "50%"
			branchName.style.margin = 0
			branchName.style.padding = 0
			branchName.style.paddingInline = "5px"
			branchName.style.borderBottomLeftRadius = "3px"
			branchName.style.borderBottomRightRadius = "3px"
			branchName.style.zIndex = 5
			branchName.style.backgroundColor = "white"
			branchName.style.boxShadow = "0px 0px 16px #000"
			document.body.appendChild(branchName)
		}
    }, 1000)
    // Your code here...
})();