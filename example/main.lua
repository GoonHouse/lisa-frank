-- this demo was based on the smoke shader demo, so, that's why things are the way they are

package.path = package.path .. ";../?.lua" -- to load from base directory

local lisa_frank = require 'lisa_frank'

local testimg = love.image.newImageData("testimage.png")
local basedims = {testimg:getDimensions()}
--[[WHERE:
	graphic_steps			[0,    1,   2,   3]
	graphic_ceil_x4_1-4		[64, 128, 192, 255]		math.ceil((x/4)*255)	for 1-4
	graphic_ceil_x4_0-3		[0,   64, 128, 192]		math.ceil((x/4)*255)	for 0-3
	graphic_floor_x4_0-3	[0,   64, 128, 191]		math.floor((x/4)*255)	for 0-3
]]
local baseimg = love.graphics.newImage("background.jpg")

local draw_coords = {}
local draw_images = {}

local exportTimer = 0

lisa_frank:setPalette(love.image.newImageData("palette.png"))

function love.load()
	love._openConsole()
	for i=1,lisa_frank.num_palettes do
		table.insert(draw_coords, {basedims[1]*i-basedims[1], basedims[2]*i-basedims[2]})
		local img = lisa_frank:transform(testimg, i)
		table.insert(draw_images, love.graphics.newImage(img))
	end
end

function love.draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.clear()
	love.graphics.draw(baseimg, 0, 0)
	
	for i=1, #draw_coords do
		love.graphics.draw(draw_images[i], draw_coords[i][1], draw_coords[i][2])
	end
end

local lastModified = love.filesystem.getLastModified("main.lua")

function love.update(dt)
	------------To make the code update in real time
	if(love.filesystem.getLastModified("main.lua") ~= lastModified)then 
		local testFunc = function()
			love.filesystem.load('main.lua')
		end
		local test,e = pcall(testFunc)
		if(test)then 
		 	love.filesystem.load('main.lua')()
		 	love.run()
		else 
			print(e)
		end
		lastModified = love.filesystem.getLastModified("main.lua")
	end
	
	if(love.keyboard.isDown("x") and exportTimer <= 0)then
		love.graphics.newScreenshot():encode("debug.png")
		exportTimer = 10
	end
	
	if exportTimer >= 0 then
		exportTimer = exportTimer-dt
	end
end