extends Node

signal StartGame  # Start the game
signal EndGame    # End the game

signal UpdateName(new_name: String)  # Called when your Steam name is updated

signal ShowKill(text: String)  # Show kill message
