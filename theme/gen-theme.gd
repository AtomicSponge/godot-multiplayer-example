@tool
extends ProgrammaticTheme
const UPDATE_ON_SAVE = true

var default_font = "res://theme/font/Poco.ttf"
var default_font_size = 24

var text_font_color = Color.WHITE
var background_color = Color.DARK_SLATE_BLUE

func setup():
	set_save_path("res://theme//theme.tres")

func define_theme():
	define_default_font(ResourceLoader.load(default_font))
	define_default_font_size(default_font_size)

	define_style("Panel", {
		panel = stylebox_flat({
			bg_color = background_color,
			border_color = Color.WHITE,
			border_width_bottom = 2,
			border_width_left = 2,
			border_width_right = 2,
			border_width_top = 2,
			corner_radius_bottom_left = 8,
			corner_radius_bottom_right = 8,
			corner_radius_top_left = 8,
			corner_radius_top_right = 8
		})
	})

	define_style("Label", {
		font_color = text_font_color
	})

	var button_border_stylebox = stylebox_flat({
		border_width_bottom = 1,
		border_width_left = 1,
		border_width_right = 1,
		border_width_top = 1,
		corner_radius_bottom_left = 8,
		corner_radius_bottom_right = 8,
		corner_radius_top_left = 8,
		corner_radius_top_right = 8
	})

	define_style("Button", {
		font_color = text_font_color,
		normal = inherit(button_border_stylebox, {
			bg_color = Color(0, 0, 0, 0.6),
			border_color = Color.WHITE
		}),
		hover = inherit(button_border_stylebox, {
			bg_color = Color(0, 0, 0, 0.6),
			border_color = Color.AQUA
		}),
		focus = inherit(button_border_stylebox, {
			bg_color = Color(0, 0, 0, 0.6),
			border_color = Color.WHITE
		}),
		pressed = inherit(button_border_stylebox, {
			bg_color = Color(255, 0, 0, 0.6),
			border_color = Color.AQUA
		}),
		disabled = inherit(button_border_stylebox, {
			bg_color = Color(0, 0, 0, 0.2),
			border_color = Color(0, 0, 0, 0.2)
		})
	})
