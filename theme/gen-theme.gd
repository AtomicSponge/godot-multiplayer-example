@tool
extends ProgrammaticTheme
const UPDATE_ON_SAVE = true

var default_font = "res://theme/font/Poco.ttf"
var default_font_size = 24

var text_font_color = Color.WHITE
var background_color = Color.DARK_SLATE_BLUE

const COLOR_DARK_PURPLE = Color(0.11, 0.09, 0.22, 1.0)
const COLOR_PURPLE = Color(0.16, 0.14, 0.32, 1.0)
const COLOR_DISABLED = Color(0.11, 0.09, 0.22, 0.2)
const COLOR_CLEAR = Color(0.0, 0.0, 0.0, 0.0)

func setup():
	set_save_path("res://theme//theme.tres")

func define_theme():
	define_default_font(ResourceLoader.load(default_font))
	define_default_font_size(default_font_size)

	var border_width = 2
	var border_radius = 8

	define_style("Panel", {
		panel = stylebox_flat({
			bg_color = background_color,
			border_color = Color.WHITE,
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

	var curved_border_stylebox = stylebox_flat({
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
		disabled = inherit(curved_border_stylebox, {
			bg_color = COLOR_DISABLED,
			border_color = COLOR_DISABLED
		}),
		focus = inherit(curved_border_stylebox, {
			bg_color = COLOR_CLEAR,
			border_color = Color.AQUA
		}),
		hover = inherit(curved_border_stylebox, {
			bg_color = COLOR_DARK_PURPLE,
			border_color = Color.AQUA
		}),
		normal = inherit(curved_border_stylebox, {
			bg_color = COLOR_DARK_PURPLE,
			border_color = Color.WHITE
		}),
		pressed = inherit(curved_border_stylebox, {
			bg_color = Color.DARK_MAGENTA,
			border_color = Color.AQUA
		})
	})
	
	var square_border_stylebox = stylebox_flat({
		border_width_bottom = border_width / 2,
		border_width_left = border_width / 2,
		border_width_right = border_width / 2,
		border_width_top = border_width / 2
	})

	define_style("ColorPickerButton", {
		focus = inherit(square_border_stylebox, {
			border_color = Color.AQUA
		}),
		hover = inherit(square_border_stylebox, {
			border_color = Color.AQUA
		}),
		normal = inherit(square_border_stylebox, {
			border_color = Color.WHITE
		})
	})

	define_style("LineEdit", {
		font_color = text_font_color,
		focus = inherit(square_border_stylebox, {
			bg_color = COLOR_CLEAR,
			border_color = Color.AQUA
		}),
		normal = inherit(square_border_stylebox, {
			bg_color = COLOR_PURPLE,
			border_color = COLOR_PURPLE
		}),
		read_only = inherit(square_border_stylebox, {
			bg_color = COLOR_DISABLED,
			border_color = COLOR_DISABLED
		})
	})

	define_style("TextEdit", {
		font_color = text_font_color,
		focus = inherit(square_border_stylebox, {
			bg_color = COLOR_CLEAR,
			border_color = Color.AQUA
		}),
		normal = inherit(square_border_stylebox, {
			bg_color = COLOR_PURPLE,
			border_color = COLOR_PURPLE
		}),
		read_only = inherit(square_border_stylebox, {
			bg_color = COLOR_DISABLED,
			border_color = COLOR_DISABLED
		})
	})
	
	var slider_thickness = 4
	
	define_style("VSlider", {
		grabber_area = stylebox_flat({
			bg_color = COLOR_DARK_PURPLE
		}),
		grabber_area_highlight = stylebox_flat({
			bg_color = COLOR_DARK_PURPLE
		}),
		slider = stylebox_flat({
			bg_color = COLOR_CLEAR,
			content_margin_left = slider_thickness,
			content_margin_right = slider_thickness
		})
	})

	define_style("HSlider", {
		grabber_area = stylebox_flat({
			bg_color = COLOR_DARK_PURPLE
		}),
		grabber_area_highlight = stylebox_flat({
			bg_color = COLOR_DARK_PURPLE
		}),
		slider = stylebox_flat({
			bg_color = COLOR_CLEAR,
			content_margin_bottom = slider_thickness,
			content_margin_top = slider_thickness,
		})
	})
