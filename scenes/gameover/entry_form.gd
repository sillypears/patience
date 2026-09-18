extends Control

# EntryForm — name/email capture that POSTs to a Discord webhook.
# Drop this as a child of the GameOver screen. It reads stats from GameManager
# and sends them alongside the entered name/email.
#
# Swap DISCORD_WEBHOOK_URL with your real webhook (Server Settings → Integrations
# → Webhooks → New Webhook → Copy Webhook URL). While the URL still contains
# the placeholder token the form will simulate a successful submit after a short
# delay so you can test the flow without a live Discord channel.
# Set `simulate_placeholder = false` to force a real HTTP request even against
# the placeholder.

@onready var GM = $"/root/GameManager"

# --- Build-time secret ---
# Primary source: ProjectSettings "discord/webhook_url" (set in project.godot [discord] or injected at build via GitHub Secret).
# Fallback is placeholder below — keeps local runs / PRs working without the secret.
const FALLBACK_WEBHOOK_URL: String = "https://discord.com/api/webhooks/0000000000000000000/PLACEHOLDER_TOKEN_DO_NOT_USE"
const PLACEHOLDER_TOKEN: String = "PLACEHOLDER_TOKEN_DO_NOT_USE"
# Keep alias so older docs still make sense
const SUBMIT_URL: String = FALLBACK_WEBHOOK_URL
const PLACEHOLDER_HOST: String = PLACEHOLDER_TOKEN

func _get_webhook_url() -> String:
	# Priority: 1) OS env 2) local .env/.env.local file 3) ProjectSettings [discord] 4) fallback
	var env = OS.get_environment("DISCORD_WEBHOOK_URL")
	if env != null and String(env).strip_edges() != "":
		return String(env).strip_edges()
	# also allow `discord/webhook_url` env name
	env = OS.get_environment("discord/webhook_url")
	if env != null and String(env).strip_edges() != "":
		return String(env).strip_edges()

	# Local .env file (gitignored) — `DISCORD_WEBHOOK_URL=...` or `discord/webhook_url=...`
	for path in ["res://.env", "res://.env.local"]:
		if FileAccess.file_exists(path):
			var f := FileAccess.open(path, FileAccess.READ)
			if f:
				while not f.eof_reached():
					var line := f.get_line().strip_edges()
					if line.is_empty() or line.begins_with("#"):
						continue
					# allow `KEY=VALUE` and `KEY = "VALUE"`
					var eq := line.find("=")
					if eq == -1:
						continue
					var k := line.substr(0, eq).strip_edges()
					var v := line.substr(eq + 1).strip_edges()
					if v.begins_with("\"") and v.ends_with("\"") and v.length() >= 2:
						v = v.substr(1, v.length() - 2)
					if k == "DISCORD_WEBHOOK_URL" or k == "discord/webhook_url":
						if v != "":
							return v

	var s = ProjectSettings.get_setting("discord/webhook_url", "")
	if typeof(s) == TYPE_STRING and String(s).strip_edges() != "":
		return String(s).strip_edges()
	return FALLBACK_WEBHOOK_URL

# If true and the URL still contains the placeholder host, don't actually hit
# the network — fake a 200 after `fake_delay`.
@export var simulate_placeholder: bool = true
@export var fake_delay: float = 0.8

# UI
@onready var name_input: LineEdit = $VBox/NameInput
@onready var email_input: LineEdit = $VBox/EmailInput
@onready var submit_button: Button = $VBox/SubmitButton
@onready var status_label: Label = $VBox/StatusLabel
@onready var http: HTTPRequest = $HTTPRequest
@onready var fake_timer: Timer = $FakeTimer

signal submitted(payload: Dictionary)
signal submit_failed(reason: String)

var _is_submitting: bool = false
var _is_submitted: bool = false

# Simple email regex — good enough for client-side validation.
var _email_regex: RegEx


func _ready() -> void:
	_email_regex = RegEx.new()
	_email_regex.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")

	# Connect signals (also wired in tscn for editor visibility, but ensure here too)
	if not http.request_completed.is_connected(_on_request_completed):
		http.request_completed.connect(_on_request_completed)
	if not fake_timer.timeout.is_connected(_on_fake_timer_timeout):
		fake_timer.timeout.connect(_on_fake_timer_timeout)
	if not name_input.text_changed.is_connected(_on_text_changed):
		name_input.text_changed.connect(_on_text_changed)
	if not email_input.text_changed.is_connected(_on_text_changed):
		email_input.text_changed.connect(_on_text_changed)
	if not submit_button.pressed.is_connected(_on_submit_pressed):
		submit_button.pressed.connect(_on_submit_pressed)

	# Allow Enter to submit from either field
	name_input.text_submitted.connect(func(_t): _on_submit_pressed())
	email_input.text_submitted.connect(func(_t): _on_submit_pressed())

	_update_submit_enabled()
	_set_status("", Color.WHITE)


func _on_text_changed(_new_text: String) -> void:
	if _is_submitted:
		return
	_update_submit_enabled()
	# Clear error once user starts correcting
	if status_label.text != "" and not _is_submitting:
		var n_ok := _is_valid_name(name_input.text)
		var e_ok := _is_valid_email(email_input.text)
		if n_ok and e_ok:
			_set_status("", Color.WHITE)


func _update_submit_enabled() -> void:
	var valid := _is_valid_name(name_input.text) and _is_valid_email(email_input.text)
	submit_button.disabled = _is_submitting or _is_submitted or not valid


func _is_valid_name(n: String) -> bool:
	var t := n.strip_edges()
	return t.length() >= 2 and t.length() <= 50


func _is_valid_email(e: String) -> bool:
	var t := e.strip_edges()
	if t.is_empty():
		return false
	return _email_regex.search(t) != null


func _set_status(msg: String, color: Color) -> void:
	# Keep hidden StatusLabel for accessibility / screen readers, but do not stack layout.
	# Visual feedback is via SubmitButton font color (green/red) per user request.
	status_label.text = msg
	status_label.visible = false
	status_label.modulate = color
	if msg.is_empty():
		submit_button.remove_theme_color_override("font_color")
		submit_button.modulate = Color.WHITE
	else:
		submit_button.add_theme_color_override("font_color", color)


func _on_submit_pressed() -> void:
	if _is_submitting or _is_submitted:
		return

	var name := name_input.text.strip_edges()
	var email := email_input.text.strip_edges()

	if not _is_valid_name(name):
		_set_status("Please enter a name (2-50 characters).", Color(1, 0.45, 0.45))
		name_input.grab_focus()
		return
	if not _is_valid_email(email):
		_set_status("Please enter a valid email address.", Color(1, 0.45, 0.45))
		email_input.grab_focus()
		return

	_is_submitting = true
	_update_submit_enabled()
	_set_status("Submitting...", Color(0.85, 0.85, 0.85))
	submit_button.text = "Submitting..."

	var payload = GM.build_discord_payload(name, email)
	var json_body := JSON.stringify(payload)
	var webhook_url := _get_webhook_url()

	# If we are still on the placeholder URL and simulation is enabled, fake it.
	# Discord webhooks return 204 No Content on success, empty body — simulation mimics that.
	if simulate_placeholder and webhook_url.contains(PLACEHOLDER_TOKEN):
		print_debug("[EntryForm] Placeholder webhook detected — simulating successful Discord POST: ", json_body)
		fake_timer.wait_time = fake_delay
		fake_timer.start()
		return

	var headers: PackedStringArray = ["Content-Type: application/json"]
	# Discord expects POST to the webhook URL as-is. Add ?wait=true if you want the JSON response.
	var err := http.request(webhook_url, headers, HTTPClient.METHOD_POST, json_body)
	if err != OK:
		_is_submitting = false
		submit_button.text = "Submit Entry"
		_update_submit_enabled()
		_set_status("Could not start request (%s)." % error_string(err), Color(1, 0.45, 0.45))
		submit_failed.emit("request_error: %s" % error_string(err))


func _on_fake_timer_timeout() -> void:
	# Simulate a 204 Discord response (no body)
	_handle_success({"simulated": true, "url": _get_webhook_url(), "discord_status": 204})


func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	_is_submitting = false
	submit_button.text = "Submit Entry"

	if result != HTTPRequest.RESULT_SUCCESS:
		var reason := "Network error (result=%d)." % result
		_set_status(reason + " Try again.", Color(1, 0.45, 0.45))
		_update_submit_enabled()
		submit_failed.emit(reason)
		return

	if response_code < 200 or response_code >= 300:
		var body_text := body.get_string_from_utf8()
		# Truncate long bodies for display
		if body_text.length() > 200:
			body_text = body_text.substr(0, 200) + "..."
		var reason2 := "Server returned %d." % response_code
		if not body_text.is_empty():
			reason2 += " " + body_text
		_set_status(reason2, Color(1, 0.45, 0.45))
		_update_submit_enabled()
		submit_failed.emit(reason2)
		return

	var parsed = null
	if body.size() > 0:
		var jp := JSON.new()
		if jp.parse(body.get_string_from_utf8()) == OK:
			parsed = jp.data

	_handle_success(parsed)


func _handle_success(response_data) -> void:
	_is_submitting = false
	_is_submitted = true
	submit_button.disabled = true
	submit_button.text = "Submitted!"
	name_input.editable = false
	email_input.editable = false
	_set_status("Entry submitted — thank you!", Color(0.45, 1.0, 0.55))
	submitted.emit(GM.build_payload(name_input.text.strip_edges(), email_input.text.strip_edges()))
	print_debug("[EntryForm] Submitted successfully. Response: ", response_data)
