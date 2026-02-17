// WHISPER OF FEVER - Disease compendium book for physicians and plaguebearers

/obj/item/book/rogue/disease_compendium
	parent_type = /obj/item/recipe_book
	name = "Шепот лихорадки"
	desc = "Потрепанный фолиант в темно-фиолетовой обложке. На страницах подробно описаны симптомы, стадии и методы лечения различных болезней, поражающих жителей Псидонии. Пахнет горькими травами и старым пергаментом."
	icon = 'modular_twilight_axis/icons/objects/disease_compendium.dmi'
	icon_state = "book3_0"
	base_icon_state = "book3"
	current_category = "Всё"
	var/bg_rsc = 'modular_twilight_axis/html/disease_compendium_bg.png'
	var/bg_name = "disease_compendium_bg.png"

	types = list(
		/datum/book_entry/disease_compendium/preface,
		/datum/book_entry/disease_compendium/nature,
		/datum/book_entry/disease_compendium/plague,
		/datum/book_entry/disease_compendium/vision_rot,
		/datum/book_entry/disease_compendium/ash_blight,
		/datum/book_entry/disease_compendium/blood_rot,
		/datum/book_entry/disease_compendium/grime_flu,
		/datum/book_entry/disease_compendium/conclusion,
	)

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
				color: #f0e6ef;
				background-color: rgb(31, 20, 24);
				background-image: url('[bg_name]');
				background-repeat: no-repeat;
				background-attachment: fixed;
				background-size: 100% 100%;
			}
			h1, h2, h3 {
				font-family: 'Cinzel', serif;
				color: #d8b5e6;
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
				color: #f0e6ef;
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
				color: #f0e6ef;
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
	<h3><center>I. О Природе Болезней</center></h3><br>
	Болезни приходят многими путями. Некоторые передаются через прикосновение, другие - через воздух, что мы вдыхаем.
	Третьи скрываются в крови и жидкостях тела.<br><br>
	<b>Пути распространения:</b><br>
	• <b>Контактная передача</b> - через прикосновение к больному или его вещам<br>
	• <b>Воздушная передача</b> - через кашель и дыхание<br>
	• <b>Кровяная передача</b> - через раны и порезы<br>
	• <b>Жидкостная передача</b> - через слюну, пот и другие выделения<br><br>
	<b>Защита от заразы:</b><br>
	Маска врача (Physician's Mask) и шлем пестрана (Pestran Helmet) обеспечивают надежную защиту от контактной передачи болезней.
	Они не пропускают миазмы и защищают от прикосновения зараженных.<br><br>
	<b>Стадии болезней:</b><br>
	Большинство болезней развиваются постепенно, проходя через несколько стадий.
	Ранняя диагностика и лечение могут спасти жизнь больному.
	"}

/datum/book_entry/disease_compendium/plague
	name = "Чума"

/datum/book_entry/disease_compendium/plague/inner_book_html(mob/user)
	return {"
	<h3><center>II. Чума (The Plague)</center></h3><br>
	<b>Описание:</b> Самая смертоносная из известных пандемий, сочетающая в себе симптомы пепельной язвы и грязной лихорадки.
	Болезнь проходит через четыре стадии, каждая из которых ужаснее предыдущей.<br><br>
	<b>Пути заражения:</b> Контакт с кожей, жидкости тела, кровь<br><br>
	<b>СТАДИЯ I - Инкубация (3-4 минуты):</b><br>
	• Кожа покрывается бледными пятнами<br>
	• Легкое недомогание<br>
	• -1 к Восприятию (Perception)<br>
	• -1 к Скорости (Speed)<br>
	• Периодический кашель<br><br>
	<b>СТАДИЯ II - Ранняя чума (5-6 минут):</b><br>
	• Появление болезненных бубонов и сочащихся язв<br>
	• Больной получает черты КРИТИЧЕСКАЯ СЛАБОСТЬ (Critical Weakness) и ПРОКАЗА (Leprosy)<br>
	• -2 к Восприятию, -2 к Скорости, -1 к Силе воли<br>
	• Усиленный кашель, периодическая рвота<br>
	• Больной может заражать окружающих кашлем<br><br>
	<b>СТАДИЯ III - Развитая чума (8-10 минут):</b><br>
	• Кожа начинает чернеть и отмирать<br>
	• Гниющие раны и зловонные нарывы<br>
	• -3 ко всем характеристикам<br>
	• Сильное кровотечение из ран<br>
	• Постоянная рвота и кашель кровью<br>
	• Высокая вероятность царапания ран<br><br>
	<b>СТАДИЯ IV - Терминальная стадия (15-20 минут от стадии III):</b><br>
	• ЛЕТАЛЬНО! Тело почернело от некроза<br>
	• Запах смерти окружает больного<br>
	• Септический шок каждые 30 секунд<br>
	• Массивное кровотечение и рвота<br>
	• -4 ко всем характеристикам<br>
	• Органная недостаточность<br>
	• Смерть неизбежна без немедленного лечения<br><br>
	<b>ЛЕЧЕНИЕ:</b><br>
	Чума требует сложного двухэтапного лечения:<br><br>
	1. <b>Приготовление зелья лечения чумы (Plague Cure):</b><br>
	   Ингредиенты:<br>
	   • 5 золотой руды (Gold Ore)<br>
	   • 1 зверобой (Hypericum)<br>
	   • 1 сердце (Heart)<br>
	   • 50 единиц воды (Water)<br>
	   • 1 роговая бутыль (Rogue Bottle)<br>
	   Требуется мастерский уровень алхимии (Master Alchemy).<br><br>
	2. <b>Операция прижигания:</b><br>
	   • Больной должен выпить зелье лечения чумы<br>
	   • Провести операцию: разрез (Incise) → прижигание чумы (Cauterize Plague) → прижигание (Cauterize)<br>
	   • Операция вызывает сильные ожоги и агонию<br>
	   • После успешного лечения - 30 минут иммунитета к чуме<br><br>
	<b>ПРЕДУПРЕЖДЕНИЕ:</b> Без лечения на 4-й стадии смерть наступает в течение нескольких минут!
	"}

/datum/book_entry/disease_compendium/vision_rot
	name = "Гниение зрения"

/datum/book_entry/disease_compendium/vision_rot/inner_book_html(mob/user)
	return {"
	<h3><center>III. Гниение зрения (Vision Rot)</center></h3><br>
	<b>Описание:</b> Дегенеративная болезнь, медленно разрушающая зрение пациента.
	Жертвы страдают от периодического размытия зрения, потери цветов и полной слепоты.<br><br>
	<b>Пути заражения:</b> Контакт с жидкостями тела, кожей больного<br><br>
	<b>СИМПТОМЫ:</b><br>
	• Периодическое размытие зрения каждые 12-22 секунды (длится 15-25 секунд)<br>
	• Потеря цветового зрения каждые 18-32 секунды (мир становится серым на 6-10 секунд)<br>
	• Приступы полной слепоты каждые 20-30 секунд (длится 8-12 секунд)<br>
	• Болезнь не влияет на характеристики<br><br>
	<b>ЕСТЕСТВЕННОЕ ИЗЛЕЧЕНИЕ:</b><br>
	Болезнь проходит сама через 8 минут. Зрение постепенно восстанавливается.
	Иммунитета после излечения не возникает.<br><br>
	<b>ХИРУРГИЧЕСКОЕ ЛЕЧЕНИЕ:</b><br>
	Для ускоренного излечения можно провести операцию экстирпации:<br>
	• Скальпель (Scalpel) для извлечения остатков гниения из глаз<br>
	• Операция проводится на глазах (Left/Right Eye)<br>
	• Может вызвать повреждение глаз (0-50 единиц в зависимости от навыка хирургии)<br>
	• Вызывает сильную боль<br>
	• Мгновенно излечивает болезнь без иммунитета
	"}

/datum/book_entry/disease_compendium/ash_blight
	name = "Пепельная язва"

/datum/book_entry/disease_compendium/ash_blight/inner_book_html(mob/user)
	return {"
	<h3><center>IV. Пепельная язва (Ash Blight)</center></h3><br>
	<b>Описание:</b> Умеренно опасная контактная болезнь, вызывающая зудящую сыпь с пепельным налетом.
	Ослабляет внимание и скорость жертвы.<br><br>
	<b>Пути заражения:</b> Контакт с жидкостями тела, кожей больного<br><br>
	<b>СИМПТОМЫ:</b><br>
	• Кожа покрывается пепельными пятнами и сочащимися язвами<br>
	• Образование отвратительной корки<br>
	• -4 к Восприятию (Perception)<br>
	• -2 к Скорости (Speed)<br>
	• Нестерпимый зуд - больной постоянно чешется<br>
	• При расчесывании:<br>
	  - Получение 2 урона<br>
	  - Язвы разрываются, выделяя жидкость<br>
	  - 20% шанс открыть кровоточащую рану<br>
	• Болезнь может распространяться на окружающих в радиусе 1 клетки (50% шанс)<br><br>
	<b>ЛЕЧЕНИЕ:</b><br>
	Хирургическая операция:<br>
	• Разрез (Incise) → прижигание язвы (Cauterize Ash Blight) → прижигание (Cauterize)<br>
	• Использовать прижигающий инструмент (Cautery, Holy Cross, Welder или горячий предмет)<br>
	• Вызывает ожоги и сильную боль<br>
	• После успешного лечения - 10 минут иммунитета к пепельной язве
	"}

/datum/book_entry/disease_compendium/blood_rot
	name = "Гниение крови"

/datum/book_entry/disease_compendium/blood_rot/inner_book_html(mob/user)
	return {"
	<h3><center>V. Гниение крови (Blood Rot)</center></h3><br>
	<b>Описание:</b> Ужасная болезнь крови, прогрессивно разрушающая организм.
	Проходит через три стадии в зависимости от потери крови.<br><br>
	<b>Пути заражения:</b> Контакт с жидкостями тела, кровь<br><br>
	<b>СТАДИЯ I - Начальное заражение (потеря менее 100 единиц крови):</b><br>
	• Кожа бледнеет и покрывается темными пятнами<br>
	• -1 к Силе (Strength)<br>
	• -1 к Выносливости (Constitution)<br>
	• -1 к Скорости (Speed)<br>
	• Периодическая рвота<br>
	• Редкий кашель<br><br>
	<b>СТАДИЯ II - Прогрессирование (потеря 100-300 единиц крови):</b><br>
	• Темные вены становятся видны под кожей<br>
	• -2 к Силе, -2 к Выносливости, -2 к Скорости<br>
	• -1 к Восприятию<br>
	• Частая рвота и кашель<br>
	• Периодическое кровотечение из носа и рта<br><br>
	<b>СТАДИЯ III - Критическая (потеря более 300 единиц крови):</b><br>
	• ОПАСНО ДЛЯ ЖИЗНИ!<br>
	• Кожа чернеет, тело источает запах гнили<br>
	• -3 ко всем физическим характеристикам<br>
	• -2 к Восприятию и Силе воли<br>
	• Постоянная рвота кровью<br>
	• Сильное кровотечение каждые 40 секунд<br>
	• Внутреннее кровотечение, потеря 5 единиц крови каждые 10 секунд<br><br>
	<b>ОСОБОЕ ЛЕЧЕНИЕ:</b><br>
	Гниение крови требует уникального метода лечения:<br><br>
	1. Больной должен потерять почти всю кровь (остаться не более 50 единиц)<br>
	2. К больному должна быть прикреплена пиявка (Leech)<br>
	3. Когда эти два условия выполнены, пиявка высосет испорченную кровь<br>
	4. Болезнь излечивается мгновенно<br>
	5. После излечения - 10 минут иммунитета<br><br>
	<b>ПРИМЕЧАНИЕ:</b> Этот метод крайне опасен и требует постоянного наблюдения врача.
	Слишком большая кровопотеря может убить пациента до того, как пиявка успеет помочь.
	Рекомендуется иметь наготове переливание крови или зелья восстановления крови.<br><br>
	<b>ПРЕДУПРЕЖДЕНИЕ:</b> Не пытайтесь лечить обычными методами!
	Только пиявка может высосать испорченную кровь.
	"}

/datum/book_entry/disease_compendium/grime_flu
	name = "Грязная лихорадка"

/datum/book_entry/disease_compendium/grime_flu/inner_book_html(mob/user)
	return {"
	<h3><center>VI. Грязная лихорадка (The Grime-Flu)</center></h3><br>
	<b>Описание:</b> Распространенная болезнь, ослабляющая организм.
	Проходит через четыре стадии развития.<br><br>
	<b>Пути заражения:</b> Контакт с жидкостями тела, кожей больного<br><br>
	<b>СТАДИЯ I - Инкубация (2 минуты):</b><br>
	• Легкое недомогание<br>
	• -1 к Силе (Strength)<br>
	• -1 к Восприятию (Perception)<br><br>
	<b>СТАДИЯ II - Развитие (4 минуты от стадии I):</b><br>
	• -2 к Силе, -2 к Восприятию<br>
	• -1 к Скорости и Выносливости<br>
	• Периодический кашель (заражает окружающих в радиусе 3 клетки)<br>
	• Головная боль и размытие зрения<br>
	• Обезвоживание<br><br>
	<b>СТАДИЯ III - Прогрессирование (6 минут от стадии II):</b><br>
	• -3 ко всем характеристикам<br>
	• Сильная слабость (10-15 урона периодически)<br>
	• Падения от слабости в ногах<br>
	• Периодическая потеря цветового зрения (20 секунд)<br>
	• Усиленный кашель<br><br>
	<b>СТАДИЯ IV - Тяжелая форма:</b><br>
	• -3 ко всем характеристикам<br>
	• Кашель кровью (70% шанс при кашле)<br>
	• Кровотечение при кашле<br>
	• Кислородное голодание<br>
	• Постоянная слабость<br><br>
	<b>ЛЕЧЕНИЕ:</b><br>
	Алхимическое зелье лечения грязной лихорадки (Grime-Flu Cure):<br><br>
	Ингредиенты:<br>
	• 1 мята (Mentha)<br>
	• 1 зверобой (Hypericum)<br>
	• 30 единиц воды (Water)<br>
	• 1 роговая бутыль (Rogue Bottle)<br><br>
	Требуется средний уровень алхимии (Apprentice Alchemy).<br><br>
	<b>Применение:</b><br>
	• Выпить зелье<br>
	• Болезнь излечивается мгновенно<br>
	• После излечения - 10 минут иммунитета к грязной лихорадке<br><br>
	<b>ПРИМЕЧАНИЕ:</b> Это одна из немногих болезней, которую можно вылечить простым зельем без хирургического вмешательства.
	Рекомендуется всегда иметь запас этого зелья в клинике.
	"}

/datum/book_entry/disease_compendium/conclusion
	name = "Заключение"

/datum/book_entry/disease_compendium/conclusion/inner_book_html(mob/user)
	return {"
	<h3><center>VII. Заключение</center></h3><br>
	<b>Общие рекомендации для врачей:</b><br><br>
	• <b>Профилактика лучше лечения</b> - всегда носите маску врача при контакте с больными<br>
	• <b>Ранняя диагностика</b> - чем раньше обнаружена болезнь, тем проще ее вылечить<br>
	• <b>Изоляция больных</b> - не допускайте распространения заразы<br>
	• <b>Запас лекарств</b> - всегда имейте наготове зелья и инструменты<br>
	• <b>Знание симптомов</b> - изучайте этот том, чтобы мгновенно распознавать болезни<br><br>
	<b>Ингредиенты для алхимии:</b><br>
	• <b>Зверобой (Hypericum)</b> - используется в лечении чумы и грязной лихорадки<br>
	• <b>Мята (Mentha)</b> - компонент зелья от грязной лихорадки<br>
	• <b>Золото (Gold)</b> - очищает от скверны чумы<br>
	• <b>Сердце (Heart)</b> - источник жизненной силы для зелья от чумы<br><br>
	<b>Хирургические инструменты:</b><br>
	• <b>Скальпель (Scalpel)</b> - для разрезов<br>
	• <b>Прижигатель (Cautery)</b> - для прижигания ран<br>
	• <b>Святой крест (Holy Cross)</b> - может заменить прижигатель<br>
	• <b>Пиявка (Leech)</b> - для лечения гниения крови<br><br>
	<i>Помните: знание - ваше оружие против смерти. Невежество - путь к могиле.</i><br><br>
	<center>- Конец тома -</center>
	"}

