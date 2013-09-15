import insert from table

getLines = (str) ->
	unless str\match "\n$"
		str ..= "\n"

	_, lines = str\gsub "\n", "\n"
	return lines

returnPlural = (num) -> num == 1 and '' or 's'

calculateScriptData = ->
	base = game.Selection\Get![1] or game
	baseName = base\GetFullName!

	if base != game
		baseName = "game."..baseName
	else
		baseName ..= ".rbxl"

	print!
	print " -- Script data for #{baseName} -- "
	print!

	printLastLine = ->
		print!
		print " -- End script data for #{baseName} -- "
		print!

	allScripts = { }

	recursiveFind = (parent = base) ->
		if parent == game
			recursiveFind workspace
			recursiveFind game.Lighting
			recursiveFind game.StarterGui
			recursiveFind game.StarterPack
		else
			for obj in *parent\GetChildren!
				if obj.ClassName == "Script" or obj.ClassName == "LocalScript"
					insert allScripts, obj
				else
					recursiveFind obj

	recursiveFind!

	if #allScripts == 0
		print "There are no scripts in #{baseName}"
		printLastLine!
		return

	scriptCount, localScriptCount = 0, 0
	scriptLines, localScriptLines = 0, 0
	scriptChars, localScriptChars = 0, 0

	longestScript, longestScriptLines = nil, -1
	longestCharScript, longestScriptChars = nil, -1

	longestLocalScript, longestLocalScriptLines = nil, -1
	longestCharLocalScript, longestLocalScriptChars = nil, -1

	shortestScript, shortestScriptLines = nil, math.huge
	shortestCharScript, shortestScriptChars = nil, math.huge

	shortestLocalScript, shortestLocalScriptLines = nil, math.huge
	shortestCharLocalScript, shortestLocalScriptChars = nil, math.huge

	for currentScript in *allScripts
		lineCount = getLines currentScript.Source
		charCount = #currentScript.Source
		if currentScript.ClassName == "Script"
			scriptCount += 1
			scriptLines += lineCount
			scriptChars += charCount

			if lineCount > longestScriptLines
				longestScript = currentScript
				longestScriptLines = lineCount

			if lineCount < shortestScriptLines
				shortestScript = currentScript
				shortestScriptLines = lineCount

			if charCount > longestScriptChars
				longestCharScript = currentScript
				longestScriptChars = charCount

			if charCount < shortestScriptChars
				shortestCharScript = currentScript
				shortestScriptChars = charCount

		elseif currentScript.ClassName == "LocalScript"
			localScriptCount += 1
			localScriptLines += lineCount
			localScriptChars += charCount

			if lineCount > longestLocalScriptLines
				longestLocalScript = currentScript
				longestLocalScriptLines = lineCount

			if lineCount < shortestLocalScriptLines
				shortestLocalScript = currentScript
				shortestLocalScriptLines = lineCount

			if charCount > longestLocalScriptChars
				longestCharLocalScript = currentScript
				longestLocalScriptChars = charCount

			if charCount < shortestLocalScriptChars
				shortestCharLocalScript = currentScript
				shortestLocalScriptChars = charCount

	totalCount = scriptCount + localScriptCount
	totalLines = scriptLines + localScriptLines
	totalChars = scriptChars + localScriptChars

	printDataAbout = (about, totalAbout, scriptAbout, localAbout) ->
		if scriptCount > 0 and localScriptCount > 0
			print "- #{totalAbout} #{about}#{returnPlural totalAbout} in total"
		if scriptCount > 0
			print "- #{scriptAbout} #{about}#{returnPlural scriptAbout} in the server script#{returnPlural scriptCount}"
		if localScriptCount > 0
			print "- #{localAbout} #{about}#{returnPlural localAbout} in the local script#{returnPlural localScriptCount}"

	printAverageAbout = (about, totalAbout, scriptAbout, localAbout) ->
		if scriptCount > 0 and localScriptCount > 0
			print "- Average #{about} count: %.2f"\format totalAbout / totalCount
		if scriptCount > 0
			print "- Average server script #{about} count: %.2f"\format scriptAbout / scriptCount
		if localScriptCount > 0
			print "- Average local script #{about} count: %.2f"\format localAbout / localScriptCount

	print "- #{totalCount} script#{returnPlural totalCount} in #{baseName}"
	print "- #{scriptCount} server script#{returnPlural scriptCount}"
	print "- #{localScriptCount} local script#{returnPlural localScriptCount}"

	print!
	printDataAbout "line", totalLines, scriptLines, localScriptLines
	print!
	printAverageAbout "line", totalLines, scriptLines, localScriptLines

	print!
	printDataAbout "character", totalChars, scriptChars, localScriptChars
	print!
	printAverageAbout "character", totalChars, scriptChars, localScriptChars

	printLongShortData = (mostLeast, linesChars, mostScript, mostLocalScript, mostScriptLines, mostLocalScriptLines) ->
		if mostScript or mostLocalScript
			print!
			if mostScript
				print "- game.#{mostScript\GetFullName!} has the #{mostLeast} server script #{linesChars}s: #{mostScriptLines} #{linesChars}#{returnPlural mostScriptLines}"
			if mostLocalScript
				print "- game.#{mostLocalScript\GetFullName!} has the #{mostLeast} local script #{linesChars}s: #{mostLocalScriptLines} #{linesChars}#{returnPlural mostLocalScriptLines}"

	printLongShortData "most", "line", longestScript, longestLocalScript, longestScriptLines, longestLocalScriptLines
	printLongShortData "least", "line", shortestScript, shortestLocalScript, shortestScriptLines, shortestLocalScriptLines

	printLongShortData "most", "character", longestCharScript, longestCharLocalScript, longestScriptChars, longestLocalScriptChars
	printLongShortData "least", "character", shortestCharScript, shortestCharLocalScript, shortestScriptChars, shortestLocalScriptChars

	printLastLine!

PluginManager!\CreatePlugin!\CreateToolbar("Script Data")\CreateButton("Script Data", "Script Data", "").Click\connect calculateScriptData