

function replaceConditionInTrigger (trigger, conditionToFind, replacement)
	local newTrigger = trigger
	newTrigger = string.gsub(newTrigger, "^"..conditionToFind.."$", replacement)
	newTrigger = string.gsub(newTrigger, "^"..conditionToFind.."([) ])", replacement.."%1")
	newTrigger = string.gsub(newTrigger, "([( ])"..conditionToFind.."([) ])", "%1"..replacement.."%2")
	newTrigger = string.gsub(newTrigger, "([( ])"..conditionToFind.."$", "%1"..replacement)
	return newTrigger
end

function replaceVariableInExpression (expression, variableToFind, replacement)
	local newExpression = expression
	newExpression = string.gsub(newExpression, "^"..variableToFind.."$", replacement)
	newExpression = string.gsub(newExpression, "^"..variableToFind.."([) %+-*/%%])", replacement.."%1")
	newExpression = string.gsub(newExpression, "([( %+-*/%%])"..variableToFind.."([) %+-*/%%])", "%1"..replacement.."%2")
	newExpression = string.gsub(newExpression, "([( %+-*/%%])"..variableToFind.."$", "%1"..replacement)
	return newExpression
end

function extractLang (srcString, lang)
	local ret = ""
	-- try to extract asked lang
	if srcString then
		ret = string.gsub(srcString, "(.*)%["..lang.."%](.*)%["..lang.."%](.*)", "%2")
		if ret == "" then
			-- try to extract english lang
			lang = "en"
			ret = string.gsub(srcString, "(.*)%["..lang.."%](.*)%["..lang.."%](.*)", "%2")
			if ret == "" then
				ret = srcString
			end
		end
	end
	return ret
end