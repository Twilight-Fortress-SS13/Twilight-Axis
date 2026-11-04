//This proc allows download of past server logs saved within the data/logs/ folder.
/client/proc/getserverlogs()
	set name = "Get Server Logs"
	set desc = ""
	set category = "Server"

	browseserverlogs()

/client/proc/getcurrentlogs()
	set name = "Get Current Logs"
	set desc = ""
	set category = "Server"

	browseserverlogs("[GLOB.log_directory]/")

/client/proc/browseserverlogs(path = "data/logs/")
	path = browse_files(path)
	if(!path)
		return

	if(file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	var/regex/R = regex(@"round-[^-]+-(.+)/([^/]+)") // TA EDIT START
	var/suggested_name = R.Find(path) ? "[R.group[1]]-[R.group[2]]" : path
	src << ftp(file(path), suggested_name) // TA EDIT END
	to_chat(src, "Attempting to send [path], this may take a fair few minutes if the file is very large.")
	return
