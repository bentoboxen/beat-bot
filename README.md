# beat-bot
Discord bot to queue background music and play sound effects

To setup: 
install discordrb https://github.com/meew0/discordrb make sure to follow steps for voice dependencies.

usage: ruby beat-bot.rb
Currently expects an "audio" folder in working directory with sub folders "bg" and "effects".

bot usage:
	bb c/connect: to invite to a voice channel you are in.
	bb l/list (background/bg/effects/e): lists all available sounds for type.
	bb p/play (sound): plays a known sound.
	bb bg/background (sound): plays a known sound as back ground music.
	bb v/volume (1-10): sets the volume.
	bb s/stop: stops all playback.
