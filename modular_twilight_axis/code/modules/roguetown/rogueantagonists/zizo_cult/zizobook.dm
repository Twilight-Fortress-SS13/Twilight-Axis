/obj/item/recipe_book/zizo
	name = "The Tome: ???"
	icon = 'modular_twilight_axis/lore/icons/books.dmi'
	icon_state = "zizo_guide_0"
	base_icon_state = "zizo_guide"
	current_category = "Всё"
	var/bg_rsc = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/zizo_book.png'
	var/bg_name = "zizo_book.png"
	types = list(
	/datum/ritual,	
	)

/obj/item/recipe_book/zizo/generate_categories()
	categories = list("Всё") // Reset and add default

	// Gather categories from recipes themselves
	for(var/atom/path as anything in types)
		if(is_abstract(path))
			// Handle abstract types
			for(var/atom/sub_path as anything in subtypesof(path))
				if(is_abstract(sub_path))
					continue

				var/category = get_recipe_category(sub_path)
				if(category && !(category in categories))
					categories += category
		else
			// Handle non-abstract types directly
			var/category = get_recipe_category(path)
			if(category && !(category in categories))
				categories += category

/obj/item/recipe_book/zizo/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client

	user << browse_rsc(bg_rsc, bg_name)

	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>

		<style>
			@import url('https://fonts.googleapis.com/css2?family=Charm:wght@700&display=swap');
			body {
				font-family: 'Cinzel', serif;
				font-size: 1em;
				text-align: center;
				margin: 20px;
				color: #f1f1f1;
				background-color: rgb(31, 20, 24);
				background-image: url('[bg_name]');
				background-repeat: no-repeat;
				background-attachment: fixed;
				background-size: 100% 100%;
			}
			h1, h2, h3 {
				font-family: 'Cinzel', serif;
				color: #ff4c4c;
				text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.6);
			}
			h1 {
				font-size: 2.5em;
				margin-bottom: 20px;
			}
			h2 {
				font-size: 1.8em;
				margin-bottom: 15px;
			}
			h3 {
				font-size: 1.3em;
				color: #f1f1f1;
			}
			.recipe-title {
				font-size: 2em;
				margin-bottom: 15px;
				border-bottom: 1px solid #3e2723;
				padding-bottom: 5px;
				color: #ff4c4c;
			}
			.book-content {
				display: flex;
				height: 85%;
			}
			.sidebar {
				width: 30%;
				padding: 10px;
				border-right: 2px solid #3e2723;
				overflow-y: auto;
				max-height: 600px;
			}
			.main-content {
				width: 70%;
				padding: 10px;
				overflow-y: auto;
				max-height: 600px;
				text-align: left;
			}
			.categories {
				margin-bottom: 15px;
			}
			.category-btn {
				margin: 2px;
				padding: 5px;
				background-color: #d2b48c;
				border: 1px solid #3e2723;
				border-radius: 5px;
				cursor: pointer;
				font-family: 'Cinzel', serif;
			}
			.category-btn.active {
				background-color: #8b4513;
				color: white;
			}
			.search-box {
				width: 90%;
				padding: 5px;
				margin-bottom: 15px;
				border: 1px solid #3e2723;
				border-radius: 5px;
				font-family: 'Cinzel', serif;
			}
			.recipe-list {
				text-align: left;
			}
			.recipe-link {
				display: block;
				padding: 5px;
				color: #f1f1f1;
				text-decoration: none;
				border-bottom: 1px dotted #d2b48c;
			}
			.recipe-link:hover {
				background-color: rgba(210, 180, 140, 0.3);
			}
			.recipe-content {
				padding: 10px;
			}
			.back-btn {
				margin-top: 10px;
				padding: 5px 10px;
				background-color: #d2b48c;
				border: 1px solid #3e2723;
				border-radius: 5px;
				cursor: pointer;
				font-family: 'Cinzel', serif;
			}
			.no-matches {
				font-style: italic;
				color: #8b4513;
				padding: 10px;
				text-align: center;
				display: none;
			}
			/* Styles to match the original recipe display */
			table {
				margin: 10px auto;
				border-collapse: collapse;
			}
			table, th, td {
				border: 1px solid #3e2723;
			}
			th, td {
				padding: 8px;
				text-align: left;
			}
			th {
				background-color: rgba(210, 180, 140, 0.3);
			}
			.hidden {
				display: none;
			}
		</style>
	
		<body>
			<h1>Книга Темных Ритуалов</h1>
	
			<div class='book-content'>
				<div class='sidebar'>
					<!-- Search box (now with live filtering) -->
					<input type='text' class='search-box' id='searchInput'
						placeholder='Поиск ритуалов...' value='[search_query]'>
	
					<!-- Categories -->
					<div class='categories'>
	"}

	// Add category buttons with direct links
	for(var/category in categories)
		var/active_class = category == current_category ? "active" : ""
		html += "<button class='category-btn [active_class]' onclick=\"location.href='byond://?src=\ref[src];action=set_category&category=[url_encode(category)]'\">[category]</button>"

	html += {"
					</div>

					<!-- Recipe List -->
					<div class="recipe-list" id="recipeList">
	"}

	// Add recipes based on current category
	for(var/atom/path as anything in types)
		if(is_abstract(path))
			var/list/sorted_types = sortNames(subtypesof(path)) // Edit vs Vander lin - Sort
			for(var/atom/sub_path as anything in sorted_types)
				if(is_abstract(sub_path))
					continue
				if(!sub_path.name) // Also skip if there's no names
					continue

				if(ispath(sub_path, /datum/crafting_recipe))
					var/datum/crafting_recipe/recipe = sub_path
					if(initial(recipe.hides_from_books))
						continue
				if(ispath(sub_path, /datum/anvil_recipe))
					var/datum/anvil_recipe/recipe = sub_path
					if(initial(recipe.hides_from_books))
						continue

				var/recipe_name = initial(sub_path.name)

				// Check if this recipe belongs to the current category
				var/should_show = TRUE
				if(current_category != "Всё")
					var/category = get_recipe_category(sub_path)
					if(category != current_category)
						should_show = FALSE

				// Default display style - will be changed by JS if searching
				var/display_style = should_show ? "" : "display: none;"

				html += "<a class='recipe-link' href='byond://?src=\ref[src];action=view_recipe&recipe=[sub_path]' style='[display_style]'>[recipe_name]</a>"
		else
			var/recipe_name = initial(path.name)

			// Check if this recipe belongs to the current category
			var/should_show = TRUE
			if(current_category != "Всё")
				var/category = get_recipe_category(path)
				if(category != current_category)
					should_show = FALSE

			// Default display style - will be changed by JS if searching
			var/display_style = should_show ? "" : "display: none;"

			html += "<a class='recipe-link' href='byond://?src=\ref[src];action=view_recipe&recipe=[path]' style='[display_style]'>[recipe_name]</a>"

	html += {"
						<div id="noMatchesMsg" class="no-matches">No matching recipes found.</div>
					</div>
				</div>

				<div class="main-content" id="mainContent">
	"}

	// If a recipe is selected, show its details
	if(current_recipe)
		html += generate_recipe_html(current_recipe, user)
	else
		html += "<div class='recipe-content'><p>Выберите ритуал для просмотра его описания и требований к проведению.</p></div>"

	html += {"
				</div>
			</div>

			<script>
				// Live search functionality with debouncing
				let searchTimeout;
				document.getElementById('searchInput').addEventListener('keyup', function(e) {
					clearTimeout(searchTimeout);

					// Debounce the search to improve performance (only search after typing stops for 300ms)
					searchTimeout = setTimeout(function() {
						const query = document.getElementById('searchInput').value.toLowerCase();
						filterRecipes(query);
					}, 300);
				});

				function filterRecipes(query) {
					const recipeLinks = document.querySelectorAll('.recipe-link');
					const currentCategory = "[current_category]";
					let anyVisible = false;

					recipeLinks.forEach(function(link) {
						const recipeName = link.textContent.toLowerCase();

						// Check if it matches the search query
						const matchesQuery = query === '' || recipeName.includes(query);

						// If we have both a query and active category, respect both filters
						if (matchesQuery) {
							link.style.display = 'block';
							anyVisible = true;
						} else {
							link.style.display = 'none';
						}
					});

					// Show a message if no recipes match
					const noMatchesMsg = document.getElementById('noMatchesMsg');
					noMatchesMsg.style.display = anyVisible ? 'none' : 'block';

					// Remember the query
					window.location.replace(`byond://?src=\\ref[src];action=remember_query&query=${encodeURIComponent(query)}`);
				}

				// Initialize search based on any current query
				if ("[search_query]" !== "") {
					filterRecipes("[search_query]".toLowerCase());
				}
			</script>
		</body>
		</html>
	"}

	return html

/obj/item/recipe_book/zizo/proc/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return

/obj/item/recipe_book/zizo/attack_self(mob/user)
	if(!open)
		attack_right(user)
		return
	..()
	user.update_inv_hands()

/obj/item/recipe_book/zizo/rmb_self(mob/user)
	attack_right(user)
	return

/obj/item/recipe_book/zizo/read(mob/user)
	if(!open)
		to_chat(user, span_info("Open me first."))
		return FALSE

/obj/item/recipe_book/zizo/attack_right(mob/user)
	if(!open)
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(loc, 'sound/items/book_open.ogg', 100, FALSE, -1)
	else
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(loc, 'sound/items/book_close.ogg', 100, FALSE, -1)
	update_icon()
	user.update_inv_hands()

/obj/item/recipe_book/zizo/update_icon()
	icon_state = "[base_icon_state]_[open]"

/datum/ritual/proc/generate_html(mob/user)
	var/html = ""
	html += "<h2 class='recipe-title'>[name]</h2>"
	html += "<p>[desk]</p>"
	html += "<h3>Требования к ритуалу:</h3>"
	html += "<ul>"
	
	if(center_requirement)
		if(center_book != null)
			html += "<li><b>Центр:</b> [center_book]</li>"
		else if(ispath(center_requirement, /mob/living/carbon/human))
			html += "<li><b>Центр:</b> Живой человек</li>"
		else if(ispath(center_requirement, /mob))
			html += "<li><b>Центр:</b> Живое животное</li>"
		else
			var/atom/center_item = new center_requirement()
			html += "<li><b>Центр:</b> [icon2html(center_item, user)] [center_item.name]</li>"
			qdel(center_item)
	
	if(n_req)
		if(north_book != null)
			html += "<li><b>Север:</b> [north_book]</li>"
		else if(ispath(n_req, /mob/living/carbon/human))
			html += "<li><b>Север:</b> Живой человек</li>"
		else if(ispath(n_req, /mob))
			html += "<li><b>Север:</b> Живое животное</li>"
		else
			var/atom/n_item = new n_req()
			html += "<li><b>Север:</b> [icon2html(n_item, user)] [n_item.name]</li>"
			qdel(n_item)
	
	if(e_req)
		if(east_book != null)
			html += "<li><b>Восток:</b> [east_book]</li>"
		else if(ispath(e_req, /mob/living/carbon/human))
			html += "<li><b>Восток:</b> Живой человекn</li>"
		else if(ispath(e_req, /mob))
			html += "<li><b>Восток:</b> Живое животное</li>"
		else
			var/atom/e_item = new e_req()
			html += "<li><b>Восток:</b> [icon2html(e_item, user)] [e_item.name]</li>"
			qdel(e_item)
	
	if(s_req)
		if(south_book != null)
			html += "<li><b>Юг:</b> [south_book]</li>"
		else if(ispath(s_req, /mob/living/carbon/human))
			html += "<li><b>Юг:</b> Живой человек</li>"
		else if(ispath(s_req, /mob))
			html += "<li><b>Юг:</b> Живое животное</li>"
		else
			var/atom/s_item = new s_req()
			html += "<li><b>Юг:</b> [icon2html(s_item, user)] [s_item.name]</li>"
			qdel(s_item)
	
	if(w_req)
		if(west_book != null)
			html += "<li><b>Запад:</b> [west_book]</li>"
		else if(ispath(w_req, /mob/living/carbon/human))
			html += "<li><b>Запад:</b> Живой человек</li>"
		else if(ispath(w_req, /mob))
			html += "<li><b>Запад:</b> Живое животное</li>"
		else
			var/atom/w_item = new w_req()
			html += "<li><b>Запад:</b> [icon2html(w_item, user)] [w_item.name]</li>"
			qdel(w_item)
	
	if(cultist_number > 0)
		html += "<li><b>Требуется культистов:</b> [cultist_number] (минимум)</li>"
	
	if(is_cultist_ritual)
		html += "<li><i>Этот ритуал доступен лишь культистам.</i></li>"
	
	if(ritual_limit > 0)
		html += "<li><b>Limit:</b>Возможное количество проведенных ритуалов: [ritual_limit]"
		if(number_cultist_for_add_limit > 0)
			html += " (+1 к количеству за [number_cultist_for_add_limit] культистов)"
		html += ".</li>"
	
	html += "</ul>"
	html += "<p><em>Примечание: Разложите предметы на руне, как указано в требованиях. Ритуал сработает при активации, если выполнены все требования.</em></p>"
	return html
