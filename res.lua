-----------------------------------------------------------------------------------------
--
-- res.lua
--
-----------------------------------------------------------------------------------------

local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

local score = composer.getVariable("finalScore")

--local function gotoFirst()
--	composer.gotoScene("view1")
--end

function scene:create( event )
	local sceneGroup = self.view
	
	if (score >= 1500) then
		local bg1 = display.newImage("Fruit/엔딩컷인(성공).png", display.contentWidth, display.contentHeight)
  		bg1.x, bg1.y = display.contentWidth/2, display.contentHeight/2
  	else 
  		local bg2 = display.newImage("Fruit/엔딩컷인(실패).png", display.contentWidth, display.contentHeight)
  		bg2.x, bg2.y = display.contentWidth/2, display.contentHeight/2
  	end

  	--local retry = display.newImageRect("Fruit/처음으로.png", 316, 142)
  	--retry.x, retry.y = display.contentWidth/2+350, display.contentHeight/2+235
  	--transition.blink( retry, { time=1000 } )
  
  	--retry:addEventListener("tap", gotoFirst)

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