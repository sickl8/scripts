// ==UserScript==
// @name         New Userscript
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://bitbucket.kinovaapps.com/projects/SCU/repos/*/pull-requests/*/overview*
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
					let target_el = el.parentElement?.parentElement?.parentElement?.
									getElementsByClassName("additional-line-content")[0].
									parentElement?.parentElement?.firstChild?.firstChild;
                    // console.log({innertext: target_el?.innerText});
                    let matches = target_el?.innerText.match(/\d+/g);
                    // console.log({matches});
                    linenum = matches[1] || matches[0];
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
			window.history.pushState(window.history.state, document.title, window.location.pathname + "?" + encodeURI(title.textContent.match(/KOR-\d+/)[0]));
			let container = document.createElement("div")
			let branchName = document.createElement("p")
			container.style.position = "fixed"
			container.style.display = "flex"
			container.style.justifyContent = "center"
			container.style.zIndex = 5
			container.style.top = 0
			container.style.left = "50%"
			container.style.width = 0
			branchName.innerText = title.textContent.match(/KOR-\d+/)[0]
			branchName.style.whiteSpace = "nowrap"
			branchName.style.margin = 0
			branchName.style.padding = 0
			branchName.style.paddingInline = "5px"
			branchName.style.borderBottomLeftRadius = "3px"
			branchName.style.borderBottomRightRadius = "3px"
			branchName.style.backgroundColor = "white"
			branchName.style.boxShadow = "0px 0px 16px #000"
			container.appendChild(branchName);
			document.body.appendChild(container)
		}
    }, 1000)
    // Your code here...
})();