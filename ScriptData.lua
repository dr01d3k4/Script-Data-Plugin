local insert = table.insert
local getLines
getLines = function(str)
  if not (str:match("\n$")) then
    str = str .. "\n"
  end
  local _, lines = str:gsub("\n", "\n")
  return lines
end
local returnPlural
returnPlural = function(num)
  return num == 1 and '' or 's'
end
local calculateScriptData
calculateScriptData = function()
  local base = game.Selection:Get()[1] or game
  local baseName = base:GetFullName()
  if base ~= game then
    baseName = "game." .. baseName
  else
    baseName = baseName .. ".rbxl"
  end
  print()
  print(" -- Script data for " .. tostring(baseName) .. " -- ")
  print()
  local printLastLine
  printLastLine = function()
    print()
    print(" -- End script data for " .. tostring(baseName) .. " -- ")
    return print()
  end
  local allScripts = { }
  local recursiveFind
  recursiveFind = function(parent)
    if parent == nil then
      parent = base
    end
    if parent == game then
      recursiveFind(workspace)
      recursiveFind(game.Lighting)
      recursiveFind(game.StarterGui)
      return recursiveFind(game.StarterPack)
    else
      local _list_0 = parent:GetChildren()
      for _index_0 = 1, #_list_0 do
        local obj = _list_0[_index_0]
        if obj.ClassName == "Script" or obj.ClassName == "LocalScript" then
          insert(allScripts, obj)
        else
          recursiveFind(obj)
        end
      end
    end
  end
  recursiveFind()
  if #allScripts == 0 then
    print("There are no scripts in " .. tostring(baseName))
    printLastLine()
    return 
  end
  local scriptCount, localScriptCount = 0, 0
  local scriptLines, localScriptLines = 0, 0
  local scriptChars, localScriptChars = 0, 0
  local longestScript, longestScriptLines = nil, -1
  local longestCharScript, longestScriptChars = nil, -1
  local longestLocalScript, longestLocalScriptLines = nil, -1
  local longestCharLocalScript, longestLocalScriptChars = nil, -1
  local shortestScript, shortestScriptLines = nil, math.huge
  local shortestCharScript, shortestScriptChars = nil, math.huge
  local shortestLocalScript, shortestLocalScriptLines = nil, math.huge
  local shortestCharLocalScript, shortestLocalScriptChars = nil, math.huge
  local _list_0 = allScripts
  for _index_0 = 1, #_list_0 do
    local currentScript = _list_0[_index_0]
    local lineCount = getLines(currentScript.Source)
    local charCount = #currentScript.Source
    if currentScript.ClassName == "Script" then
      scriptCount = scriptCount + 1
      scriptLines = scriptLines + lineCount
      scriptChars = scriptChars + charCount
      if lineCount > longestScriptLines then
        longestScript = currentScript
        longestScriptLines = lineCount
      end
      if lineCount < shortestScriptLines then
        shortestScript = currentScript
        shortestScriptLines = lineCount
      end
      if charCount > longestScriptChars then
        longestCharScript = currentScript
        longestScriptChars = charCount
      end
      if charCount < shortestScriptChars then
        shortestCharScript = currentScript
        shortestScriptChars = charCount
      end
    elseif currentScript.ClassName == "LocalScript" then
      localScriptCount = localScriptCount + 1
      localScriptLines = localScriptLines + lineCount
      localScriptChars = localScriptChars + charCount
      if lineCount > longestLocalScriptLines then
        longestLocalScript = currentScript
        longestLocalScriptLines = lineCount
      end
      if lineCount < shortestLocalScriptLines then
        shortestLocalScript = currentScript
        shortestLocalScriptLines = lineCount
      end
      if charCount > longestLocalScriptChars then
        longestCharLocalScript = currentScript
        longestLocalScriptChars = charCount
      end
      if charCount < shortestLocalScriptChars then
        shortestCharLocalScript = currentScript
        shortestLocalScriptChars = charCount
      end
    end
  end
  local totalCount = scriptCount + localScriptCount
  local totalLines = scriptLines + localScriptLines
  local totalChars = scriptChars + localScriptChars
  local printDataAbout
  printDataAbout = function(about, totalAbout, scriptAbout, localAbout)
    if scriptCount > 0 and localScriptCount > 0 then
      print("- " .. tostring(totalAbout) .. " " .. tostring(about) .. tostring(returnPlural(totalAbout)) .. " in total")
    end
    if scriptCount > 0 then
      print("- " .. tostring(scriptAbout) .. " " .. tostring(about) .. tostring(returnPlural(scriptAbout)) .. " in the server script" .. tostring(returnPlural(scriptCount)))
    end
    if localScriptCount > 0 then
      return print("- " .. tostring(localAbout) .. " " .. tostring(about) .. tostring(returnPlural(localAbout)) .. " in the local script" .. tostring(returnPlural(localScriptCount)))
    end
  end
  local printAverageAbout
  printAverageAbout = function(about, totalAbout, scriptAbout, localAbout)
    if scriptCount > 0 and localScriptCount > 0 then
      print(("- Average " .. tostring(about) .. " count: %.2f"):format(totalAbout / totalCount))
    end
    if scriptCount > 0 then
      print(("- Average server script " .. tostring(about) .. " count: %.2f"):format(scriptAbout / scriptCount))
    end
    if localScriptCount > 0 then
      return print(("- Average local script " .. tostring(about) .. " count: %.2f"):format(localAbout / localScriptCount))
    end
  end
  print("- " .. tostring(totalCount) .. " script" .. tostring(returnPlural(totalCount)) .. " in " .. tostring(baseName))
  print("- " .. tostring(scriptCount) .. " server script" .. tostring(returnPlural(scriptCount)))
  print("- " .. tostring(localScriptCount) .. " local script" .. tostring(returnPlural(localScriptCount)))
  print()
  printDataAbout("line", totalLines, scriptLines, localScriptLines)
  print()
  printAverageAbout("line", totalLines, scriptLines, localScriptLines)
  print()
  printDataAbout("character", totalChars, scriptChars, localScriptChars)
  print()
  printAverageAbout("character", totalChars, scriptChars, localScriptChars)
  local printLongShortData
  printLongShortData = function(mostLeast, linesChars, mostScript, mostLocalScript, mostScriptLines, mostLocalScriptLines)
    if mostScript or mostLocalScript then
      print()
      if mostScript then
        print("- game." .. tostring(mostScript:GetFullName()) .. " has the " .. tostring(mostLeast) .. " server script " .. tostring(linesChars) .. "s: " .. tostring(mostScriptLines) .. " " .. tostring(linesChars) .. tostring(returnPlural(mostScriptLines)))
      end
      if mostLocalScript then
        return print("- game." .. tostring(mostLocalScript:GetFullName()) .. " has the " .. tostring(mostLeast) .. " local script " .. tostring(linesChars) .. "s: " .. tostring(mostLocalScriptLines) .. " " .. tostring(linesChars) .. tostring(returnPlural(mostLocalScriptLines)))
      end
    end
  end
  printLongShortData("most", "line", longestScript, longestLocalScript, longestScriptLines, longestLocalScriptLines)
  printLongShortData("least", "line", shortestScript, shortestLocalScript, shortestScriptLines, shortestLocalScriptLines)
  printLongShortData("most", "character", longestCharScript, longestCharLocalScript, longestScriptChars, longestLocalScriptChars)
  printLongShortData("least", "character", shortestCharScript, shortestCharLocalScript, shortestScriptChars, shortestLocalScriptChars)
  return printLastLine()
end
return PluginManager():CreatePlugin():CreateToolbar("Script Data"):CreateButton("Script Data", "Script Data", "").Click:connect(calculateScriptData)
