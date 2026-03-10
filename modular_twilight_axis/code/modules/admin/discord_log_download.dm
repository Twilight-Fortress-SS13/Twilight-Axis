#define ADMIN_DISCORD_LOG_LINK_TTL (10 MINUTES)
#define ADMIN_DISCORD_LOG_LIST_LIMIT 15
#define ADMIN_DISCORD_LOG_SELECTION_TTL (15 MINUTES)

GLOBAL_LIST_EMPTY(discord_log_download_tokens)
GLOBAL_LIST_EMPTY(discord_log_selection_cache)

/datum/config_entry/string/admin_logs_webhook_url
	default = null

/proc/discord_log_usage_text()
	return "Usage: `logs`/`logs current`, `logs list \[relative_dir\]`, `logs browse <number>`, `logs get <number>`, or `logs path <relative_file>`"

/proc/discord_log_cleanup_tokens()
	if(!GLOB.discord_log_download_tokens)
		return

	var/list/expired_tokens = list()
	for(var/token in GLOB.discord_log_download_tokens)
		var/list/token_data = GLOB.discord_log_download_tokens[token]
		if(!islist(token_data) || !token_data["expires_at"] || token_data["expires_at"] <= world.realtime)
			expired_tokens += token

	for(var/token in expired_tokens)
		GLOB.discord_log_download_tokens -= token

/proc/discord_log_cleanup_selections()
	if(!GLOB.discord_log_selection_cache)
		return

	var/list/expired_keys = list()
	for(var/cache_key in GLOB.discord_log_selection_cache)
		var/list/cache_data = GLOB.discord_log_selection_cache[cache_key]
		if(!islist(cache_data) || !cache_data["expires_at"] || cache_data["expires_at"] <= world.realtime)
			expired_keys += cache_key

	for(var/cache_key in expired_keys)
		GLOB.discord_log_selection_cache -= cache_key

/proc/discord_log_normalize_relative_path(relative_path)
	if(!istext(relative_path))
		return null

	relative_path = trim(replacetext(relative_path, "\\", "/"))
	if(!relative_path)
		return ""

	if(findtext(relative_path, "data/logs/") == 1)
		relative_path = copytext(relative_path, length("data/logs/") + 1)

	while(findtext(relative_path, "//"))
		relative_path = replacetext(relative_path, "//", "/")

	while(findtext(relative_path, "./") == 1)
		relative_path = copytext(relative_path, 3)

	if(!relative_path)
		return ""

	if(copytext(relative_path, 1, 2) == "/")
		return null

	if(findtext(relative_path, "..") || findtext(relative_path, ":") || findtext(relative_path, "\n") || findtext(relative_path, ascii2text(13)))
		return null

	return relative_path

/proc/discord_log_public_base_url()
	var/server = trim(CONFIG_GET(string/server))
	if(server)
		if(findtext(server, "http://") == 1 || findtext(server, "https://") == 1)
			return server

		if(findtext(server, "byond://") == 1)
			server = copytext(server, length("byond://") + 1)

		if(server)
			return "http://[server]/"

	var/address = world.internet_address
	if(!address || address == "0.0.0.0")
		address = world.address
	if(!address)
		address = "127.0.0.1"

	return "http://[address]:[world.port]/"

/proc/discord_log_command_key(datum/tgs_chat_user/sender)
	if(sender?.id)
		return "id:[sender.id]"

	if(sender?.friendly_name)
		return "name:[sender.friendly_name]"

	if(sender?.mention)
		return "mention:[sender.mention]"

	return null

/proc/discord_log_cache_selection(selection_key, relative_dir, list/entries)
	if(!selection_key)
		return

	discord_log_cleanup_selections()
	GLOB.discord_log_selection_cache[selection_key] = list(
		"relative_dir" = relative_dir,
		"entries" = entries,
		"expires_at" = world.realtime + ADMIN_DISCORD_LOG_SELECTION_TTL,
	)

/proc/discord_log_get_cached_entry(selection_key, selection_text)
	discord_log_cleanup_selections()

	if(!selection_key)
		return null

	var/list/cache_data = GLOB.discord_log_selection_cache[selection_key]
	if(!islist(cache_data))
		return null

	var/list/entries = cache_data["entries"]
	if(!islist(entries))
		return null

	var/selection_index = text2num(selection_text)
	if(isnull(selection_index) || selection_index < 1 || selection_index > entries.len)
		return null

	var/list/entry_data = entries[selection_index]
	if(!islist(entry_data))
		return null

	return entry_data

/proc/discord_log_normalize_webhook_url(raw_webhook_url)
	if(!istext(raw_webhook_url))
		return null

	var/webhook_url = trim(raw_webhook_url)
	if(!webhook_url)
		return null

	if(length(webhook_url) >= 2)
		var/first_char = copytext(webhook_url, 1, 2)
		var/last_char = copytext(webhook_url, length(webhook_url), length(webhook_url) + 1)
		if((first_char == "\"" && last_char == "\"") || (first_char == "'" && last_char == "'") || (first_char == "<" && last_char == ">"))
			webhook_url = trim(copytext(webhook_url, 2, length(webhook_url)))

	if(!webhook_url)
		return null

	if(findtext(webhook_url, "http://") == 1 || findtext(webhook_url, "https://") == 1)
		return webhook_url

	if(findtext(webhook_url, " ") || findtext(webhook_url, "\n") || findtext(webhook_url, ascii2text(13)))
		return FALSE

	if(copytext(webhook_url, 1, 3) == "//" && findtext(webhook_url, "/api/webhooks/"))
		return "https:[webhook_url]"

	if(copytext(webhook_url, 1, 2) == "/" && findtext(webhook_url, "/api/webhooks/"))
		return "https://discord.com[webhook_url]"

	if(findtext(webhook_url, "/api/webhooks/"))
		return "https://[webhook_url]"

	return FALSE

/proc/discord_log_upload_webhook_url()
	return discord_log_normalize_webhook_url(CONFIG_GET(string/admin_logs_webhook_url))

/proc/discord_log_upload_file_to_discord(full_path, relative_path, issued_by)
	if(!fexists(full_path))
		return list(
			"success" = FALSE,
			"message" = "Log `[relative_path]` was not found.",
		)

	var/webhook_url = discord_log_upload_webhook_url()
	if(isnull(webhook_url))
		return list(
			"success" = FALSE,
			"message" = "Discord file upload is not configured.",
		)
	if(!istext(webhook_url) || !webhook_url)
		return list(
			"success" = FALSE,
			"message" = "Discord file upload is misconfigured. Set `ADMIN_LOGS_WEBHOOK_URL` to a full Discord webhook URL.",
		)

	var/log_text = file2text(file(full_path))
	if(isnull(log_text))
		return list(
			"success" = FALSE,
			"message" = "Log `[relative_path]` could not be read.",
		)

	var/list/path_bits = splittext(relative_path, "/")
	var/file_name = path_bits[path_bits.len]
	file_name = replacetext(file_name, "\"", "'")

	var/boundary = "---------------------------[GUID()]"
	var/crlf = "[ascii2text(13)]\n"
	var/payload_json = json_encode(list(
		"content" = "`[issued_by]` requested `[relative_path]`",
	))

	var/list/body_parts = list(
		"--[boundary]",
		"Content-Disposition: form-data; name=\"payload_json\"",
		"Content-Type: application/json",
		"",
		payload_json,
		"--[boundary]",
		"Content-Disposition: form-data; name=\"files[0]\"; filename=\"[file_name]\"",
		"Content-Type: text/plain; charset=utf-8",
		"",
		log_text,
		"--[boundary]--",
		"",
	)

	var/target_url = webhook_url
	if(findtext(target_url, "?"))
		target_url += "&wait=true"
	else
		target_url += "?wait=true"

	var/datum/http_request/request = http_request(
		"POST",
		target_url,
		jointext(body_parts, crlf),
		list("Content-Type" = "multipart/form-data; boundary=[boundary]"),
	)
	request.execute_blocking()

	var/datum/http_response/response = request.into_response()
	if(response.errored)
		return list(
			"success" = FALSE,
			"message" = "Discord upload failed for `[relative_path]`: [response.error]",
		)

	if(!isnum(response.status_code) || response.status_code < 200 || response.status_code >= 300)
		var/error_text = response.body ? trim("[response.body]") : "HTTP [response.status_code]"
		if(length(error_text) > 300)
			error_text = copytext(error_text, 1, 301) + "..."

		return list(
			"success" = FALSE,
			"message" = "Discord rejected `[relative_path]` ([response.status_code]): [error_text]",
		)

	return list(
		"success" = TRUE,
		"message" = "Uploaded `[relative_path]` to Discord.",
	)

/proc/discord_log_build_url(token)
	var/base_url = discord_log_public_base_url()
	var/separator = findtext(base_url, "?") ? "&" : "?"
	return "[base_url][separator]discord_log=[token]"

/proc/discord_log_relative_current_directory()
	if(!GLOB.log_directory)
		return null

	if(findtext(GLOB.log_directory, "data/logs/") == 1)
		return copytext(GLOB.log_directory, length("data/logs/") + 1)

	return GLOB.log_directory

/proc/discord_log_register_file(full_path, relative_path, issued_by)
	discord_log_cleanup_tokens()

	var/list/path_bits = splittext(relative_path, "/")
	var/file_name = path_bits[path_bits.len]
	var/token = md5("[full_path]-[relative_path]-[issued_by]-[world.realtime]-[rand(1, 2147483647)]")
	GLOB.discord_log_download_tokens[token] = list(
		"path" = full_path,
		"relative_path" = relative_path,
		"name" = file_name,
		"issued_by" = issued_by,
		"expires_at" = world.realtime + ADMIN_DISCORD_LOG_LINK_TTL,
	)
	return token

/proc/discord_log_build_file_line(full_path, relative_path, issued_by)
	if(!fexists(full_path))
		return null

	var/token = discord_log_register_file(full_path, relative_path, issued_by)
	var/list/path_bits = splittext(relative_path, "/")
	var/file_name = path_bits[path_bits.len]
	return "- [file_name]: <[discord_log_build_url(token)]>"

/proc/discord_log_link_response(full_path, relative_path, issued_by, failure_message = null)
	if(!fexists(full_path))
		return "Log `[relative_path]` was not found."

	var/token = discord_log_register_file(full_path, relative_path, issued_by)
	var/link_message = "Temporary log link for `[relative_path]` (expires in 10 minutes): <[discord_log_build_url(token)]>"
	if(failure_message)
		return "[failure_message]\n[link_message]"

	return link_message

/proc/discord_log_file_response(full_path, relative_path, issued_by)
	if(copytext(relative_path, length(relative_path), length(relative_path) + 1) == "/")
		return "Use `logs list [relative_path]` or `logs browse <number>` for directories."

	if(!fexists(full_path))
		return "Log `[relative_path]` was not found."

	var/list/upload_result = discord_log_upload_file_to_discord(full_path, relative_path, issued_by)
	if(islist(upload_result))
		if(upload_result["success"])
			return upload_result["message"]

		return discord_log_link_response(full_path, relative_path, issued_by, upload_result["message"])

	return discord_log_link_response(full_path, relative_path, issued_by)

/proc/discord_log_directory_response(relative_dir, issued_by, selection_key = null, label = null)
	if(relative_dir)
		while(copytext(relative_dir, length(relative_dir), length(relative_dir) + 1) == "/")
			relative_dir = copytext(relative_dir, 1, length(relative_dir))

	var/full_dir = relative_dir ? "data/logs/[relative_dir]" : "data/logs"
	var/list/entries = flist("[full_dir]/")
	if(!islist(entries))
		return "Directory `[relative_dir ? relative_dir : "data/logs"]` was not found."

	entries = sortList(entries)
	var/display_dir = relative_dir ? "data/logs/[relative_dir]/" : "data/logs/"

	var/list/lines = list()
	var/list/cached_entries = list()
	if(label)
		lines += label
	else
		lines += "Entries under `[display_dir]`"

	lines += "Use `logs browse <number>` for directories and `logs get <number>` for files."

	var/rendered = 0
	for(var/entry in entries)
		if(!entry)
			continue

		if(rendered >= ADMIN_DISCORD_LOG_LIST_LIMIT)
			lines += "... truncated after [ADMIN_DISCORD_LOG_LIST_LIMIT] entries."
			break

		var/is_directory = copytext(entry, length(entry), length(entry) + 1) == "/"
		var/entry_name = is_directory ? copytext(entry, 1, length(entry)) : entry
		var/child_relative = relative_dir ? "[relative_dir]/[entry_name]" : entry_name
		cached_entries += list(list(
			"relative_path" = child_relative,
			"is_directory" = is_directory,
		))

		if(is_directory)
			lines += "[rendered + 1]. [entry_name]/"
		else
			lines += "[rendered + 1]. [entry_name]"

		rendered++

	if(!rendered)
		lines += "(empty)"
	else
		discord_log_cache_selection(selection_key, relative_dir, cached_entries)

	lines += "Selections expire in 15 minutes."
	return lines.Join("\n")

/proc/discord_log_cached_selection_response(datum/tgs_chat_user/sender, issued_by, selection_text, browse_mode)
	var/selection_key = discord_log_command_key(sender)
	var/list/entry_data = discord_log_get_cached_entry(selection_key, selection_text)
	if(!islist(entry_data))
		return "Selection `[selection_text]` was not found. Run `logs` or `logs list <dir>` first."

	var/relative_path = entry_data["relative_path"]
	var/is_directory = entry_data["is_directory"]
	if(browse_mode)
		if(!is_directory)
			return "Selection `[selection_text]` is a file. Use `logs get [selection_text]`."

		return discord_log_directory_response(relative_path, issued_by, selection_key)

	if(is_directory)
		return "Selection `[selection_text]` is a directory. Use `logs browse [selection_text]`."

	return discord_log_file_response("data/logs/[relative_path]", relative_path, issued_by)

/proc/discord_log_render_error_page(title, message)
	var/safe_title = html_encode(title)
	var/safe_message = html_encode(message)
	var/list/page = list()
	page += "<!doctype html>"
	page += "<html><head><meta charset='utf-8'>"
	page += "<meta name='robots' content='noindex,nofollow'>"
	page += "<title>[safe_title]</title>"
	page += "<style>body{margin:0;padding:2rem;background:#111827;color:#f3f4f6;font:16px/1.5 Consolas,Monaco,monospace}main{max-width:980px;margin:0 auto}h1{font-size:1.4rem}p{color:#d1d5db}</style>"
	page += "</head><body><main>"
	page += "<h1>[safe_title]</h1>"
	page += "<p>[safe_message]</p>"
	page += "</main></body></html>"
	return page.Join("")

/proc/discord_log_render_log_page(list/token_data)
	var/full_path = token_data["path"]
	if(!full_path || !fexists(full_path))
		return discord_log_render_error_page("Log unavailable", "The requested log file is no longer available.")

	var/log_text = file2text(file(full_path))
	if(isnull(log_text))
		return discord_log_render_error_page("Log unavailable", "The requested log file could not be read.")

	var/relative_path = "[token_data["relative_path"]]"
	var/file_name = "[token_data["name"]]"
	var/safe_relative_path = html_encode(relative_path)
	var/safe_file_name = html_encode(file_name)
	var/safe_log_text = html_encode(log_text)
	var/file_name_json = json_encode(file_name)

	var/list/page = list()
	page += "<!doctype html>"
	page += "<html><head><meta charset='utf-8'>"
	page += "<meta name='robots' content='noindex,nofollow'>"
	page += "<title>[safe_file_name]</title>"
	page += "<style>body{margin:0;background:#0f172a;color:#e2e8f0;font:15px/1.5 Consolas,Monaco,monospace}main{max-width:1400px;margin:0 auto;padding:1.5rem}header{display:flex;justify-content:space-between;gap:1rem;align-items:center;flex-wrap:wrap;margin-bottom:1rem}button{border:0;border-radius:.5rem;background:#22c55e;color:#052e16;padding:.8rem 1rem;font:600 14px/1.2 system-ui;cursor:pointer}button:hover{background:#4ade80}code{background:#1e293b;border-radius:.35rem;padding:.15rem .35rem}pre{white-space:pre-wrap;word-break:break-word;background:#020617;border:1px solid #1e293b;border-radius:.75rem;padding:1rem;overflow:auto}</style>"
	page += "</head><body><main>"
	page += "<header><div><h1>[safe_file_name]</h1><p>Temporary view for <code>[safe_relative_path]</code></p></div>"
	page += "<button type='button' id='download-log'>Download log</button></header>"
	page += "<pre id='log-data'>[safe_log_text]</pre>"
	page += "<script>const fileName = [file_name_json];const logNode=document.getElementById('log-data');document.getElementById('download-log').addEventListener('click',()=>{const blob=new Blob(\[logNode.textContent\],{type:'text/plain;charset=utf-8'});const url=URL.createObjectURL(blob);const link=document.createElement('a');link.href=url;link.download=fileName;document.body.appendChild(link);link.click();link.remove();setTimeout(()=>URL.revokeObjectURL(url),0);});</script>"
	page += "</main></body></html>"
	return page.Join("")

/proc/discord_log_command_response(datum/tgs_chat_user/sender, params)
	var/issuer = "unknown"
	if(sender && sender.friendly_name)
		issuer = sender.friendly_name

	var/selection_key = discord_log_command_key(sender)
	params = trim(params)
	if(!params)
		var/current_relative = discord_log_relative_current_directory()
		if(current_relative)
			return discord_log_directory_response(current_relative, issuer, selection_key, "Current round log directory: `data/logs/[current_relative]/`")
		return discord_log_directory_response("", issuer, selection_key)

	log_admin("Chat log access: [issuer] ran `logs [params]`.")

	var/first_space = findtext(params, " ")
	var/subcommand = first_space ? lowertext(copytext(params, 1, first_space)) : lowertext(params)
	var/rest = first_space ? trim(copytext(params, first_space + 1)) : ""

	switch(subcommand)
		if("current")
			var/current_relative = discord_log_relative_current_directory()
			if(!current_relative)
				return "The current round log directory is not available yet."

			if(!rest)
				return discord_log_directory_response(current_relative, issuer, selection_key, "Current round log directory: `data/logs/[current_relative]/`")

			var/current_target = discord_log_normalize_relative_path(rest)
			if(isnull(current_target) || !current_target)
				return "Provide a file path relative to the current round, for example `logs current game.log`."

			return discord_log_file_response("[GLOB.log_directory]/[current_target]", "[current_relative]/[current_target]", issuer)

		if("list")
			var/relative_dir = discord_log_normalize_relative_path(rest)
			if(isnull(relative_dir))
				return "That directory path is not allowed."

			return discord_log_directory_response(relative_dir, issuer, selection_key)

		if("browse")
			if(!rest)
				return "Provide an entry number from the last list, for example `logs browse 2`."

			return discord_log_cached_selection_response(sender, issuer, rest, TRUE)

		if("get")
			if(!rest)
				return "Provide an entry number from the last list, for example `logs get 5`."

			return discord_log_cached_selection_response(sender, issuer, rest, FALSE)

		if("path")
			var/relative_file = discord_log_normalize_relative_path(rest)
			if(isnull(relative_file) || !relative_file)
				return "Provide a file path under `data/logs`, for example `logs path 2026/03/10/round-123/runtime.log`."

			return discord_log_file_response("data/logs/[relative_file]", relative_file, issuer)

	return discord_log_usage_text()

/datum/world_topic/discord_log
	keyword = "discord_log"
	log = FALSE

/datum/world_topic/discord_log/Run(list/input)
	discord_log_cleanup_tokens()

	var/token = trim(input[keyword])
	if(!token)
		return discord_log_render_error_page("Missing token", "No log token was provided.")

	var/list/token_data = GLOB.discord_log_download_tokens[token]
	if(!islist(token_data) || !token_data["expires_at"] || token_data["expires_at"] <= world.realtime)
		GLOB.discord_log_download_tokens -= token
		return discord_log_render_error_page("Link expired", "This temporary log link is invalid or has expired.")

	return discord_log_render_log_page(token_data)

/datum/tgs_chat_command/logs
	name = "logs"
	help_text = "current \[file\] | list \[relative_dir\] | browse <number> | get <number> | path <relative_file>"
	admin_only = TRUE

/datum/tgs_chat_command/logs/Run(datum/tgs_chat_user/sender, params)
	return new /datum/tgs_message_content(discord_log_command_response(sender, params))

#undef ADMIN_DISCORD_LOG_LINK_TTL
#undef ADMIN_DISCORD_LOG_LIST_LIMIT
#undef ADMIN_DISCORD_LOG_SELECTION_TTL
