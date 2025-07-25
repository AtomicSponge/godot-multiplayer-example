@tool
extends ProgrammaticTheme

var default_font = "res://theme/font/Poco.ttf"
var default_font_size = 24

var text_font_color = Color.WHITE

func setup():
	set_save_path("res://theme//theme.tres")

func define_theme():
	define_default_font(ResourceLoader.load(default_font))
	define_default_font_size(default_font_size)
	
	define_style("Label", {
		font_color = text_font_color,
		line_spacing = default_font_size
	})
	
	define_style("Button", {
		font_color = text_font_color
	})
