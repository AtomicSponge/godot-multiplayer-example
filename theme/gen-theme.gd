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

	const BORDER_WIDTH = 2
	const BORDER_RADIUS = 8

	define_style("Panel", {
		panel = stylebox_flat({
			bg_color = background_color,
			border_color = Color.WHITE,
			border_width_bottom = BORDER_WIDTH,
			border_width_left = BORDER_WIDTH,
			border_width_right = BORDER_WIDTH,
			border_width_top = BORDER_WIDTH,
			corner_radius_bottom_left = BORDER_RADIUS,
			corner_radius_bottom_right = BORDER_RADIUS,
			corner_radius_top_left = BORDER_RADIUS,
			corner_radius_top_right = BORDER_RADIUS
		})
	})

	define_style("Label", {
		font_color = text_font_color
	})

	var curved_border_stylebox = stylebox_flat({
		border_width_bottom = int(float(BORDER_WIDTH) / 2.0),
		border_width_left = int(float(BORDER_WIDTH) / 2.0),
		border_width_right = int(float(BORDER_WIDTH) / 2.0),
		border_width_top = int(float(BORDER_WIDTH) / 2.0),
		corner_radius_bottom_left = BORDER_RADIUS,
		corner_radius_bottom_right = BORDER_RADIUS,
		corner_radius_top_left = BORDER_RADIUS,
		corner_radius_top_right = BORDER_RADIUS
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

	define_style("CheckButton", {
		checked = ResourceLoader.load("res://theme/icons/memory--checkbox-intermediate.png"),
		unchecked = ResourceLoader.load("res://theme/icons/memory--checkbox-blank.png"),
	})
	
	define_style("CheckBox", {
		checked = ResourceLoader.load("res://theme/icons/memory--checkbox-cross.png"),
		unchecked = ResourceLoader.load("res://theme/icons/memory--checkbox-blank.png")
	})

	var square_border_stylebox = stylebox_flat({
		border_width_bottom = int(float(BORDER_WIDTH) / 2.0),
		border_width_left = int(float(BORDER_WIDTH) / 2.0),
		border_width_right = int(float(BORDER_WIDTH) / 2.0),
		border_width_top = int(float(BORDER_WIDTH) / 2.0),
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
		grabber = ResourceLoader.load("res://theme/icons/memory--dot-octagon-fill.png"),
		grabber_highlight = ResourceLoader.load("res://theme/icons/memory--dot-octagon-fill.png"),
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
	
	var scroll_bar_grabber = stylebox_flat({
		bg_color = COLOR_DARK_PURPLE
	})
	
	var scroll_bar_background = stylebox_flat({
		bg_color = COLOR_PURPLE,
		content_margin_left = slider_thickness,
		content_margin_right = slider_thickness,
		content_margin_bottom = slider_thickness,
		content_margin_top = slider_thickness,
	})
	
	define_style("VScrollBar", {
		grabber = scroll_bar_grabber,
		grabber_highlight = scroll_bar_grabber,
		grabber_pressed = scroll_bar_grabber,
		scroll = scroll_bar_background
	})

	define_style("HSlider", {
		grabber = ResourceLoader.load("res://theme/icons/memory--dot-octagon-fill.png"),
		grabber_highlight = ResourceLoader.load("res://theme/icons/memory--dot-octagon-fill.png"),
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
	
	define_style("HScrollBar", {
		grabber = scroll_bar_grabber,
		grabber_highlight = scroll_bar_grabber,
		grabber_pressed = scroll_bar_grabber,
		scroll = scroll_bar_background
	})
