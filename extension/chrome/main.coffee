###
chrome.browserAction.onClicked.addListener (tab) ->
  chrome.tabs.sendRequest tab.id, {greeting: "makeSign"},
	  (response) ->
		  console.log response
###
chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
	if request.greeting
		if request.greeting is "makeSign"
			chrome.tabs.getSelected null, (tab) ->
				chrome.tabs.sendRequest tab.id, {greeting: "makeSign"}, (response) ->
					console.log response
		else if request.greeting is "removeSign"
			chrome.tabs.getSelected null, (tab) ->
				chrome.tabs.sendRequest tab.id, {greeting: "removeSign"}, (response) ->
					console.log response
	else return null

chrome.extension.onMessage.addListener((request, sender, sendResponse) ->
	console.log if sender.tab then "from content script:" + sender.tab.url else "from the extension"
	console.log "here's the tab info:"
	console.log sender
	if request.signStatus?
		if request.signStatus is true
			chrome.browserAction.setIcon
				path: 'images/icon2.png'
				tabId: sender.tab.id
		else chrome.browserAction.setIcon
				path: 'images/icon3.png'
				tabId: sender.tab.id
)
