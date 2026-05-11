/client/proc/link_ckey2discord()
	set name = "Link discord to admin ckey"
	set category = "-Special Verbs-"
	if(!holder || !check_rights(R_DEBUG))
		return
	var/select = input("Select type of data for link (and open DM)", "Data") in list("Account ID", "Name")
	var/list/data = list(
		"type"= "link",
	)
	var/selected
	switch(select)
		if("Account ID")
			selected = input("Enter your ID", "Data")
			if(!selected)
				return
			data["id"] = selected
		if("Name")
			selected = input("Enter your name (not server name, only account name)", "Data")
			if(!selected)
				return
			data["name"] = selected
	data["hash"] = md5(num2text(world.time))
	send2discordwh(data)
	if(input("To confirm, enter here number which was sended to you in DM", "Confirmation") == data["hash"])
		data["type"]="link_verified"
		data["ckey"]=src.ckey
		send2discordwh(data)
		to_chat(src, span_blue("Account in process of linking... If everything is ok, bot will send a message to you in DM."))
	else
		to_chat(src, span_danger("Bad key!!!"))
