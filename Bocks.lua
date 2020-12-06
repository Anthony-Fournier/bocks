-- Anthony Fournier, adavidfour@yahoo.com, github.com/Anthony-Fournier
-- Harvardx CS50x 11/2020 Final Project - Games Track
-- Class for Bocks object, for game titled, Bocks
Bocks = Class{}
-- Init
function Bocks:init(x,y)
	self.x = x
	self.y = y
	-- Static size of Bocks to avoid magic numbers
	self.dia = BOCKSSIZE
	self.width = self.dia * 2
	self.height = self.dia * 2
	self.dx = 0
	self.dy = 0
	-- RNG BocksState for initialization
	local rndNum = love.math.random(3)
	if rndNum == 1 then
		self.BocksState = 'ball'
	elseif rndNum  == 2 then
		self.BocksState = 'box'
	elseif rndNum == 3 then
		self.BocksState = 'tri'
	end
end
-- Update
function Bocks:update(dt)
  -- Moves Bocks, keeping it within VIRTUAL window size
  if self.dy < 0 then
    self.y = math.max(0, self.y + self.dy * dt)
  else
    self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
  end
  if self.dx < 0 then
    self.x = math.max(0, self.x + self.dx * dt)
  else
    self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
  end
end
-- Draw
function Bocks:render(r,g,b)
  if self.BocksState == 'box' then
		love.graphics.setColor(r,g,b)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
  elseif self.BocksState == 'ball' then
		love.graphics.setColor(r,g,b)
    love.graphics.circle('line', self.x + self.dia, self.y + self.dia, self.dia)
  elseif self.BocksState == 'tri' then
		love.graphics.setColor(r,g,b)
    love.graphics.polygon('line', self.x,self.y + self.height,
			self.x + self.width,self.y + self.height,
      self.x + self.width / 2, self.y)
	end
end
