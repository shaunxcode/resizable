Emitter = require "emitter"
classes = require "classes"

handleDirs = 
	n:  cursor: "n",  n: true 
	s:  cursor: "s",  s: true
	e:  cursor: "e",  e: true
	w:  cursor: "w",  w: true
	ne: cursor: "ne", n: true, e: true
	se: cursor: "se", s: true, e: true
	sw: cursor: "sw", s: true, w: true
	nw: cursor: "nw", n: true, w: true
	
module.exports = (element) ->
	emitter = new Emitter
	startX = 0
	startY = 0
	startW = 0
	startH = 0
	handles = {}

	for handleDir, details of handleDirs
		do (handleDir, details) ->
			handles[handleDir] = document.createElement "div"
			classes(handles[handleDir])
				.add("resize-handle")
				.add("resize-handle-#{handleDir}")
			element.appendChild handles[handleDir]
			
			handles[handleDir].addEventListener "mousedown", (e) ->
				startX = e.pageX
				startY = e.pageY
				style = window.getComputedStyle element
				startW = parseInt style.width
				startH = parseInt style.height

				emitter.emit "resizestart", {element, handleDir}
		
				document.addEventListener "mousemove", resizeMove = (e) ->
					if details.n 
						element.style.top = (e.pageY) + "px"
						element.style.height = (startH + (startY - e.pageY)) + "px"

					if details.e
						element.style.width = (startW + (e.pageX - startX)) + "px"

					if details.s
						element.style.height = (startH + (e.pageY - startY)) + "px"

					if details.w
						element.style.left = (e.pageX) + "px"
						element.style.width = (startW + (startX - e.pageX)) + "px"
			
					emitter.emit "resize", {element, handleDir}

				document.addEventListener "mouseup", resizeStop = (e) ->
					document.removeEventListener "mousemove", resizeMove
					document.removeEventListener "mouseup", resizeStop
			
					emitter.emit "resizestop", {element, handleDir}
	emitter
