-----------------------------------------------------------------------------------------
--
-- start.lua
--
-----------------------------------------------------------------------------------------

local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()
local i, j, score = 0, 0, 0
--local view = {}

local function gotoGame()
  composer.gotoScene("view1")
end

function scene:create( event )
	local sceneGroup = self.view
	
	background = display.newImageRect("Fruit/오프닝컷인.png", display.contentWidth, display.contentHeight)
  background.x, background.y = display.contentWidth/2, display.contentHeight/2

  local start = display.newImageRect("Fruit/시작버튼.png", 316, 142)
  start.x, start.y = display.contentWidth/2+315, display.contentHeight/2+215
  transition.blink( start, { time=1000 } )
  
  start:addEventListener("tap", gotoGame)

  -- main 끝
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene