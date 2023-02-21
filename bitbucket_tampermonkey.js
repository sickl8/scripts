// ==UserScript==
// @name         New Userscript
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @run-at       document-start
// @match        https://bitbucket.kinovaapps.com/projects/*/repos/*/pull-requests/*/overview*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=kinovaapps.com
// @grant        none
// ==/UserScript==

let repo_map = {
	"SCU": {
		"safety_control_unit": "safety_control_unit"
	},
	"ROB0006": {
		"armbase_fw3": "armbase_fw3"
	},
	"AC": {
		"actuators_nextgen": "actuators_nextgen"
	}
}

let project = window.location.href.match(/projects\/(\w+)/)[1];
let repo = window.location.href.match(/repos\/(\w+)/)[1];

if (repo_map[project] == undefined)
	repo_map[project] = {};
if (repo_map[project][repo] == undefined)
	repo_map[project][repo] = repo;

let absolute_path_to_repo_folder = `/home/sickl8/workspace/${repo_map[project][repo]}/`
if (absolute_path_to_repo_folder[0] != "/") {
	absolute_path_to_repo_folder = "/" + absolute_path_to_repo_folder
}
if (absolute_path_to_repo_folder[absolute_path_to_repo_folder.length - 1] != "/") {
	absolute_path_to_repo_folder += "/"
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
				let vscodeDiv = document.createElement("div");
				vscodeDiv.style.cssText = "display: flex; gap: 5px; align-items: center; transform: translateX(-20px)";
				let vscodeIcon = document.createElement("img");
				vscodeIcon.src = "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Visual_Studio_Code_1.35_icon.svg/2048px-Visual_Studio_Code_1.35_icon.svg.png";
				vscodeIcon.style.display = "inline";
				vscodeIcon.style.width = "15px";
				vscodeIcon.style.height = "15px";
				let vscodeAnchorLink = document.createElement("a");
				vscodeAnchorLink.style.display = "inline";
				let vscodelink = `vscode://file${absolute_path_to_repo_folder}${actNodeHeader.textContent}${linenum ? ":" + linenum: ""}`
				vscodeAnchorLink.innerText = `${actNodeHeader.textContent}${linenum ? ":" + linenum: ""}`;
				vscodeAnchorLink.href = vscodelink;
				vscodeDiv.appendChild(vscodeIcon);
				vscodeDiv.appendChild(vscodeAnchorLink);
				actNodeHeader.appendChild(vscodeDiv);

				[...actNode.getElementsByTagName("code")].forEach(code => {
					if (code.innerText && code.innerText.includes("/")) {
						let hr = document.createElement("a")
						let vscodelink = `vscode://file${absolute_path_to_repo_folder}${code.innerText}`
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