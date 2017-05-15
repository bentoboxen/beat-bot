require 'discordrb'

class AudioQueue 

	def initialize(voiceBot)
		@voice_bot = voiceBot
		puts "init: no voice bot?" if @voice_bot.nil?
		@semaphore = Mutex.new
		@thread = Thread.new {run()}
	end

	def playBackground(file)
		@semaphore.lock
		@background = file
		interrupt
		@semaphore.unlock
		return nil
	end

	def playEffect(file)
		@semaphore.lock
		@effect = file
		@skip = Time.now().to_i - @backGroundStarted.to_i if !@backGroundStarted.nil?
		interrupt
		@semaphore.unlock
		return nil
	end

	def stop() 
		@semaphore.lock
		@effect = nil
		@background = nil
		interrupt
		@semaphore.unlock
		return nil
	end

	def volume(v)
		@semaphore.lock
		@skip = Time.now().to_i - @backGroundStarted.to_i if !@backGroundStarted.nil?
		@voice_bot.filter_volume=(v)
		interrupt
		@semaphore.unlock
		return nil
	end

	private

	def interrupt()
		puts "interrupt"
		puts "no voice bot?" if @voice_bot.nil?
		@voice_bot.stop_playing if @voice_bot.playing?
	end

	def play(name, bg)
		folder = bg ? "bg" : "effects"
		puts "playing #{name}"
		puts "no voice bot?" if @voice_bot.nil?
		puts Dir["audio/#{folder}/#{name}*"].first
		@voice_bot.play_file(Dir["audio/#{folder}/#{name}*"].first)
	end

	def run()
		loop do
			puts "loop start"
			loop do
				localEffect = getEffect
				puts "waiting sound #{localEffect}"
				break if localEffect.nil?
				puts "play effect #{@effect}"
				play(localEffect, false) 
			end

			puts "sync bg"

			localBackground = getBackground
			@backGroundStarted = (Time.now.to_i - @skip.to_i ) if !localBackground.nil?
			puts "bgs #{@backGroundStarted}"
			localSkip = @skip
			@skip = nil

			puts "bg: #{localBackground} @ #{localSkip}"

			if !localSkip.nil? 
				Thread.new {skip(localSkip)}
			end
			play(localBackground, true) unless localBackground.nil?
			puts "loop end"
			sleep 1
		end
		puts "done?"
	end

	def getBackground() 
		@semaphore.lock
		localBackground = @background
		@semaphore.unlock
		return localBackground
	end

	def getEffect()
		@semaphore.lock
		localEffect = @effect
		@effect = nil
		@semaphore.unlock
		return localEffect
	end

	def skip(seconds)
		i = 10
		loop do
			sleep 0.01
			@voice_bot.skip(seconds) if @voice_bot.playing?
			i -= 1
			break if @voice_bot.playing? || i < 0
		end
	end
end