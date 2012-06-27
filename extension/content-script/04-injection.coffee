$ ->
	chrome.extension.sendMessage({signStatus: Trace.signsFound}, (response) ->
		console.log response if logging
	)
	Trace.activate()
	Sign.activate()
	if logging
		return console.log "Trace activated"
