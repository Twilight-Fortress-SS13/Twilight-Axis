/// Unit tests for the input-sanitization fixes (XSS-1 .. XSS-5).
/// Covers the pure helpers plus the paper/mail output paths; the UI-only parts
/// (marriage re-prompt, admin chat rendering) are covered by the manual checklist.

/datum/unit_test/sanitize_mail_destination/Run()
	// Valid HERMES box numbers are numeric and canonicalized.
	TEST_ASSERT_EQUAL(sanitize_mail_destination("#1"), "#1", "plain box number")
	TEST_ASSERT_EQUAL(sanitize_mail_destination("#007"), "#7", "leading zeros must be dropped")
	TEST_ASSERT_EQUAL(sanitize_mail_destination("#00001"), "#1", "leading zeros must be dropped")

	// Invalid box numbers.
	TEST_ASSERT_NULL(sanitize_mail_destination("#0"), "box zero must be rejected")
	TEST_ASSERT_NULL(sanitize_mail_destination("#000"), "box zero must be rejected")
	TEST_ASSERT_NULL(sanitize_mail_destination("#1abc"), "trailing text after the number")
	TEST_ASSERT_NULL(sanitize_mail_destination("#123456"), "too many digits")
	TEST_ASSERT_NULL(sanitize_mail_destination("#-1"), "negative number")
	TEST_ASSERT_NULL(sanitize_mail_destination("#1<img src=x onerror=alert(1)>"), "HTML after the number")

	// Empty / missing values.
	TEST_ASSERT_NULL(sanitize_mail_destination(null), "null")
	TEST_ASSERT_NULL(sanitize_mail_destination(""), "empty string")
	TEST_ASSERT_NULL(sanitize_mail_destination("   "), "whitespace only")

	// Names go through reject_bad_name.
	TEST_ASSERT_EQUAL(sanitize_mail_destination("John Smith"), "John Smith", "plain name")
	TEST_ASSERT_EQUAL(sanitize_mail_destination("O'Brien"), "O'Brien", "apostrophe name")
	TEST_ASSERT_EQUAL(sanitize_mail_destination("Jean-Luc"), "Jean-Luc", "hyphenated name")
	TEST_ASSERT_EQUAL(sanitize_mail_destination(" steward of roguetown "), "steward of roguetown", "name is trimmed")
	TEST_ASSERT_EQUAL(sanitize_mail_destination("Clandestine Tube"), "Clandestine Tube", "system address")
	TEST_ASSERT_NULL(sanitize_mail_destination("<img src=x onerror=alert(1)>"), "HTML name")

/datum/unit_test/valid_headshot_link/Run()
	var/list/exts = list("jpg", "jpeg", "png", "gif", "mp4")

	// Allowed hosts and extensions.
	TEST_ASSERT(valid_headshot_link(null, "https://files.catbox.moe/abc.jpg", TRUE, exts), "catbox jpg")
	TEST_ASSERT(valid_headshot_link(null, "https://i.gyazo.com/abc.png", TRUE, exts), "gyazo png")
	TEST_ASSERT(valid_headshot_link(null, "https://images2.imgbox.com/abc.jpeg", TRUE, exts), "imgbox jpeg")
	TEST_ASSERT(valid_headshot_link(null, "https://i.l3n.co/abc.gif", TRUE, exts), "lensdump gif")
	TEST_ASSERT(valid_headshot_link(null, "https://file.garden/abc.mp4", TRUE, exts), "file garden mp4")

	// Attribute breakouts.
	TEST_ASSERT(!valid_headshot_link(null, "https://files.catbox.moe/a.jpg?' onerror='alert(1)'.jpg", TRUE, exts), "single-quote breakout")
	TEST_ASSERT(!valid_headshot_link(null, "https://files.catbox.moe/a.jpg onerror=alert(1) x=.jpg", TRUE, exts), "space breakout")
	TEST_ASSERT(!valid_headshot_link(null, "https://files.catbox.moe/a.jpg\" onerror=\"alert(1)\".jpg", TRUE, exts), "double-quote breakout")

	// Host and scheme checks.
	TEST_ASSERT(!valid_headshot_link(null, "http://i.gyazo.com/a.jpg", TRUE, exts), "http is rejected")
	TEST_ASSERT(!valid_headshot_link(null, "https://evil.example/a.jpg", TRUE, exts), "unknown host is rejected")
	TEST_ASSERT(!valid_headshot_link(null, "https://i.gyazo.com.evil.example/a.jpg", TRUE, exts), "host suffix is rejected")

	// Extension checks.
	TEST_ASSERT(!valid_headshot_link(null, "https://i.gyazo.com/a.svg", TRUE, exts), "disallowed extension")
	TEST_ASSERT(!valid_headshot_link(null, "https://i.gyazo.com/a.jpg?ex=1", TRUE, exts), "query after extension")
	TEST_ASSERT(!valid_headshot_link(null, "https://i.gyazo.com/a", TRUE, exts), "no extension")

/datum/unit_test/mail_destination_build/Run()
	// Invalid destination must not be stored on the letter.
	var/obj/item/paper/bad = build_sanitized_letter(null, "#1<img src=x onerror=alert(1)>", "hello", "Anonymous")
	TEST_ASSERT_NOTNULL(bad, "letter item was not created")
	TEST_ASSERT_NULL(bad.mailedto, "invalid destination must be rejected")
	qdel(bad)

	// Valid destination is canonicalized.
	var/obj/item/paper/good = build_sanitized_letter(null, "#007", "hello", "Anonymous")
	TEST_ASSERT_NOTNULL(good, "letter item was not created")
	TEST_ASSERT_EQUAL(good.mailedto, "#7", "box number must be canonicalized")
	qdel(good)

/datum/unit_test/mail_examine_escaped/Run()
	var/mob/living/carbon/human/reader = allocate(/mob/living/carbon/human/species/human/northern, run_loc_floor_bottom_left)
	var/obj/item/paper/P = allocate(/obj/item/paper, run_loc_floor_bottom_left)

	P.mailer = "Anonymous"
	P.mailedto = "#1<img src=x onerror=alert(1)>"

	var/rendered = jointext(P.examine(reader), "")
	TEST_ASSERT(findtext(rendered, "&lt;img"), "mailedto must be HTML-encoded in examine")
	TEST_ASSERT(!findtext(rendered, "<img src=x onerror=alert(1)>"), "raw HTML must not survive in examine")

/datum/unit_test/change_name_validation/Run()
	var/mob/living/carbon/human/H = allocate(/mob/living/carbon/human/species/human/northern, run_loc_floor_bottom_left)
	H.real_name = "John Smith"

	TEST_ASSERT(!H.change_name("<img src=x onerror=alert(1)>"), "HTML name must be rejected")
	TEST_ASSERT_EQUAL(H.real_name, "John Smith", "name must stay unchanged after rejection")

	TEST_ASSERT(!H.change_name(""), "empty name must be rejected")
	TEST_ASSERT(!H.change_name("A"), "one-character name must be rejected")

	TEST_ASSERT(H.change_name("Jane Doe"), "valid name must be accepted")
	TEST_ASSERT_EQUAL(H.real_name, "Jane Doe", "valid name must be applied")

	TEST_ASSERT(H.change_name("O'Brien"), "apostrophe name must be accepted")
	TEST_ASSERT_EQUAL(H.real_name, "O'Brien", "apostrophe name must be applied")

/datum/unit_test/agent_notes_escaping/Run()
	// Court Agent notes go through parsemarkdown(html_encode(raw)); lock that chain.
	var/rendered = parsemarkdown(html_encode("<img src=x onerror=alert(1)>"), null)
	TEST_ASSERT(findtext(rendered, "&lt;img"), "notes must be HTML-encoded before markdown parsing")
	TEST_ASSERT(!findtext(rendered, "<img src=x onerror=alert(1)>"), "raw tag must not survive markdown parsing")

/datum/unit_test/fix_dirty_name/Run()
	var/mob/living/carbon/human/H = allocate(/mob/living/carbon/human/species/human/northern, run_loc_floor_bottom_left)

	H.real_name = "<img src=x onerror=alert(1)>"
	H.fix_dirty_name()
	TEST_ASSERT_EQUAL(H.real_name, "Unknown", "tag-only name must fall back to Unknown")
	TEST_ASSERT_EQUAL(H.name, "Unknown", "display name must be normalized too")

	H.real_name = "Bob<img src=x>"
	H.fix_dirty_name()
	TEST_ASSERT_EQUAL(H.real_name, "Bob", "text around a tag must be preserved")

	H.real_name = "Alice Smith"
	H.fix_dirty_name()
	TEST_ASSERT_EQUAL(H.real_name, "Alice Smith", "clean names must not change")

	H.real_name = "A&B"
	H.fix_dirty_name()
	TEST_ASSERT_EQUAL(H.real_name, "A&B", "ampersand-only names must not change")
