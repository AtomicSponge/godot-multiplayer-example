@tool
extends ProgrammaticTheme
const UPDATE_ON_SAVE = true

const DEFAULT_FONT: String = "res://theme/font/Poco.ttf"
const DEFAULT_FONT_SIZE: int = 24

const TEXT_FONT_COLOR: Color = Color.WHITE
const BACKGROUND_COLOR: Color = Color.DARK_SLATE_BLUE

const BORDER_COLOR: Color = Color.WHITE
const BORDER_HIGHLIGHT_COLOR: Color = Color.AQUA
const BORDER_WIDTH: int = 2
const BORDER_RADIUS: int = 8

const SLIDER_THICKNESS: int = 4

const COLOR_DARK_PURPLE: Color = Color(0.11, 0.09, 0.22, 1.0)
const COLOR_PURPLE: Color = Color(0.16, 0.14, 0.32, 1.0)
const COLOR_DISABLED: Color = Color(0.11, 0.09, 0.22, 0.2)
const COLOR_CLEAR: Color = Color(0.0, 0.0, 0.0, 0.0)

func setup():
	set_save_path("res://theme//theme.tres")

func define_theme():
	define_default_font(ResourceLoader.load(DEFAULT_FONT))
	define_default_font_size(DEFAULT_FONT_SIZE)

	define_style("Panel", {
		panel = stylebox_flat({
			bg_color = BACKGROUND_COLOR,
			border_color = BORDER_COLOR,
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
		font_color = TEXT_FONT_COLOR
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
		font_color = TEXT_FONT_COLOR,
		disabled = inherit(curved_border_stylebox, {
			bg_color = COLOR_DISABLED,
			border_color = COLOR_DISABLED
		}),
		focus = inherit(curved_border_stylebox, {
			bg_color = COLOR_CLEAR,
			border_color = BORDER_HIGHLIGHT_COLOR
		}),
		hover = inherit(curved_border_stylebox, {
			bg_color = COLOR_DARK_PURPLE,
			border_color = BORDER_HIGHLIGHT_COLOR
		}),
		normal = inherit(curved_border_stylebox, {
			bg_color = COLOR_DARK_PURPLE,
			border_color = BORDER_COLOR
		}),
		pressed = inherit(curved_border_stylebox, {
			bg_color = Color.DARK_MAGENTA,
			border_color = Color.WHITE
		})
	})
	
	var CHECK_STYLE = stylebox_flat({
		bg_color = BACKGROUND_COLOR
	})

	define_style("CheckButton", {
		checked = ResourceLoader.load("res://theme/icons/memory--checkbox-intermediate.png"),
		unchecked = ResourceLoader.load("res://theme/icons/memory--checkbox-blank.png"),
		focus = CHECK_STYLE,
		normal = CHECK_STYLE,
		hover = CHECK_STYLE,
		pressed = CHECK_STYLE
	})
	
	define_style("CheckBox", {
		checked = ResourceLoader.load("res://theme/icons/memory--checkbox-cross.png"),
		unchecked = ResourceLoader.load("res://theme/icons/memory--checkbox-blank.png"),
		focus = CHECK_STYLE,
		normal = CHECK_STYLE,
		hover = CHECK_STYLE,
		pressed = CHECK_STYLE
	})

	var square_border_stylebox = stylebox_flat({
		border_width_bottom = int(float(BORDER_WIDTH) / 2.0),
		border_width_left = int(float(BORDER_WIDTH) / 2.0),
		border_width_right = int(float(BORDER_WIDTH) / 2.0),
		border_width_top = int(float(BORDER_WIDTH) / 2.0),
	})

	define_style("ColorPickerButton", {
		focus = inherit(square_border_stylebox, {
			border_color = BORDER_HIGHLIGHT_COLOR
		}),
		hover = inherit(square_border_stylebox, {
			border_color = BORDER_HIGHLIGHT_COLOR
		}),
		normal = inherit(square_border_stylebox, {
			border_color = BORDER_COLOR
		})
	})

	define_style("LineEdit", {
		font_color = TEXT_FONT_COLOR,
		focus = inherit(square_border_stylebox, {
			bg_color = COLOR_CLEAR,
			border_color = BORDER_HIGHLIGHT_COLOR
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
		font_color = TEXT_FONT_COLOR,
		focus = inherit(square_border_stylebox, {
			bg_color = COLOR_CLEAR,
			border_color = BORDER_HIGHLIGHT_COLOR
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
			content_margin_left = SLIDER_THICKNESS,
			content_margin_right = SLIDER_THICKNESS
		})
	})

	var scroll_bar_grabber = stylebox_flat({
		bg_color = COLOR_DARK_PURPLE
	})

	var scroll_bar_background = stylebox_flat({
		bg_color = COLOR_PURPLE,
		content_margin_left = SLIDER_THICKNESS,
		content_margin_right = SLIDER_THICKNESS,
		content_margin_bottom = SLIDER_THICKNESS,
		content_margin_top = SLIDER_THICKNESS,
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
			content_margin_bottom = SLIDER_THICKNESS,
			content_margin_top = SLIDER_THICKNESS,
		})
	})

	define_style("HScrollBar", {
		grabber = scroll_bar_grabber,
		grabber_highlight = scroll_bar_grabber,
		grabber_pressed = scroll_bar_grabber,
		scroll = scroll_bar_background
	})

	define_style("ProgressBar", {
		background = stylebox_flat({
			bg_color = COLOR_PURPLE
		}),
		fill = stylebox_flat({
			bg_color = COLOR_DARK_PURPLE
		})
	})
