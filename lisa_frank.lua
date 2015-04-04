local lisa_frank = {
	_VERSION = "1.0.0",
	_DESCRIPTION = "A (love) palette helper for indexed images.",
	_URL = "https://github.com/GoonHouse/lisa-frank",
	_LICENSE = [[
		Copyright (c) 2015-??? EntranceJew, HammerGuy
		
		¯\_(ツ)_/¯
	]],
	
	palette_image = nil, --ImageData, the thing that we read from
	num_palettes = 0, --height of palette image, index is 1 based
	palette_depth = 0, --width of palette image, how many colors there are
	palette = {}, --a bunch of data
}

function lisa_frank:setPalette(pal)
	self.palette = {}
	
	-- build the palette table from the image to keep it out of memory
	local h, w = pal:getHeight(), pal:getWidth()
	for y=1,h do
		self.palette[y] = {}
		for x=1,w do
			self.palette[y][x]={pal:getPixel(x-1,y-1)}
		end
	end
	self.num_palettes, self.palette_depth = h, w
end

local function _routeMap(x, y, r, g, b, a)
	return unpack(lisa_frank.palette[lisa_frank.index][r+1])
end

function lisa_frank:transform(img, index)
	self.index = index
	local h, w = img:getHeight(), img:getWidth()
	local newImg = love.image.newImageData(h, w)
	-- something doesn't seem right here
	newImg:paste(img, 0, 0, 0, 0, h, w)
	newImg:mapPixel(_routeMap)
	return newImg
end

return lisa_frank