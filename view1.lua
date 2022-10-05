-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

math.randomseed( os.time() )

local widget = require( "widget" )
local composer = require( "composer" )
local physics = require("physics")
physics.start()
physics.setGravity(0, 9.8*0.75) -- 중력가속도

local scene = composer.newScene()
local i, j, score = 0, 0, 0
--local view = {}

-- GUI

local background
local gameUI = {}
--local apples = {}

function createWalls() -- 맞고 튕겨나갈 수 있는 벽 생성
    local wallThickness = 10

    -- Left wall
    local wall = display.newRect(0, display.contentHeight/2, wallThickness, display.contentHeight)
    physics.addBody(wall, "static", {friction=0, bounce = 1})
    -- Top wall
    wall = display.newRect(display.contentWidth/2, 0, display.contentWidth, wallThickness)
    physics.addBody(wall, "static", {friction=1, bounce = 1})
    -- Right wall
    wall = display.newRect(display.contentWidth - wallThickness + 10, display.contentHeight/2, wallThickness, display.contentHeight)
    physics.addBody(wall, "static", {friction=1, bounce = 1})
    -- Bottom wall
    wall = display.newRect(display.contentWidth/2, display.contentHeight - wallThickness + 10, display.contentWidth, wallThickness)
    physics.addBody(wall, "static", {friction=1, bounce = 1})

    --bounce 값이 한 쪽 벽에서만 커지면 가속도가 붙는다 ==> 속도 무한대로 증가함!
    --따라서 bounce 값은 4면에서 모두 일정하게 유지
end

function scene:create( event )
	local sceneGroup = self.view
	
	background = display.newImageRect("Fruit/BG_Forest.png", display.contentWidth, display.contentHeight)
   	background.x, background.y = display.contentWidth/2, display.contentHeight/2

   	createWalls()

   	-- Game UI 01

   	gameUI[0] = display.newRect(display.contentWidth/2, display.contentHeight/2, display.contentWidth, display.contentHeight)
    gameUI[0]:setFillColor(0)
    gameUI[0].alpha = 0.3

    gameUI[1] = display.newImage("Fruit/tips.png", 670, 150)
    gameUI[1].x, gameUI[1].y = display.contentWidth/2, display.contentHeight/8

    gameUI[7] = display.newText({
      text = "00000", x = 150, y = 75, width = 200,
      font = font, fontSize = 50, align = "left"
   })

    --local playerDamaged = display.newImageRect("Fruit/나며꾼_damage.png", 300*0.6, 480*0.6)
    --playerDamaged.x, playerDamaged.y = display.contentWidth/2-100, display.contentHeight/2+200
    --playerDamaged.alpha = 1

    local player = display.newImageRect("Fruit/나며꾼.png", 300*0.6, 480*0.6)
    player.x, player.y = display.contentWidth/2-100, display.contentHeight/2+200
    player.alpha = 1

    physics.addBody(player, "static", {friction = 0, bounce = 1})
    player.type = "destructible"

    local thorn = display.newImageRect("Fruit/나며꾼가시.png", 90, 90)
    thorn.x, thorn.y = player.x+200, player.y/8
    thorn.alpha = 1

    physics.addBody(thorn, "dynamic", {friction = 0, bounce = 1})
    thorn:addEventListener("collision", thorn)
    --thorn:setLinearVelocity(75, 150) -- 별도로 속도 지정 가능

    function createApple() -- 새로운 사과 생성

    	local apple = display.newImageRect("Fruit/나며꾼사과.png", 70, 70)
		apple.x, apple.y = player.x + math.floor(math.random(-500, 500)), player.y/8 -- 위치는 랜덤
		apple.alpha = 1

		physics.addBody(apple, "dynamic", {friction = 0, bounce = 1.25})
		apple:addEventListener("collision", apple)

		-- 만약 사과가 플레이어와 충돌(collision)한다면?

		apple.collision = function(self, event)
	    	if(event.other.type == "destructible") then
	    		self:removeSelf() -- 사과 사라짐
	    		score = score + 100
	    		gameUI[7].text = string.format("%05d", score) -- 점수를 다섯자리로 표시
	    	end
    	end

    	-- 플레이어가 사과를 얻지 못하고 바닥에 떨어진다면?

    	--function removeObject( event )
      --		apple.alpha = 0 -- 사과 사라짐
      --	end

     	local moveApple = transition.to( apple, { time=2500, alpha=0.2, y=(player.y+500), onComplete = createApple } )
    end
    
	local onTimerComplete = function(event)
		createApple()
    end

	timer.performWithDelay(100, onTimerComplete() , 1) -- 시간차를 두고 실행?

	-- 만약 플레이어가 가시열매와 충돌한다면?

    thorn.collision = function(self, event)
        if(event.other.type == "destructible") then
            score = score - 10
            gameUI[7].text = string.format("%05d", score) -- 점수를 다섯자리로 표시
			--transition.blink( player, { time = 2 } )
        end
        --timer.performWithDelay(10000, returnToOriginal() , 1)
    end

    function inputEvent( event ) -- 사용자가 누른 버튼의 이름을 리턴 

   		if event.target.name == "L" then
   			player.x, player.y = player.x - 75, player.y
   			--playerDamaged.x, playerDamaged.y = playerDamaged.x - 75, playerDamaged.y
   		elseif event.target.name == "R" then
   			player.x, player.y = player.x + 75, player.y
   			--playerDamaged.x, playerDamaged.y = playerDamaged.x + 75, playerDamaged.y
   		end
   end

   -- Game UI 02

   gameUI[4] = widget.newButton({ defaultFile = "Fruit/input_L.png", overFile = "Fruit/input_L_over.png", width = 75, height = 150, onPress = inputEvent })
   gameUI[4].x, gameUI[4].y = display.contentWidth-150-85, display.contentHeight-120
   gameUI[4].name = "L"

   gameUI[5] = widget.newButton({ defaultFile = "Fruit/input_R.png", overFile = "Fruit/input_R_over.png", width = 75, height = 150, onPress = inputEvent })
   gameUI[5].x, gameUI[5].y = display.contentWidth-150+85, display.contentHeight-120
   gameUI[5].name = "R"

   local function gotoRes()
   		transition.pause( moveApple )
   		composer.setVariable("finalScore", score) -- 사용자 점수를 res에 넘겨준다
   		composer.gotoScene("res")
   end

  -- timer

   local time = 10*6 -- 1분
   local cText = display.newText("60", 1100, 300, native.systemFont, 80)
   cText.x, cText.y = display.contentWidth/2+530, 75
   cText:setFillColor(1, 0.2, 0.2)

   local function Timer( event )
   		time = time - 1
   		local s = time % 60 -- 60''를 1'로 표시
   		local tDisplay = string.format("%02d", s)

   		cText.text = tDisplay
   end
	
	local tmr1 = timer.performWithDelay(1000, Timer, time) -- 1초
	local tmr2 = timer.performWithDelay(1000*10*6, gotoRes) -- 1분(60초)

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