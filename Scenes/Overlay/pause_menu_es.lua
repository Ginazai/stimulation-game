-----------------------------------------
-- Pause Menu
-----------------------------------------
--libraries
local composer = require( "composer" )
local scene = composer.newScene()
--Sounds
local chalkSound = audio.loadSound( "Audio/chalk-tap.mp3" ) --back button chalk sound
local playChalk = nil
--functions
local function gotoMenu()
	playChalk = audio.play( chalkSound )
	composer.gotoScene( "Scenes.play_menu_es", { time=100, effect="slideUp" } ) 
end
local function onResume()
	playChalk = audio.play( chalkSound )
	composer.hideOverlay( "slideUp", 175 )
end
-----------------------------------------
-- Scenes
-----------------------------------------
function scene:create( event )
	local sceneGroup = self.view 

	local mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup )

	local uiGroup = display.newGroup()
	sceneGroup:insert( uiGroup )

	local background = display.newImageRect( mainGroup, "Assets/Background/pause.jpg", 700, 375 ) --background
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local questionText = display.newText( mainGroup, "Seguro que quieres salir?", display.contentCenterX, 100, "Fonts/FORTE.TTF", 35 )
	questionText.font = native.newFont( "Fonts.FORTE", 16 )
	questionText:setTextColor( 1 )

	local option1 = display.newText( mainGroup, "Sí", display.contentCenterX, 180, "Fonts/FORTE.TTF", 35 )
	option1.font = native.newFont( "Fonts.FORTE", 16 )
	option1:setTextColor( 1 )

	local option2 = display.newText( mainGroup, "No", display.contentCenterX, 230, "Fonts/FORTE.TTF", 35 )
	option2.font = native.newFont( "Fonts.FORTE", 16 )
	option2:setTextColor( 1 )

	option1:addEventListener( "tap", gotoMenu )
	option2:addEventListener( "tap", onResume )
end
function scene:show( event )
	local sceneGroup = self.view 
	local phase = event.phase

	if( phase == "will" )then
	elseif( phase == "did" )then
		activeVoice("Audio/voice/exit.wav")
	end
end
function scene:hide( event )
	local sceneGroup = self.view 
	local phase = event.phase
	local parent = event.parent

	if( phase == "will" )then
	elseif( phase == "did" )then
		if (playQuestion ~= nil)then audio.stop( playQuestion ) end
		playQuestion = nil
		composer.hideOverlay("Scenes.Overlay.pause_menu_es")
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
return scene