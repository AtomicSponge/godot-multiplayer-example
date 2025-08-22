extends Node

signal StartGame  # Start the game
signal EndGame(how: String)    # End the game

signal UpdatePlayerName  # Called when your Steam name is updated

signal ShowKill(text: String)  # Show kill message
