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

	var border_width = 2
	var border_radius = 8
	var margins = 4

	define_style("Panel", {
		panel = stylebox_flat({
			bg_color = background_color,
			border_color = Color.WHITE,
			expand_margin_bottom = margins,
			expand_margin_left = margins,
			expand_margin_right = margins,
			expand_margin_top = margins,
			border_width_bottom = border_width,
			border_width_left = border_width,
			border_width_right = border_width,
			border_width_top = border_width,
			corner_radius_bottom_left = border_radius,
			corner_radius_bottom_right = border_radius,
			corner_radius_top_left = border_radius,
			corner_radius_top_right = border_radius
		})
	})

	define_style("Label", {
		font_color = text_font_color
	})

	var button_border_stylebox = stylebox_flat({
		border_width_bottom = border_width / 2,
		border_width_left = border_width / 2,
		border_width_right = border_width / 2,
		border_width_top = border_width / 2,
		corner_radius_bottom_left = border_radius,
		corner_radius_bottom_right = border_radius,
		corner_radius_top_left = border_radius,
		corner_radius_top_right = border_radius
	})

	define_style("Button", {
		font_color = text_font_color,
		disabled = inherit(button_border_stylebox, {
			bg_color = Color(0.11, 0.09, 0.22, 0.2),
			border_color = Color(0.11, 0.09, 0.22, 0.2)
		}),
		focus = inherit(button_border_stylebox, {
			bg_color = Color(0, 0, 0, 0.0),
			border_color = Color.AQUA
		}),
		hover = inherit(button_border_stylebox, {
			bg_color = Color(0.11, 0.09, 0.22, 1.0),
			border_color = Color.AQUA
		}),
		normal = inherit(button_border_stylebox, {
			bg_color = Color(0.11, 0.09, 0.22, 1.0),
			border_color = Color.WHITE
		}),
		pressed = inherit(button_border_stylebox, {
			bg_color = Color.DARK_MAGENTA,
			border_color = Color.AQUA
		})
	})

	var edit_border_stylebox = stylebox_flat({
		border_width_bottom = border_width / 2,
		border_width_left = border_width / 2,
		border_width_right = border_width / 2,
		border_width_top = border_width / 2
	})

	define_style("LineEdit", {
		font_color = text_font_color,
		focus = inherit(edit_border_stylebox, {
			bg_color = Color(0, 0, 0, 0.0),
			border_color = Color.AQUA
		}),
		normal = inherit(edit_border_stylebox, {
			bg_color = Color(0.16, 0.14, 0.32, 1.0),
			border_color = Color(0.16, 0.14, 0.32, 1.0)
		}),
		read_only = inherit(edit_border_stylebox, {
			bg_color = Color(0.11, 0.09, 0.22, 0.2),
			border_color = Color(0.11, 0.09, 0.22, 0.2)
		})
	})

	define_style("TextEdit", {
		font_color = text_font_color,
		focus = inherit(edit_border_stylebox, {
			bg_color = Color(0, 0, 0, 0.0),
			border_color = Color.AQUA
		}),
		normal = inherit(edit_border_stylebox, {
			bg_color = Color(0.16, 0.14, 0.32, 1.0),
			border_color = Color(0.16, 0.14, 0.32, 1.0)
		}),
		read_only = inherit(edit_border_stylebox, {
			bg_color = Color(0.11, 0.09, 0.22, 0.2),
			border_color = Color(0.11, 0.09, 0.22, 0.2)
		})
	})
	
	define_style("Slider", {
		grabber_area = stylebox_flat({
			bg_color = Color(0.11, 0.09, 0.22, 1.0)
		}),
		grabber_area_highlight = stylebox_flat({
			bg_color = Color(0.11, 0.09, 0.22, 1.0)
		}),
		slider = stylebox_flat({
			bg_color = Color(0, 0, 0, 0),
			content_margin_top = 4,
			content_margin_bottom = 4
		})
	})

	define_style("HSlider", {
		grabber_area = stylebox_flat({
			bg_color = Color(0.11, 0.09, 0.22, 1.0)
		}),
		grabber_area_highlight = stylebox_flat({
			bg_color = Color(0.11, 0.09, 0.22, 1.0)
		}),
		slider = stylebox_flat({
			bg_color = Color(0, 0, 0, 0),
			content_margin_top = 4,
			content_margin_bottom = 4
		})
	})
