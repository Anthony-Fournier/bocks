-- Anthony Fournier, adavidfour@yahoo.com, github.com/Anthony-Fournier
-- Harvardx CS50x 11/2020 Final Project - Games Track game titled, Bocks
--
-- push library required to draw in virtual resolution https://github.com/Ulydev/push
-- for a more retro-game aesthetic
push = require 'push'
-- Class library allows representation of anything as code, eliminating the
-- complexity of having many disparate variables and methods
Class = require 'class'
-- Include the following required Classes
require 'Bocks'
--
-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
-- GLOBAL Variables
-- Window size
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
-- ATARI-like virtual resolution for push VIRTUAL window size
VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 240
-- Base size of Bocks'
BOCKSSIZE = 8
-- Movement speed of Bocks'
SPEED = 100
-- Number of enemies
ENEMIES_MAX = 10
gamestate = 'start'
-- Score count
score = 0
-- Initialization
function love.load()
-- RNG seed
  math.randomseed(os.time())
-- Set graphics filter for a crisper image
  love.graphics.setDefaultFilter('nearest', 'nearest')
-- Set draw line style
  love.graphics.setLineJoin('miter')
  love.graphics.setLineWidth(.5)
-- Window settings
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
    {
        fullscreen = false,
        resizable = true
    })
-- Window title
    love.window.setTitle('Bocks')
-- Set font
    font = love.graphics.newFont('fonts/font.ttf', 16)
-- Initialize player as Bocks
    player = Bocks(VIRTUAL_WIDTH / 2 - BOCKSSIZE * 2, VIRTUAL_HEIGHT / 2 - BOCKSSIZE * 2)
-- Initialize enemies into array as Bocks'
  enemies = {}
	local i = 0
	while i < ENEMIES_MAX do
      local x = math.random(VIRTUAL_WIDTH - BOCKSSIZE * 2)
      local y = math.random(VIRTUAL_HEIGHT - BOCKSSIZE * 2)
      enemies[#enemies+1] = Bocks(x,y)
			i = i + 1
	end
  -- Setup background music
  music = love.audio.newSource('sounds/song.wav', 'static')
  music:setLooping(true)
  -- Setup Game over music
  endmusic = love.audio.newSource('sounds/endsong.wav', 'static')
  endmusic:setLooping(true)
  -- Setup victory music
  winmusic = love.audio.newSource('sounds/winsong.wav', 'static')
  winmusic:setLooping(true)
  -- Setup startscreen music
  startmusic = love.audio.newSource('sounds/startsong.wav', 'static')
  startmusic:setLooping(true)
end
-- Re-size
function love.resize(w, h)
    push:resize(w, h)
end
-- Keybinds
function love.keypressed(key)
  if key == 'return' then
    gamestate = 'play'
  end
  if key == 'escape' then
      love.event.quit()
  end
  if key == 'space' then
    -- Transform shape
    if player.BocksState == 'ball' then
      player.BocksState = 'box'
    elseif player.BocksState == 'box' then
      player.BocksState = 'tri'
    else
      player.BocksState = 'ball'
    end
  end
end
  -- Update, dt == 1/60th sec
function love.update(dt)
  if gamestate == 'play' then
    -- Player input for holding a key down for an extended period of time
    if love.keyboard.isDown('up') then
      player.dy = -SPEED
    elseif love.keyboard.isDown('down') then
      player.dy = SPEED
    else
      player.dy = 0
    end
    if love.keyboard.isDown('left') then
      player.dx = -SPEED
    elseif love.keyboard.isDown('right') then
      player.dx = SPEED
    else
      player.dx = 0
    end
    -- Player update
    player:update(dt)
    -- Enemy AI update
    for i,enemy in ipairs(enemies) do
      if enemy.BocksState == 'ball' then
        if player.BocksState == 'ball' then
          -- do nothing
          enemy.dx = 0
          enemy.dy = 0
        elseif player.BocksState == 'box' then
          -- run
          if enemy.x > player.x then
            enemy.dx = SPEED/5
          elseif enemy.x < player.x then
            enemy.dx = -SPEED/5
          end
          if enemy.y > player.y then
            enemy.dy = SPEED/5
          elseif enemy.y < player.y then
            enemy.dy = -SPEED/5
          end
        elseif player.BocksState == 'tri' then
          -- chase
        if enemy.x > player.x then
          enemy.dx = -SPEED/5
        elseif enemy.x < player.x then
          enemy.dx = SPEED/5
        end
        if enemy.y > player.y then
          enemy.dy = -SPEED/5
        elseif enemy.y < player.y then
          enemy.dy = SPEED/5
        end
      end
      elseif enemy.BocksState == 'box' then
        if player.BocksState == 'ball' then
          -- chase
          if enemy.x > player.x then
            enemy.dx = -SPEED/5
          elseif enemy.x < player.x then
            enemy.dx = SPEED/5
          end
          if enemy.y > player.y then
            enemy.dy = -SPEED/5
          elseif enemy.y < player.y then
            enemy.dy = SPEED/5
          end
        elseif player.BocksState == 'box' then
          -- do nothing
          enemy.dx = 0
          enemy.dy = 0
        elseif player.BocksState == 'tri' then
          -- run
          if enemy.x > player.x then
            enemy.dx = SPEED/5
          elseif enemy.x < player.x then
            enemy.dx = -SPEED/5
          end
          if enemy.y > player.y then
            enemy.dy = SPEED/5
          elseif enemy.y < player.y then
            enemy.dy = -SPEED/5
          end
        end
      elseif enemy.BocksState == 'tri' then
        if player.BocksState == 'ball' then
          -- run
          if enemy.x > player.x then
            enemy.dx = SPEED/5
          elseif enemy.x < player.x then
            enemy.dx = -SPEED/5
          end
          if enemy.y > player.y then
            enemy.dy = SPEED/5
          elseif enemy.y < player.y then
            enemy.dy = -SPEED/5
          end
        elseif player.BocksState == 'box'  then
          --chase
          if enemy.x > player.x then
            enemy.dx = -SPEED/5
          elseif enemy.x < player.x then
            enemy.dx = SPEED/5
          end
          if enemy.y > player.y then
            enemy.dy = -SPEED/5
          elseif enemy.y < player.y then
            enemy.dy = SPEED/5
          end
        elseif player.BocksState == 'tri' then
          -- do nothing
          enemy.dx = 0
          enemy.dy = 0
        end
      end
      -- Enemy update
      enemy:update(dt)
    end
    -- Collision detection and resolution
    for i,enemy in ipairs(enemies) do
      if CheckCollision(player.x,player.y,player.width,player.height,
        enemy.x,enemy.y,enemy.width,enemy.height) then
          if player.BocksState == enemy.BocksState then
          -- nothing / something
          elseif player.BocksState == 'ball' then
            if enemy.BocksState == 'tri' then
              table.remove(enemies, i)
              score = score + 1
            elseif enemy.BocksState == 'box' then
              gamestate = 'end'
            end
          elseif player.BocksState == 'box' then
            if enemy.BocksState == 'ball' then
              table.remove(enemies, i)
              score = score + 1
            elseif enemy.BocksState == 'tri' then
              gamestate = 'end'
            end
          elseif player.BocksState == 'tri' then
            if enemy.BocksState == 'box' then
              table.remove(enemies, i)
              score = score + 1
            elseif enemy.BocksState == 'ball' then
              gamestate = 'end'
            end
          end
      end
    end
    if score == ENEMIES_MAX then gamestate = 'win' end
  end
end
-- Render to screen
function love.draw()
	push:apply('start')
  if gamestate == 'play' then
    startmusic:stop()
    music:play()
    -- Clear screen
  	love.graphics.clear(0,0,0)
    -- Draw eneimes
    for i,enemy in ipairs(enemies) do
      enemy:render(57/255,255/255,20/255)
    end
    -- Draw player
    player:render(254/255,0,254/255)
  elseif gamestate == 'end' then
    -- Game over screen
    love.graphics.clear(0,0,0)
    love.graphics.setFont(font)
    love.graphics.setColor(254/255,0,254/255)
    love.graphics.printf("GAME OVER", VIRTUAL_WIDTH / 2 - 125,
      VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(57/255,255/255,20/255)
    love.graphics.printf("Press 'ESC' to quit", VIRTUAL_WIDTH / 2 - 125,
      VIRTUAL_HEIGHT / 2 + 25, VIRTUAL_WIDTH, 'center')
    -- End background music
    music:stop()
    -- Start gameover music
    endmusic:play()
  elseif gamestate == 'win' then
    -- Win screen
    love.graphics.clear(0,0,0)
    love.graphics.setFont(font)
    love.graphics.setColor(57/255,255/255,20/255)
    love.graphics.printf("WINNER!", VIRTUAL_WIDTH / 2 - 125,
      VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(254/255,0,254/255)
    love.graphics.printf("Press 'ESC' to quit", VIRTUAL_WIDTH / 2 - 125,
      VIRTUAL_HEIGHT / 2 + 25, VIRTUAL_WIDTH, 'center')
    -- End background music
    music:stop()
    -- Start victory music
    winmusic:play()
  elseif gamestate == 'start' then
    -- Title screen
    love.graphics.clear(0,0,0)
    love.graphics.setFont(font)
    love.graphics.setColor(57/255,255/255,20/255)
    love.graphics.printf("BOCKS", VIRTUAL_WIDTH / 2 - 125,
      VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(254/255,0,254/255)
    love.graphics.printf("Press 'Enter' to continue", VIRTUAL_WIDTH / 2 - 125,
      VIRTUAL_HEIGHT / 2 + 25, VIRTUAL_WIDTH, 'center')
    -- Start title screen music
    startmusic:play()
  end
  push:apply('end')
end
