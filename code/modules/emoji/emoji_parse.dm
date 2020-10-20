/proc/emoji_parse(text) //turns :ai: into an emoji in text.
	. = text
	if(!CONFIG_GET(flag/emojis))
		return
	var/static/list/emojis = icon_states(icon('icons/emoji.dmi'))
	var/parsed = ""
	var/pos = 1
	var/search = 0
	var/emoji = ""
	while(1)
		search = findtext(text, ":", pos)
		parsed += copytext(text, pos, search)
		if(search)
			pos = search
			search = findtext(text, ":", pos + length(text[pos]))
			if(search)
				emoji = lowertext(copytext(text, pos + length(text[pos]), search))
<<<<<<< HEAD
				var/datum/asset/spritesheet/sheet = get_asset_datum(/datum/asset/spritesheet/goonchat)
=======
				var/isthisapath = (emoji[1] == "/") && text2path(emoji)
				var/datum/asset/spritesheet/sheet = get_asset_datum(/datum/asset/spritesheet/chat)
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d
				var/tag = sheet.icon_tag("emoji-[emoji]")
				if(tag)
					parsed += tag
					pos = search + length(text[pos])
				else
					parsed += copytext(text, pos, search)
					pos = search
				emoji = ""
				continue
			else
				parsed += copytext(text, pos, search)
		break
	return parsed

/proc/emoji_sanitize(text) //cuts any text that would not be parsed as an emoji
	. = text
	if(!CONFIG_GET(flag/emojis))
		return
	var/static/list/emojis = icon_states(icon('icons/emoji.dmi'))
	var/final = "" //only tags are added to this
	var/pos = 1
	var/search = 0
	while(1)
		search = findtext(text, ":", pos)
		if(search)
			pos = search
			search = findtext(text, ":", pos + length(text[pos]))
			if(search)
				var/word = lowertext(copytext(text, pos + length(text[pos]), search))
				if(word in emojis)
					final += lowertext(copytext(text, pos, search + length(text[search])))
				pos = search + length(text[search])
				continue
		break
	return final
