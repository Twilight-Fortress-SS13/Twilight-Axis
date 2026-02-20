// WHISPER OF FEVER - Disease compendium book for physicians and plaguebearers

/obj/item/book/rogue/disease_compendium
	parent_type = /obj/item/recipe_book
	name = "Шепот лихорадки"
	desc = "Потрепанный фолиант в темно-фиолетовой обложке. На страницах подробно описаны симптомы, стадии и методы лечения различных болезней, поражающих жителей Псидонии. Пахнет горькими травами и старым пергаментом."
	icon = 'modular_twilight_axis/icons/objects/disease_compendium.dmi'
	icon_state = "curebook_0"
	base_icon_state = "curebook"
	open = FALSE
	current_category = "Всё"
	var/bg_rsc = 'modular_twilight_axis/html/disease_compendium_bg.png'
	var/bg_name = "disease_compendium_bg.png"
	slot_flags = ITEM_SLOT_HIP

	types = list(
		/datum/book_entry/disease_compendium/preface,
		/datum/book_entry/disease_compendium/nature,
		/datum/book_entry/disease_compendium/plague,
		/datum/book_entry/disease_compendium/vision_rot,
		/datum/book_entry/disease_compendium/ash_blight,
		/datum/book_entry/disease_compendium/blood_rot,
		/datum/book_entry/disease_compendium/grime_flu,
		/datum/book_entry/disease_compendium/flash_frenzy,
		/datum/book_entry/disease_compendium/derma_tick,
		/datum/book_entry/disease_compendium/flu,
		/datum/book_entry/disease_compendium/conclusion,
	)

/obj/item/book/rogue/disease_compendium/New()
	. = ..()
	update_icon()

/obj/item/book/rogue/disease_compendium/generate_categories()
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

/obj/item/book/rogue/disease_compendium/attack_self(mob/user)
	if(!open)
		// Toggle open state
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(loc, 'sound/items/book_open.ogg', 100, FALSE, -1)
		update_icon()
		user.update_inv_hands()
		return
	. = ..() // Open the recipe book UI
	user.update_inv_hands()

/obj/item/book/rogue/disease_compendium/rmb_self(mob/user)
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
	return

/obj/item/book/rogue/disease_compendium/update_icon()
	icon_state = "[base_icon_state]_[open]"

/obj/item/book/rogue/disease_compendium/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client

	user << browse_rsc(bg_rsc, bg_name)

	var/html = {"
		<!DOCTYPE html>
		<html lang=\"en\">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>

		<style>
			@import url('https://fonts.googleapis.com/css2?family=Charm:wght@700&family=Cinzel:wght@600&display=swap');
			body {
				font-family: 'Cinzel', serif;
				font-size: 1em;
				text-align: center;
				margin: 20px;
				color: #000000;
				background-color: rgb(31, 20, 24);
				background-image: url('[bg_name]');
				background-repeat: no-repeat;
				background-attachment: fixed;
				background-size: 100% 100%;
			}
			h1, h2, h3 {
				font-family: 'Cinzel', serif;
				color: #000000;
				text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.6);
			}
			h1 {
				font-size: 2.2em;
				margin-bottom: 20px;
			}
			h2 {
				font-size: 1.8em;
				margin-bottom: 15px;
			}
			h3 {
				font-size: 1.3em;
				color: #000000;
			}
			.recipe-title {
				font-size: 2em;
				margin-bottom: 15px;
				border-bottom: 1px solid #3e2723;
				padding-bottom: 5px;
				color: #d8b5e6;
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
				background-color: #6a2b7a;
				color: #ffffff;
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
				color: #000000;
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
			<h1>Шепот лихорадки</h1>
	
			<div class='book-content'>
				<div class='sidebar'>
					<input type='text' class='search-box' id='searchInput'
						placeholder='Поиск разделов...' value='[search_query]'>
	
					<div class='categories'>
	"}

	for(var/category in categories)
		var/active_class = category == current_category ? "active" : ""
		html += "<button class='category-btn [active_class]' onclick=\"location.href='byond://?src=\ref[src];action=set_category&category=[url_encode(category)]'\">[category]</button>"

	html += {"
					</div>

					<div class=\"recipe-list\" id=\"recipeList\">
	"}

	for(var/atom/path as anything in types)
		if(is_abstract(path))
			var/list/sorted_types = sortNames(subtypesof(path))
			for(var/atom/sub_path as anything in sorted_types)
				if(is_abstract(sub_path))
					continue
				if(!sub_path.name)
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

				var/should_show = TRUE
				if(current_category != "Всё")
					var/category = get_recipe_category(sub_path)
					if(category != current_category)
						should_show = FALSE

				var/display_style = should_show ? "" : "display: none;"

				html += "<a class='recipe-link' href='byond://?src=\ref[src];action=view_recipe&recipe=[sub_path]' style='[display_style]'>[recipe_name]</a>"
		else
			var/recipe_name = initial(path.name)

			var/should_show = TRUE
			if(current_category != "Всё")
				var/category = get_recipe_category(path)
				if(category != current_category)
					should_show = FALSE

			var/display_style = should_show ? "" : "display: none;"

			html += "<a class='recipe-link' href='byond://?src=\ref[src];action=view_recipe&recipe=[path]' style='[display_style]'>[recipe_name]</a>"

	html += {"
						<div id=\"noMatchesMsg\" class=\"no-matches\">No matching entries found.</div>
					</div>
				</div>

				<div class=\"main-content\" id=\"mainContent\">
	"}

	if(current_recipe)
		// For book entries, use inner_book_html without duplicating the title
		if(ispath(current_recipe, /datum/book_entry))
			var/datum/book_entry/entry = new current_recipe()
			html += "<div class='recipe-content'>"
			html += entry.inner_book_html(user)
			html += "</div>"
			qdel(entry)
		else
			html += generate_recipe_html(current_recipe, user)
	else
		html += "<div class='recipe-content'><p>Выберите раздел для просмотра описания.</p></div>"

	html += {"
				</div>
			</div>

			<script>
				let searchTimeout;
				document.getElementById('searchInput').addEventListener('keyup', function(e) {
					clearTimeout(searchTimeout);

					searchTimeout = setTimeout(function() {
						const query = document.getElementById('searchInput').value.toLowerCase();
						filterEntries(query);
					}, 300);
				});

				function filterEntries(query) {
					const recipeLinks = document.querySelectorAll('.recipe-link');
					let anyVisible = false;

					recipeLinks.forEach(function(link) {
						const recipeName = link.textContent.toLowerCase();
						const matchesQuery = query === '' || recipeName.includes(query);

						if (matchesQuery) {
							link.style.display = 'block';
							anyVisible = true;
						} else {
							link.style.display = 'none';
						}
					});

					const noMatchesMsg = document.getElementById('noMatchesMsg');
					noMatchesMsg.style.display = anyVisible ? 'none' : 'block';

					window.location.replace(`byond://?src=\\ref[src];action=remember_query&query=${encodeURIComponent(query)}`);
				}

				if ("[search_query]" !== "") {
					filterEntries("[search_query]".toLowerCase());
				}
			</script>
		</body>
		</html>
	"}

	return html

/datum/book_entry/disease_compendium
	category = "Diseases"

/datum/book_entry/disease_compendium/preface
	name = "Предисловие"

/datum/book_entry/disease_compendium/preface/inner_book_html(mob/user)
	return {"
	<h3><center>ШЕПОТ ЛИХОРАДКИ</center></h3><br>
	<i>Компендиум Болезней и Недугов<br>
	Для изучения лекарями, апотекариями и врачевателями</i><br><br>
	<b>Предисловие:</b><br><br>
	В пыльных закоулках мира, где свет солнца едва достигает земли, где тени играют меж древних камней, там зреют болезни.
	Они шепчут свои имена больным, они ползают по венам как черви, они съедают плоть и разум.
	Болезнь - это не просто недомогание. Это проклятие, наказание, испытание.<br><br>
	Этот том содержит знания, собранные из бесчисленных наблюдений за страданиями.
	Каждая страница пропитана болью тех, кто пал жертвой этих недугов.
	Изучайте их, познавайте пути заразы, ибо только знание может противостоять смерти.<br><br>
	<i>- Составлено братством черного клюва</i>
	"}

/datum/book_entry/disease_compendium/nature
	name = "О природе болезней"

/datum/book_entry/disease_compendium/nature/inner_book_html(mob/user)
	return {"
	<h3><center>О Природе Болезней</center></h3><br>
	Болезни приходят многими путями. Некоторые передаются через прикосновение, другие - через воздух, что мы вдыхаем.
	Третьи скрываются в крови и жидкостях тела.<br><br>
	<b>Пути распространения:</b><br>
	• <b>Контактная передача</b> - через прикосновение к больному или его вещам<br>
	• <b>Воздушная передача</b> - через кашель и дыхание<br>
	• <b>Кровяная передача</b> - через раны и порезы<br>
	• <b>Жидкостная передача</b> - через слюну, пот и другие выделения<br><br>
	<b>Защита от заразы:</b><br>
	Маска лекаря (Physician's Mask) обеспечивают надежную защиту от контактной передачи болезней.
	Они не пропускают миазмы и защищают от прикосновения зараженных.
	Также простая маска (rag mask) поможет защититься от болезней, но не так эффективно.<br><br>
	<b>Стадии болезней:</b><br>
	Большинство болезней развиваются постепенно, проходя через несколько стадий.
	Ранняя диагностика и лечение могут спасти жизнь больному.
	"}

/datum/book_entry/disease_compendium/plague
	name = "Чума"

/datum/book_entry/disease_compendium/plague/inner_book_html(mob/user)
	return {"
	<h3><center>Чума (The Plague)</center></h3><br>
	<b>Описание:</b> Самая смертоносная из известных пандемий, поражающая все системы организма одновременно.
	Болезнь развивается стремительно и без лечения всегда приводит к смерти.<br><br>
	<b>Пути заражения:</b> Контакт с кожей, жидкости тела, кровь инфицированного<br><br>
	<b>СТАДИЯ I - Инкубация:</b><br>
	• Кожа покрывается бледными пятнами<br>
	• Легкое недомогание и слабость<br>
	• Озноб<br>
	• Периодический кашель<br>
	• Больной может чувствовать себя хорошо и не осознавать опасность<br><br>
	<b>СТАДИЯ II - Ранняя чума:</b><br>
	• Появление болезненных бубонов (воспаленных лимфатических узлов) и язв<br>
	• Лихорадка становится выраженной<br>
	• Сильная слабость, больной едва может двигаться<br>
	• Кожа приобретает землисто-черный оттенок<br>
	• Усиленный кашель, периодическая рвота<br>
	• Высокий риск передачи окружающим через воздух<br><br>
	<b>СТАДИЯ III - Развитая чума:</b><br>
	• Кожа чернеет и отмирает на больших участках<br>
	• Открытые кровоточащие раны и язвы<br>
	• Обширное внутреннее и внешнее кровотечение<br>
	• Постоянная рвота кровью<br>
	• Галлюцинации и помутнение сознания<br>
	• Боль практически невыносима<br><br>
	<b>СТАДИЯ IV - Терминальная стадия:</b><br>
	• ЛЕТАЛЬНО! Тело полностью поражено некрозом<br>
	• Запах разложения окружает больного<br>
	• Судороги и конвульсии<br>
	• Внутренние органы отказывают<br>
	• Сознание теряется<br>
	• Смерть наступает неизбежно<br><br>
	<b>ЛЕЧЕНИЕ:</b><br>
	Чума требует сложного двухэтапного лечения, проведенного срочно:<br><br>
	1. <b>Зелье: "Plague Cure (bottle)"</b><br>
	   Ингредиенты:<br>
	   • 5 золотой руды (Gold ore) - символизирует чистоту<br>
	   • 1 зверобой (Hypericum) - противовоспалительный<br>
	   • 1 сердце (Heart) - жизненная сила<br>
	   • 50 единиц воды (Water) - очищение<br>
	   • 1 стеклянная бутыль (Glass bottle) - для сосуда<br><br>
	2. <b>Хирургическая санация:</b><br>
	   • После приема зелья необходимо провести операцию<br>
	   • Разрез и вскрытие пораженных участков<br>
	   • Прижигание горячим инструментом для остановки кровотечения и предотвращения распространения<br>
	   • Операция вызывает невыносимую боль, но это необходимо<br><br>
	<b>ПРЕДУПРЕЖДЕНИЕ:</b> Без немедленного лечения на 4-й стадии смерть неизбежна в течение минут! Любое промедление гибельно!
	"}

/datum/book_entry/disease_compendium/vision_rot
	name = "Гниение зрения"

/datum/book_entry/disease_compendium/vision_rot/inner_book_html(mob/user)
	return {"
	<h3><center>Гниение зрения (Vision Rot)</center></h3><br>
	<b>Описание:</b> Дегенеративная болезнь, медленно разрушающая зрительный аппарат пациента.
	Жертвы страдают от периодических приступов потери зрения и помутнения.<br><br>
	<b>Пути заражения:</b> Контакт с биологическими жидкостями больного, непосредственный контакт с кожей<br><br>
	<b>СИМПТОМЫ:</b><br>
	• Периодическое помутнение зрения - картинка становится размытой<br>
	• Временная потеря цветового восприятия - мир видится в оттенках серого<br>
	• Приступы полной слепоты, длящиеся от нескольких секунд до минуты<br>
	• Боль в глазах и окружающих тканях<br>
	• Слезотечение и выделение гноя<br>
	• Редко - необратимое повреждение глаз<br><br>
	<b>ЛЕЧЕНИЕ:</b><br>
	• Болезнь проходит самостоятельно. Зрение постепенно восстанавливается полностью.<br><br>
	<b>ХИРУРГИЧЕСКОЕ ЛЕЧЕНИЕ:</b><br>
	Для ускоренного излечения можно провести операцию очистки глаз:<br>
	• Требуется скальпель для осторожного вскрытия и удаления пораженной ткани<br>
	• Операция выполняется на каждом глазу отдельно<br>
	• Вызывает значительную боль и может повредить зрение если проводится неумело<br>
	• План: разрез - очистка - прижигание для остановки кровотечения
	"}

/datum/book_entry/disease_compendium/ash_blight
	name = "Пепельная язва"

/datum/book_entry/disease_compendium/ash_blight/inner_book_html(mob/user)
	return {"
	<h3><center>Пепельная язва (Ash Blight)</center></h3><br>
	<b>Описание:</b> Контактная болезнь, вызывающая болезненную сыпь с пепельным налетом.
	Пораженный теряет работоспособность из-за нестерпимого зуда.<br><br>
	<b>Пути заражения:</b> Контакт с жидкостями тела и кожей больного<br><br>
	<b>СИМПТОМЫ:</b><br>
	• Кожа покрывается пепельными пятнами и открытыми язвами<br>
	• Образование отвратительной черной корки<br>
	• Нестерпимый зуд - больной постоянно чешется и не может себя контролировать<br>
	• При расчесывании язвы разрываются и кровят, что может привести к инфекции<br>
	• Риск вторичного инфицирования открытых ран<br>
	• Болезнь может передаться окружающим при тесном контакте<br><br>
	<b>ЛЕЧЕНИЕ:</b><br>
	Хирургическая санация пораженных участков:<br>
	• Разрез - осторожное вскрытие пораженной ткани<br>
	• Прижигание - использование горячего инструмента для очистки и дезинсекции<br>
	• Требуется скальпель, прижигатель (Cautery), святой крест или другой горячий инструмент<br>
	• Вызывает сильные ожоги и боль, но необходима для спасения жизни
	"}

/datum/book_entry/disease_compendium/blood_rot
	name = "Гниение крови"

/datum/book_entry/disease_compendium/blood_rot/inner_book_html(mob/user)
	return {"
	<h3><center>Гниение крови (Blood Rot)</center></h3><br>
	<b>Описание:</b> Паразитарное инфекционное заболевание, вызываемое кровяными паразитами. Посредине, они разеду инфицированную кровь.<br><br>
	<b>Пути заражения:</b> Укусы кровляных пиявок, прямой контакт с инфицированной кровью<br><br>
	<b>РАННЯЯ СТАДИЯ:</b><br>
	• Кожа начинает бледнеть<br>
	• Появляются темные пятна на коже - признак инфицирования<br>
	• Общее ослабление организма и утомляемость<br>
	• Периодическая тошнота и рвота<br>
	• Першание в горле, редкий кашель<br><br>
	<b>РАЗВИТАЯ СТАДИЯ:</b><br>
	• Темные прожилки становятся видны под кожей - паразиты путешествуют по венам<br>
	• Постоянная слабость, движения становятся медленными<br>
	• Выраженное истощение, жертва может едва ходить<br>
	• Частая рвота и непрекращающийся кашель<br>
	• Периодическое кровотечение из носа и рта - признак внутреннего повреждения<br><br>
	<b>ТЕРМИНАЛЬНАЯ СТАДИЯ:</b><br>
	• СМЕРТЕЛЬНО ОПАСНА!<br>
	• Кожа темнеет и приобретает неестественный цвет<br>
	• Тело издает запах гнили - ткани начинают отмирать изнутри<br>
	• Постоянная рвота кровью - внутренние органы разрушаются<br>
	• Периодическое массивное кровотечение<br>
	• Внутреннее непрекращающееся кровотечение - кровь медленно уходит<br><br>
	<b>ЛЕЧЕНИЕ:</b><br>
	Гниение крови требует специального метода удаления паразитов:<br><br>
	• Больного необходимо истощить кровопотерей - позволить организму потерять большую часть инфицированной крови<br>
	• К истощенному пациенту прикрепляется целебная пиявка<br>
	• Пиявка поглощает оставшихся паразитов и уничтожает инфекцию<br>
	• После успешного лечения - полное выздоровление и иммунитет на время<br><br>
	<b>ОПАСНОСТЬ:</b> Этот метод крайне рискован. Слишком большая кровопотеря может убить пациента раньше, чем пиявка сделает свое дело.
	Требуется постоянное наблюдение и готовность восстанавливать кровь жертвы путем переливания или питья восстанавливающих зелий.<br><br>
	<b>ПРЕДУПРЕЖДЕНИЕ:</b> Не пытайтесь лечить обычными методами!
	Только пиявка может высосать испорченную кровь.
	"}

/datum/book_entry/disease_compendium/grime_flu
	name = "Грязная лихорадка"

/datum/book_entry/disease_compendium/grime_flu/inner_book_html(mob/user)
	return {"
	<h3><center>Грязная лихорадка (The Grime-Flu)</center></h3><br>
	<b>Описание:</b> Распространенная инфекция, поражающая работоспособность организма.
	Развивается прогрессивно через несколько стадий.<br><br>
	<b>Пути заражения:</b> Контакт с жидкостями тела и выделениями больного, воздушно-капельный путь<br><br>
	<b>РАННЯЯ СТАДИЯ - Инкубация:</b><br>
	• Легкое недомогание, слабость в теле<br>
	• Едва заметные симптомы - больной может даже не заметить инфекцию<br><br>
	<b>РАЗВИВАЮЩАЯСЯ СТАДИЯ:</b><br>
	• Выраженная слабость - работоспособность резко падает<br>
	• Кашель, периодически заражающий окружающих<br>
	• Головная боль, размытие и затуманивание зрения<br>
	• Обезвоживание организма, жажда<br>
	• <b>Слабость в руках</b> - больной периодически роняет предметы из ослабевших рук<br><br>
	<b>ПРОГРЕССИРУЮЩАЯ СТАДИЯ:</b><br>
	• Критическая слабость - жертва едва может двигаться<br>
	• Острая боль в теле, периодический урон здоровью<br>
	• Частые падения из-за мышечной слабости в ногах<br>
	• Периодическая полная потеря цветового зрения - мир видится в сером<br>
	• Усиленный, непрекращающийся кашель<br><br>
	<b>ТЯЖЕЛАЯ ФОРМА:</b><br>
	• Глубокое истощение организма<br>
	• Кашель с кровью - опасный признак<br>
	• Кровотечение и внутренние повреждения<br>
	• Острая нехватка кислорода - жертва с трудом дышит<br>
	• Дальнейшее истощение может привести к смерти<br><br>
	<b>ЛЕЧЕНИЕ:</b><br>
	Грязная лихорадка поддается алхимическому лечению.:<br><br>
	1. <b>Зелье, создается на алхимической станции: "The Grime-Flu cure"</b><br>
	   Ингредиенты:<br>
	   • 1 листья мяты (Mentha) - успокаивают дыхательные пути<br>
	   • 1 зверобой (Hypericum) - противовоспалительный эффект<br>
	   • 50 единиц чистой воды (Water) - основа<br>
	   • 1 стеклянная бутыль (Glass bottle) - для сосуда<br><br>
	<b>Применение:</b><br>
	• Больной должен выпить зелье<br>
	• Болезнь излечивается быстро<br>
	• После излечения - период иммунитета против повторного заражения<br><br>
	<b>ПРИМЕЧАНИЕ:</b> Это редкий случай болезни, которую можно вылечить простым зельем без требования хирургии.
	Рекомендуется всегда иметь запас этого средства в лекарне для быстрого лечения.
	Зелье готовится на алхимической станции и требует мастерства уровня подмастерья (Apprentice Alchemy).
	"}

/datum/book_entry/disease_compendium/flash_frenzy
	name = "Вспышка безумия"

/datum/book_entry/disease_compendium/flash_frenzy/inner_book_html(mob/user)
	return {"
	<h3><center>Вспышка безумия (Flash Frenzy)</center></h3><br>
	<b>Описание:</b> Опасное психическое заболевание, вызывающее периодические приступы неконтролируемой ярости.
	Болезнь поражает разум, наполняя его гневом и жаждой крови.<br><br>
	<b>Пути заражения:</b> Контакт с жидкостями тела инфицированного, контакт с кожей<br><br>
	<b>СИМПТОМЫ:</b><br>
	• Берцовая раздражительность между приступами<br>
	• Периодические вспышки неконтролируемой ярости<br>
	• Во время приступа:<br>
	  - Глаза наливаются кровью, лицо деформируется от гнева<br>
	  - Жертва начинает атаковать все подряд в неистовстве<br>
	  - Разум полностью затуманивается яростью<br>
	  - Усиленная агрессия и насильственность<br>
	  - Жертва теряет возможность контролировать себя<br>
	• Приступ длится около 10 секунд<br>
	• После приступа - полная истощенность<br><br>
	<b>ОПАСНОСТЬ:</b><br>
	Это болезнь чрезвычайно опасна как для самого больного, так и для окружающих. Жертва может серьезно ранить себя или убить других людей во время приступа.<br><br>
	<b>ЛЕЧЕНИЕ:</b><br>
	Вспышка безумия требует седативной терапии:<br><br>
	• При появлении симптомов приступа больного необходимо срочно усыпить<br>
	• Только специальный седатив может остановить прогрессию болезни<br>
	• Держание больного в спящем состоянии под действием седатива позволяет организму бороться с болезнью<br>
	• Требуется постоянное наблюдение и применение седативных препаратов<br>
	• Без седатива болезнь не пройдет - простой отдых неэффективен<br><br>
	<b>РЕЦЕПТ СЕДАТИВА:</b><br>
	<b>Этап 1 - Создание алхимических порошков (требуется СТОЛ)</b><br><br>
	<b>Создание "Усыпляющей пыли" (Soporific Dust):</b><br>
	• 1 Валериана (Valeriana)<br>
	• 1 Артемизия (Artemisia)<br>
	• Смешать на столе → получится 1 Soporific Dust<br>
	• Сложность крафта: низкая (1 уровень)<br><br>
	<b>Создание "Дремотной пыли" (Drowse Dust):</b><br>
	• 1 Атропа (Atropa)<br>
	• 1 Валериана (Valeriana) - вторая<br>
	• Смешать на столе → получится 1 Drowse Dust<br>
	• Сложность крафта: низкая (1 уровень)<br><br>
	<b>Этап 2 - Варка Седатива на котле (требуется КОТЕЛ и ОГОНЬ)</b><br><br>
	<b>Ингредиенты для котла:</b><br>
	• 1 Soporific Dust (усыпляющая пыль)<br>
	• 1 Drowse Dust (дремотная пыль)<br>
	• 90-100 единиц чистой воды (заполнить котел)<br><br>
	<b>Инструкции:</b><br>
	• Заполнить котел водой (минимум 30 ounces = 90 units)<br>
	• Развести огонь под котлом<br>
	• Добавить Soporific Dust в котел<br>
	• Добавить Drowse Dust в котел<br>
	• Ждать, пока смесь сварится (требуется МАСТЕРСКИЙ уровень алхимии)<br>
	• Иммено запах "влажного корня" означает готовность<br>
	• Собрать готовый Седатив (50 units) в бутыль<br><br>
	<b>ПРИМЕНЕНИЕ СЕДАТИВА:</b><br>
	• Больному нужно выпить или поглотить 20 единиц седатива для полного излечения<br>
	• 50 units Седатива = примерно 2.5 полных курса лечения<br>
	• Седатив автоматически усыпляет пациента при приеме<br>
	• После потребления необходимого количества - полное выздоровление и утихание приступов<br><br>
	<b>ВНИМАНИЕ:</b> Оба порошка ОБЯЗАТЕЛЬНЫ! Котел не примет две одинаковые пыли. Это мощное снадобье - убедитесь, что спящий находится в безопасности!
	"}

/datum/book_entry/disease_compendium/derma_tick
	name = "Кожный паразит"

/datum/book_entry/disease_compendium/derma_tick/inner_book_html(mob/user)
	return {"
	<h3><center>Кожный паразит (Derma-Tick)</center></h3><br>
	<b>Описание:</b> Легкое паразитарное заболевание, вызываемое микроскопическими клещами, поселяющимися под кожей.
	Одна из наиболее распространенных и безопасных болезней.<br><br>
	<b>Пути заражения:</b> Контакт с кожей больного, контакт с жидкостями тела<br><br>
	<b>СИМПТОМЫ:</b><br>
	• Мучительный зуд на коже, продолжающийся 10 минут<br>
	• Поражение распределяется случайным образом по телу<br>
	• Постоянное желание почесаться - жертва чешет открытые участки<br>
	• Небольшие отметины от расчесывания<br>
	• При расчесывании болезнь может передаться окружающим<br>
	• Зуд периодически усиливается и спадает<br><br>
	<b>ТЕЧЕНИЕ И ЛЕЧЕНИЕ:</b><br>
	Болезнь проходит самостоятельно или может быть излечена сном. Никаких тяжелых осложнений обычно не возникает.<br><br>
	<b>ПРОФИЛАКТИКА:</b><br>
	• Гигиена рук и тела предотвращает заражение<br>
	• Избегайте близкого контакта с зараженными<br>
	• Стирка одежды помогает предотвратить переинфекцию<br><br>
	<b>ПРИМЕЧАНИЕ:</b> Хотя болезнь безопасна, постоянный зуд может изводить пациента. Рекомендуется изолировать больного, чтобы болезнь не распространялась на других людей.
	"}

/datum/book_entry/disease_compendium/flu
	name = "Простуда"

/datum/book_entry/disease_compendium/flu/inner_book_html(mob/user)
	return {"
	<h3><center>Простуда (Flu)</center></h3><br>
	<b>Описание:</b> Способная к передаче вирусная болезнь, вызывающая общее недомогание и слабость.
	Распространенная, но обычно не смертельная инфекция.<br><br>
	<h3><center>!!ВАЖНО!!</center></h3><br>
	<b>Рекомендуется изолировать пациента. Грязная лихорадка маскируется под простуду. Будьте осторожны!<br><br>
	<b>Пути заражения:</b> Контакт с жидкостями тела инфицированного, контакт с кожей<br><br>
	<b>РАННЯЯ СТАДИЯ (Первая минута):</b><br>
	• Легкое недомогание, чувство слабости<br>
	• Больной может даже не заметить начало болезни<br>
	• Слабые симптомы, которые легко спутать с усталостью<br><br>
	<b>РАЗВИТАЯ СТАДИЯ (После одной минуты):</b><br>
	• Выраженная общая слабость - работоспособность падает<br>
	• Головная боль и нарушения зрения<br>
	• Помутнение и обезвоживание организма<br>
	• На этой стадии болезнь становится заметнее<br>
	• Периодическое размытие зрения и потеря фокуса<br><br>
	<b>ТЕЧЕНИЕ И ЛЕЧЕНИЕ:</b><br>
	Простуда проходит самостоятельно или может быть излечена сном. Болезнь хорошо поддается симптоматическому лечению:<br><br>
	• <b>Отдых и сон</b> - самое важное средство восстановления<br>
	• <b>Гидратация</b> - больной должен много пить для поддержания сил<br>
	• Хорошо увлажненный и отдохнувший организм быстрее борется с инфекцией<br>
	• Дополнительные медикаменты обычно не требуются<br><br>
	<b>ПРИМЕЧАНИЕ:</b> Хотя простуда редко бывает смертельной, в сочетании с другими заболеваниями или при ослабленном иммунитете она может стать опасной.
	Рекомендуется тщательное наблюдение за уязвимыми пациентами.
	"}

/datum/book_entry/disease_compendium/conclusion
	name = "Заключение"

/datum/book_entry/disease_compendium/conclusion/inner_book_html(mob/user)
	return {"
	<h3><center>Заключение</center></h3><br>
	<b>Общие рекомендации для врачей и лекарей:</b><br><br>
	• <b>Защита врача</b> - всегда надевайте маску и защищайте себя при работе с инфицированными<br>
	• <b>Ранняя диагностика</b> - чем раньше вы распознаете болезнь, тем выше шансы на выздоровление<br>
	• <b>Изоляция больных</b> - предотвращайте распространение инфекции среди здорового населения<br>
	• <b>Запас средств</b> - всегда имейте наготове необходимые травы, зелья и хирургические инструменты<br>
	• <b>Постоянное обучение</b> - изучайте каждый раздел этого тома, чтобы мгновенно распознавать болезни<br><br>
	<b>Целебные растения и вещества:</b><br>
	• <b>Зверобой (Hypericum)</b> - главный противовоспалительный ингредиент, используется против чумы и грязной лихорадки<br>
	• <b>Мята (Mentha)</b> - успокаивает дыхательные пути, основной компонент при лихорадке<br>
	• <b>Золото (Gold ore)</b> - имеет очищающие свойства, символизирует чистоту при приготовлении зелий<br>
	• <b>Сердце животного (Heart)</b> - источник жизненной силы для наиболее сложных зелий<br><br>
	<b>Инструменты врача:</b><br>
	• <b>Скальпель (Scalpel)</b> - необходимый инструмент для всех хирургических операций<br>
	• <b>Прижигатель (Cautery)</b> - для остановки кровотечений и дезинсекции ран<br>
	• <b>Святой крест (Holy Cross)</b> - альтернативный источник жара, может заменить прижигатель<br>
	• <b>Целебная пиявка (Leech)</b> - уникальное средство для лечения гниения крови<br><br>
	<i>Помните: знание - ваше главное оружие против болезни и смерти. Невежество ведет пациента в могилу.
	Будьте внимательны, методичны и безжалостны в борьбе с инфекцией.</i><br><br>
	<center>- Конец этого тома о болезнях -</center>
	"}

