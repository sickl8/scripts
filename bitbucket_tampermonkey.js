// ==UserScript==
// @name         New Userscript
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @run-at       document-start
// @match        https://bitbucket.kinovaapps.com/projects/SCU/repos/*/pull-requests/*/overview*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=kinovaapps.com
// @grant        none
// ==/UserScript==

let absolute_path_to_scu_folder = "/home/sickl8/workspace/safety_control_unit/"
if (absolute_path_to_scu_folder[0] != "/") {
	absolute_path_to_scu_folder = "/" + absolute_path_to_scu_folder
}
if (absolute_path_to_scu_folder[absolute_path_to_scu_folder.length - 1] != "/") {
	absolute_path_to_scu_folder += "/"
}

const observer = new MutationObserver((mutations, observer) => {
	mutations.filter(mut => mut.target.classList.contains("activities"))
	.forEach(mutation => {
		[...mutation.addedNodes].filter(node => node.classList.contains("commented-activity"))
		.forEach(actNode => {
			setTimeout(() => {
				let linenum = undefined;
				try {
					let target_el = actNode.getElementsByClassName("additional-line-content")[0]
						.parentElement?.parentElement?.firstChild?.firstChild;
					let matches = target_el?.innerText.match(/\d+/g);
					linenum = matches[1] || matches[0];
				} catch { }
				let actNodeHeader = actNode.getElementsByClassName("file-breadcrumbs")[0];
				if (!actNodeHeader) { return }
				actNodeHeader.appendChild(document.createElement("br"))
				let vscodeAnchorLink = document.createElement("a");
				let vscodelink = `vscode://file${absolute_path_to_scu_folder}${actNodeHeader.textContent}${linenum ? ":" + linenum: ""}`
				vscodeAnchorLink.innerText = `${actNodeHeader.textContent}${linenum ? ":" + linenum: ""}`;
				vscodeAnchorLink.href = vscodelink;
				actNodeHeader.appendChild(vscodeAnchorLink);

				[...actNode.getElementsByTagName("code")].forEach(code => {
					if (code.innerText && code.innerText.includes("/")) {
						let hr = document.createElement("a")
						let vscodelink = `vscode://file${absolute_path_to_scu_folder}${code.innerText}`
						hr.href = vscodelink
						hr.innerText = "🔗"
						hr.style.fontSize = "10px"
						code.appendChild(hr)
					}
				})
			}, 50)
		})
	})
	let title = document.getElementsByClassName("ref-lozenge-content")[0]
	if (title && !document.getElementById("theKOR")) {
		let copyBranchIcon = document.createElement("span");
		copyBranchIcon.innerText = " 📋";
		copyBranchIcon.onclick = () => {
			navigator.clipboard.writeText(title.children[0].textContent);
			// alert("Copied!");
		}
		title.appendChild(copyBranchIcon);
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
		container.id = "theKOR"
		container.appendChild(branchName);
		document.body.appendChild(container)
	}
});

observer.observe(document, {
	subtree: true,
	childList: true,
	attributes: true
});