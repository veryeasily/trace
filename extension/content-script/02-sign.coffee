
class Sign

	@findContainingChild: (parent, elt) ->
		for child in parent.childNodes
			return child if child.contains elt

	@getChildIndex: (elt) ->
		e = elt
		k = 0
		++k while e = e.previousSibling
		k

	@getOffsetToNode: (parent, elt) =>
		if parent is elt
			console.log "returning without reducing"
			return 0
		else
			goddamn = (a for a in parent.childNodes)
			child = @findContainingChild(parent, elt)
			offset = _.foldl goddamn[0...@getChildIndex child], ((memo, node) -> memo + node.textContent.length), 0
			#	^^ This is the only time I use underscore.js in the extension?
			if elt.parentNode isnt parent
				offset+= @getOffsetToNode(@findContainingChild(parent, elt), elt)
			console.log "offset being returned from @getOffsetToNode is: #{offset}"
			return offset

	@getMargin: (range) =>
		console.log "range is ="
		console.log range
		startOffset = @getOffsetToNode(range.commonAncestorContainer, range.startContainer) + range.startOffset
		console.log "startOffset = #{startOffset}"
		endOffset = @getOffsetToNode(range.commonAncestorContainer, range.endContainer) + range.endOffset
		console.log "endOffset = #{endOffset}"
		left = Math.max(0, startOffset - 10)
		right = Math.min(range.commonAncestorContainer.textContent.length, endOffset + 10)
		console.log "here is the index of our margin"
		console.log [left, right]
		console.log "here is range.commonAncestorContainer.textContent"
		console.log range.commonAncestorContainer.textContent
		console.log "here is our margin!"
		console.log (send = range.commonAncestorContainer.textContent.slice(left, right))
		send

	constructor: () ->

		sel = document.getSelection()
		console.log "made it to the try"
		try
			if sel.type isnt "Range"
				alert "no selection!"
				return
			range = sel.getRangeAt(0)
			if (parent = @parent = range.commonAncestorContainer).nodeType is 3 then (parent = @parent = parent.parentElement)
			if range.startContainer.parentElement isnt range.endContainer.parentElement
				alert "select something simpiler"
				return
			if (range.startContainer.nodeType isnt 3) or (range.endContainer.nodeType isnt 3)
				alert "we only can select text to turn to links for right now"
				return
		catch error
			throw error
		url = prompt("give link url", "http://www.awebsite.com")
		console.log "made it past the try"
		{startContainer: start, startContainer: {textContent: startStr}, endContainer: end, endContainer: {textContent: endStr}} = range = sel.getRangeAt 0
	
		@toDB =
			tag: parent.tagName
			text: range.toString()
			startText: range.toString()
			endText: range.toString()
			margin: Sign.getMargin(range)
			url: url
			host: document.location.hostname
			path: document.location.pathname

		if range.startContainer isnt range.endContainer
			console.log "trying to slice each container"
			@toDB.startText = startStr.slice range.startOffset, startStr.length + 1
			@toDB.endText = endStr.slice 0, range.endOffset
		console.log "#{@toDB.startText} is startText, #{@toDB.endText} is endText"
		thing = document.createElement('a')
		thing.href = url
		thing.target = '_blank'
		range.surroundContents(thing)
		$(thing).addClass("signifier").addClass("siggg")
		$(parent).addClass("siggg")

		Sign.socket.emit("heresASign", @toDB)

	@activate: ->
		chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
			makeSign = ->
				sign = new Sign()
			do makeSign if request.greeting is "makeSign"
		chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
			removeSign = ->
				Deleter.removeSigsInSel()
			do removeSign if request.greeting is "removeSign"
