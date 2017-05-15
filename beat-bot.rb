::RBNACL_LIBSODIUM_GEM_LIB_PATH = "E:/ruby/devkit/libsodium.dll"
require 'discordrb'
require './audioqueue'

bot = Discordrb::Commands::CommandBot.new token: 'MzEyMTAxNDQ3MzMwMjk5OTA2.C_WWfg.90ZJlaMfB09og8lMx18Daf2y0VI', client_id: 312101447330299906, prefix: 'bb '

bot.command(:connect) do |event|
	connect(bot, event)
end

bot.command(:c) do |event|
	connect(bot, event)
end

bot.command(:list) do |event, type|
	list(type)
end

bot.command(:l) do |event, type|
	list(type)
end

bot.command(:play) do |event, name|
	play(name, false)
end

bot.command(:p) do |event, name|
	play(name, false)
end

bot.command(:background) do |event, name|
	play(name, true)
end

bot.command(:bg) do |event, name|
	play(name, true)
end

bot.command(:s) do |event|
	$queue.stop() unless $queue.nil?
end

bot.command(:stop) do |event|
	$queue.stop() unless $queue.nil?
end

bot.command(:volume) do |event, volume|
	setVolume(volume)
end

bot.command(:v) do |event, volume|
	setVolume(volume)
end

bot.command(:help) do |event|
	help()
end

bot.command(:h) do |event|
	help()
end

def connect(bot, event)
	channel = event.user.voice_channel
	return "You're not in any voice channel!" unless channel
	$queue = AudioQueue.new(bot.voice_connect(channel))
	return "connected to voice channel #{channel.name}, call me bb."
end

def play(name, bg)
	source = bg ? "backgrounds" : "effects"
	folder = bg ? "bg" : "effects"
	puts Dir["audio/#{folder}/#{name}*"].first
	return "could not find sound #{name} in #{source}" if Dir["audio/#{folder}/#{name}*"].empty?
	$queue.playBackground(name) if bg && !$queue.nil?
	$queue.playEffect(name) if !bg && !$queue.nil?
end

def list(type)
	folder = (type == "bg" || type == "background") ? "bg" : "effects"
	l = type ? "backgrounds:\n" : "effects:\n"
	Dir["audio/#{folder}/*"].each{ |f| l << File.basename(f, ".*") + "\n" }
	return l
end

def setVolume(volume)
	return 'These do not go to 11.' if volume == '11'
	return 'You can set a volume between 1 and 10.' if volume.to_i > 11
	v = volume.to_f/10 if volume.to_f >= 1
	$queue.volume(v) unless $queue.nil?
	return nil
end 

def help()
	return "c/connect: to invite to a voice channel you are in.\n"\
	"l/list (background/bg/effects/e): lists all available sounds for type.\n"\
	"p/play (sound): plays a known sound.\n"\
	"bg/background (sound): plays a known sound as back ground music.\n"\
	"v/volume (1-10): sets the volume.\n"\
	"s/stop: stops all playback."
end

bot.run