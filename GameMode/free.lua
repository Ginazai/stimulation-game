-----------------------------------------
-- Free Mode
-----------------------------------------
--file resources
--system.activate( "multitouch" ) --(not needed)
local composer = require( "composer" )
local scene = composer.newScene()
local json = require( "json" )
local sqlite = require( "sqlite3" ) --DB resource
local path = system.pathForFile( "data.db", system.DocumentsDirectory ) --path for DB
local db = sqlite.open( path ) 											--opening DB 
--initializing basic variables
local background
local selectedBackground
local backButton
local selectedSheets = {}
--sound handling (currently there's no need to create a soud table. might need if more resources are added)
local dropSound = audio.loadSound( "Audio/drop.mp3" ) --dropping sound
local dropPlay = nil

local rewindSound = audio.loadSound( "Audio/magic-2.mp3" ) --rewind sound
local playRewind = nil

local chalkSound = audio.loadSound( "Audio/chalk-tap.mp3" ) --back button chalk sound
local playChalk = nil

local errorSound = audio.loadSound( "Audio/error.mp3" ) --error sound
local playError = nil
--variables for data control
local score = 0 --initial score 
local expectedScore = nil -- expected score for the level
local scoreText --for testing score, might remove
local timeSpend = 0 --initial time
local selectedBasket = {} --for basket selection (logic is not scalable, should be rethink)
local mainSheet = nil
local secondarySheet = nil

local globalObject = nil 
local globalTarget = nil 
local eventTimeEnd = nil
-----------------------------------------
-- Sheets
-----------------------------------------
local fSheet = 
{	--Food sheet frames
	frames = 
	{
		{ --frame 1
			x = 0,
			y = 0,
			width = 295,
			height = 293
		},
		{ --frame 2
			x = 296,
			y = 0,
			width = 290,
			height = 293
		},
		{ --frame 3
			x = 591,
			y = 0,
			width = 291,
			height = 293
		},
		{ --frame 4
			x = 882,
			y = 0,
			width = 291,
			height = 293
		},
		{ --frame 5
			x = 1173,
			y = 0,
			width = 293,
			height = 293
		},
		{ --frame 6
			x = 1466,
			y = 0,
			width = 293,
			height = 293
		},
		{ --frame 7
			x = 1759,
			y = 0,
			width = 290,
			height = 293
		},
		{ --frame 8
			x = 2051,
			y = 0,
			width = 292,
			height = 293
		},
		{ --frame 9
			x = 2341,
			y = 0,
			width = 295,
			height = 293
		},
		{ --frame 10
			x = 2638,
			y = 0,
			width = 293,
			height = 293
		}
	},
	numframes = 10,
	sheetContentWidth = 2931,
	sheetContentHeight = 293
}
local aSheet = 	
{	--Animals sheet frames
	frames = 
	{
		{ --frame 1
			x = 0,
			y = 0,
			width = 295,
			height = 293
		},
		{ --frame 2
			x = 296,
			y = 0,
			width = 292,
			height = 293
		},
		{ --frame 3
			x = 591,
			y = 0,
			width = 291,
			height = 293
		},
		{ --frame 4
			x = 882,
			y = 0,
			width = 291,
			height = 293
		},
		{ --frame 5
			x = 1173,
			y = 0,
			width = 293,
			height = 293
		},
		{ --frame 6
			x = 1466,
			y = 0,
			width = 293,
			height = 293
		},
		{ --frame 7
			x = 1759,
			y = 0,
			width = 290,
			height = 293
		},
		{ --frame 8
			x = 2049,
			y = 0,
			width = 292,
			height = 293
		},
		{ --frame 9
			x = 2343,
			y = 0,
			width = 295,
			height = 293
		},
		{ --frame 10
			x = 2636,
			y = 0,
			width = 295,
			height = 293
		}
	},
	numframes = 10,
	sheetContentWidth = 2931,
	sheetContentHeight = 293
}
local cSheet = 	
{	--Clothes sheet frames
	frames = 
	{
		{ --frame 1
			x = 0,
			y = 0,
			width = 295,
			height = 293
		},
		{ --frame 2
			x = 296,
			y = 0,
			width = 292,
			height = 193
		},
		{ --frame 3
			x = 591,
			y = 0,
			width = 291,
			height = 293
		},
		{ --frame 4
			x = 882,
			y = 0,
			width = 285,
			height = 240
		},
		{ --frame 5
			x = 1173,
			y = 0,
			width = 293,
			height = 293
		},
		{ --frame 6
			x = 1466,
			y = 0,
			width = 293,
			height = 293
		},
		{ --frame 7
			x = 1759,
			y = 0,
			width = 290,
			height = 244
		},
		{ --frame 8
			x = 2049,
			y = 0,
			width = 289,
			height = 246
		},
		{ --frame 9
			x = 2343,
			y = 0,
			width = 295,
			height = 293
		},
		{ --frame 10
			x = 2636,
			y = 0,
			width = 295,
			height = 240
		}
	},
	numframes = 10,
	sheetContentWidth = 2928,
	sheetContentHeight = 244
}
local pSheet = 	
{	--Plants sheet frames
	frames = 
	{
		{ --frame 1
			x = 0,
			y = 0,
			width = 295,
			height = 293
		},
		{ --frame 2
			x = 296,
			y = 0,
			width = 292,
			height = 293
		},
		{ --frame 3
			x = 591,
			y = 0,
			width = 291,
			height = 293
		},
		{ --frame 4
			x = 882,
			y = 0,
			width = 291,
			height = 293
		},
		{ --frame 5
			x = 1173,
			y = 0,
			width = 293,
			height = 293
		},
		{ --frame 6
			x = 1466,
			y = 0,
			width = 293,
			height = 293
		},
		{ --frame 7
			x = 1759,
			y = 0,
			width = 290,
			height = 293
		},
		{ --frame 8
			x = 2049,
			y = 0,
			width = 292,
			height = 293
		},
		{ --frame 9
			x = 2343,
			y = 0,
			width = 295,
			height = 293
		},
		{ --frame 10
			x = 2636,
			y = 0,
			width = 295,
			height = 293
		}
	},
	numframes = 10,
	sheetContentWidth = 2930,
	sheetContentHeight = 293
}
local vSheet = 	
{	--Vehicles sheet frames
	frames = 
	{
		{ --frame 1
			x = 0,
			y = 0,
			width = 295,
			height = 293
		},
		{ --frame 2
			x = 296,
			y = 0,
			width = 292,
			height = 293
		},
		{ --frame 3
			x = 591,
			y = 0,
			width = 288,
			height = 293
		},
		{ --frame 4
			x = 882,
			y = 0,
			width = 291,
			height = 293
		},
		{ --frame 5
			x = 1173,
			y = 0,
			width = 293,
			height = 293
		},
		{ --frame 6
			x = 1466,
			y = 0,
			width = 293,
			height = 293
		},
		{ --frame 7
			x = 1759,
			y = 0,
			width = 290,
			height = 293
		},
		{ --frame 8
			x = 2049,
			y = 0,
			width = 292,
			height = 293
		},
		{ --frame 9
			x = 2343,
			y = 0,
			width = 295,
			height = 293
		},
		{ --frame 10
			x = 2636,
			y = 0,
			width = 295,
			height = 293
		}
	},
	numframes = 10,
	sheetContentWidth = 2930,
	sheetContentHeight = 293
}
foodSheet = graphics.newImageSheet( "Assets/Food/food-sheet.png", fSheet )
animalSheet = graphics.newImageSheet( "Assets/Animals/animals-sheet.png", aSheet )
clothesSheet = graphics.newImageSheet( "Assets/Clothes/clothes-sheet.png", cSheet )
plantsSheet = graphics.newImageSheet( "Assets/Plants/plants-sheet.png", pSheet )
vehiclesSheet = graphics.newImageSheet( "Assets/Vehicles/vehicles-sheet.png", vSheet )
-----------------------------------------
-- Functions
-----------------------------------------
--scene button handler
local function gotoPlayMenu() --go back to previous screen (play menu)
	playChalk = audio.play( chalkSound )
	composer.gotoScene( "Scenes.play_menu", { time=500, effect="slideRight" } )
end
--listen name of the category 
local function instructions()
	if( selectedBasket.name == "foodBasket" )then
		return "Audio/voice/insert_food.wav"
	elseif( selectedBasket.name == "animalBasket" )then
		return "Audio/voice/get_animals.wav"
	elseif( selectedBasket.name == "vehiclesBasket" )then
		return "Audio/voice/which_are_vehicles.wav"
	elseif( selectedBasket.name == "clothesBasket" )then
		return "Audio/voice/put_clothes.wav"
	elseif( selectedBasket.name == "plantsBasket" )then
		return "Audio/voice/put_plants.wav"
	end
end
--pause menu handler
local modalOptions = { --pause menu configuration
    isModal = true,
    time=350, 
    effect="slideDown",
    params = {}
}
local modalVictory = { --victory menu configuration
    isModal = true,
    time=500, 
    effect="zoomOutInFade",
    params = {}
}
local function pauseMenu() --pause_menu handler (implement configuration above)
	playChalk = audio.play( chalkSound )
	composer.showOverlay( "Scenes.Overlay.pause_menu", modalOptions )
end
--victory overlay handler
local function victory() --victory handler (implement configuration above)
	modalVictory.params.timeSpend = timeSpend --passed the time at the moment of the call to ignore the time that the
											  --overlay last
	modalVictory.params.background = selectedBackground
	composer.showOverlay( "Scenes.Overlay.categorize_1_win", modalVictory )
end
--ask instrutions
local function askInstructions()
	activeVoice(instructions())
end
--timer
local function timeCounter( event )
	timeSpend = timeSpend + 1
	-- Time is tracked in seconds; convert it to minutes and seconds
    local minutes = math.floor( timeSpend / 60 )
    local seconds = timeSpend % 60
    saveTime = string.format( "%02d:%02d", minutes, seconds ) --time format
end
--Main collision function
local function collisionOcurred( event, typeName, boxName ) --Objects collision handler (for inserting in basket)
	local phase = event.phase 		--get the event phase
	local objt1 = event.object1 	--object 1
	local objt2 = event.object2 	--object 2

	local category = boxName --get variable 1 locally (not doing this causes the function not to recognize the variables)
	local name = typeName --get variable 2 locally (not doing this causes the function not to recognize the variables)
	if ( phase == "began" )then
		if(objt1.name == category and objt2.name == name)then
			dropPlay = audio.play( dropSound )
			--transition.from( objt2, { width=50, height=50, time=0 } )
			transition.to( objt2, { width=0, height=0, time=125 } )
			if(objt2.width == 0 or objt2.height == 0)then display.remove( objt2 ) end
			score = score + 1
			if( score == expectedScore )then --victory detector (expecting a score of 25 points)
				victory() --invoque victory() function declared above
			end
			attempted = true
		elseif(objt2.name == category and objt1.name == name)then
			dropPlay = audio.play( dropSound )
			--transition.from( objt1, { width=50, height=50, time=0 } )
			transition.to( objt1, { width=0, height=0, time=125 } )
			if(objt1.width == 0 or objt1.height == 0)then display.remove( objt1 ) end
			score = score + 1
			if( score == expectedScore )then ----victory detector (expecting a score of 25 points)
				victory() --invoque victory() function declared above
			end
			attempted = true
		elseif(objt1.name == category and objt2.name ~= name or 
			objt2.name == category and objt1.name ~= name)then
			playError = audio.play( errorSound )
			attempted = true
		end
	end
	if( phase == "ended" )then --check the objects colliding when the collision ends (removed. not needed)
	end
end
--Handlers for all collision types
local function collisionWithin( event )
	collisionOcurred( event, "animal", "animalBasket" )
	collisionOcurred( event, "food", "foodBasket" )
	collisionOcurred( event, "cloth", "clothesBasket" )
	collisionOcurred( event, "plant", "plantsBasket" )
	collisionOcurred( event, "vehicle", "vehiclesBasket" )
end
-- Activate multitouch (not currently needed)
local function dragItem( event ) --drag: touch detector + collision detector
	local target = event.target
	local id = event.id
	local phase = event.phase

	if (phase == "began")then --transforming positions
		startingTarget = event.target --for overlaping of events prevention 
									--since Solar2d doesn't end the event when
									--switching too fast within targets
		eventTimeStart = event.time
		attempted = false

		sWidth = startingTarget.width --to prevent double collisions when the drag is not release
		sHeight = startingTarget.height

		event.target.alpha = 0.8 --change transparency on touc
		display.getCurrentStage():setFocus(  target, id ) --prevent objects from overlaping
		--calculate difference within event and object axis
		target.touchOffsetX = event.x - target.x
		target.touchOffsetY = event.y - target.y
		--save the initial target position
		defaultX = target.x
		defaultY = target.y
	elseif (phase == "moved") then
		display.getCurrentStage():setFocus(  target, id ) --prevent objects from overlaping
		if(target.touchOffsetX ~= nil and 
			target == startingTarget)then								--"startingTarget" is saved at the 
			target.x = event.x - target.touchOffsetX					--beggining of the function while
			target.y = event.y - target.touchOffsetY	
		else															--the "event.target" can vary due
			display.getCurrentStage():setFocus(  target, nil )			--to conflict with times causing 
		end 															--undesired effects
	elseif (phase == "ended" or phase == "cancelled") then				
		event.target.alpha = 1
		--reset the initial target position
		if(target == startingTarget)then
			eventTimeEnd = event.time - eventTimeStart
    		--local miliseconds = math.floor( eventTimeEnd/100 ) 
    		--print( "ms: " .. miliseconds )
    		local totalSeconds = eventTimeEnd/60000
    		--print( "mod: " .. totalSeconds ) 
    		if(totalSeconds ~= nil)then
    			totalSeconds = tostring(totalSeconds):match("%.(%d+)")
    			totalSeconds = string.sub( totalSeconds, 1, 2 )
    			--print( "decimals: " .. tostring(totalSeconds) ) 
    		end
    		local seconds = math.floor( totalSeconds*0.6 ) 
    		--print( "sec: " .. seconds )
    		local minutes = math.floor( eventTimeEnd/60000 )
    		--print( "min: " .. minutes )
    		eventTimeEnd = string.format( "%02d:%02d", minutes, seconds ) --time format
    		print( eventTimeEnd )
    		globalObject = target.name
    		if(attempted)then
    			globalTarget = selectedBasket["name"]
    		else
    			globalTarget = "(didn't attempted to insert)"
    		end
			local insertActivity = [[ INSERT INTO activity VALUES( NULL, "]]..globalObject..[[", 
			"]]..globalTarget..[[", "]]..date..[[", "]]..eventTimeEnd..[[" ); ]]
			db:exec( insertActivity )
			if( target.width == sWidth
			and target.height == sHeight)then transition.to( target, { x=defaultX, y=defaultY, time=150, delay=50 } ) end
		end						
		display.getCurrentStage():setFocus(  target, nil )
	end
	return true -- Prevents touch propagation to underlying objects
end
--spawn handler
local function spawnRow( group, rowX, rowY )
	options = { foodSheet, animalSheet, clothesSheet, plantsSheet, vehiclesSheet } 

	if( selectedSheets[1] == nil )then
		for i = 1, 2 do
			local sheet = math.random( 1, 5 )
			local sheetName = options[sheet]
			if( table.indexOf( selectedSheets, sheetName ) == nil and mainSheet ~= sheetName )then
				print( "if 1: sheet was not found nor is main sheet" )
				if( mainSheet ~= nil and i < 2 )then
					print( "if 2: mainSheet is not nil and i < 2" )
					table.insert( selectedSheets, mainSheet )
					table.insert( selectedSheets, sheetName )
					break
				else
					print( "else 2: mainSheet is nil or i < 2" )
					if( i == 1 )then mainSheet = sheetName end
					table.insert( selectedSheets, sheetName )
				end
			else
				print( "else 1: sheet was found or is main sheet" )
				if(options[sheet+1] ~= nil)then sheetName = options[sheet+1] end
				if(options[sheet-1] ~= nil)then sheetName = options[sheet-1] end
				table.insert( selectedSheets, sheetName )
				if( mainSheet ~= nil )then
					table.insert( selectedSheets, mainSheet )
					break
				end
			end
			
		end
	end
	local group = group
	local initX = rowX
	local rowY = rowY
	for i = 1, 5 do
		local typeSelector = math.random( 1, 2 )	--random selectors for spawming
		local objectSelector = math.random( 1, 10 )
		--categorizing the objects 
		local frame = display.newImageRect( group, selectedSheets[typeSelector], objectSelector, 50, 50 )
		frame.alpha = 0
		if(selectedSheets[typeSelector] == foodSheet)then		--Assigning names to each element within
			frame.name = "food"							--the loop for categorizing them
			if not( selectedBasket["name"] and mainSheet == foodSheet)then
				selectedBasket = {						--basket partially random selector 
					name = "foodBasket",
					src = "Assets/Food/food-basket.png",
					text = "Food"
				}
			end		
		elseif(selectedSheets[typeSelector] == animalSheet)then
			frame.name = "animal"
			if not( selectedBasket["name"] and mainSheet == animalSheet )then
				selectedBasket = {						--basket partially random selector 
					name = "animalBasket",
					src = "Assets/Animals/animals-basket.png",
					text = "Animals"
				}
			end	
		elseif(selectedSheets[typeSelector] == clothesSheet)then
			frame.name = "cloth"
			if not( selectedBasket["name"] and mainSheet == clothesSheet )then
				selectedBasket = {						--basket partially random selector 
					name = "clothesBasket",
					src = "Assets/Clothes/clothes-basket.png",
					text = "Clothes"
				}
			end
		elseif(selectedSheets[typeSelector] == plantsSheet)then
			frame.name = "plant"
			if not( selectedBasket["name"] and mainSheet == plantsSheet )then
				selectedBasket = {						--basket partially random selector 
					name = "plantsBasket",
					src = "Assets/Plants/plants-basket.png",
					text = "Plants"
				}
			end	
		elseif(selectedSheets[typeSelector] == vehiclesSheet)then
			frame.name = "vehicle"
			if not( selectedBasket["name"] and mainSheet == vehiclesSheet )then
				selectedBasket = {						--basket partially random selector 
					name = "vehiclesBasket",
					src = "Assets/Vehicles/vehicles-basket.png",
					text = "Vehicles"
				}
			end
		end
		frame.x = initX 
		frame.y = rowY
		frame.isBullet = true
		physics.addBody( frame, "dynamic", { radius=50, isSensor=true } )
		frame:addEventListener( "touch", dragItem )
		--handling frame transition
		transition.to( frame, { alpha=1, time=300 } )
		--aligning in "x" axis
		initX = initX + 60
	end		
end
local function respawn( group ) --for repawming elements 
	playRewind = audio.play( rewindSound )
	selectedSheets = {}
	mainSheet = nil

	local group = group
	local elem_amount = group.numChildren

	for i = 1, elem_amount do --need double iteration to completely clean the elements from the screen 
		for i = 1, elem_amount do
			group:remove( i )
		end
	end
	--respawn the rows
	spawnRow( group, 35, 110 ) 
	spawnRow( group, 35, 185 ) 
	spawnRow( group, 35, 260 ) 
	--redisplay text-box
	local textBox = display.newImageRect( group, "Assets/Background/text-box.png", 200, 100 )
	textBox.x = 475
	textBox.y = 100
	--redisplay text
	local textCategory = display.newText( group, selectedBasket["text"], 475, 110, "Fonts/FORTE.TTF", 35 )
	textCategory.font = native.newFont( "Fonts.FORTE", 16 )
	textCategory:setTextColor( 1, 0.85, 0.31  )
	--redisplay the basket
	local basket = display.newImageRect( group, selectedBasket["src"], 200, 100 )
	basket.name = selectedBasket["name"]
	basket.x = 475
	basket.y = 260
	physics.addBody( basket, "static", { radius=0.8, outline=box_outline } ) --physics box
	--print( json.prettify( selectedBasket ) )
	activeVoice(instructions())
end
-----------------------------------------
-- Scene Handling
-----------------------------------------
local backgroundSet = { "Assets/Background/kinder.png", "Assets/Background/kitchen.png", "Assets/Background/jungle.png",
"Assets/Background/living.png", "Assets/Background/bedroom.png", } --random background list for random selection
--create()
function scene:create( event )
	currentTime = timer.performWithDelay( 1000, timeCounter, timeSpend )
	date = os.date( "%m/%d/%Y" ) 
	local sceneGroup = self.view 		--scene view
	local physics = require( "physics" ) --implementing physics
	physics.start()
	physics.setGravity( 0,0 )
	local backGroup = display.newGroup() -- background elements group
	sceneGroup:insert( backGroup ) 
	local mainGroup = display.newGroup() -- game objects group
	sceneGroup:insert( mainGroup ) 
	local categoriesGroup = display.newGroup() --for spawm objects
	sceneGroup:insert( categoriesGroup )
	local uiGroup = display.newGroup() 	-- UI elements group
	sceneGroup:insert( uiGroup ) 


	local selectedBg = math.random( 1,5 )
	selectedBackground = backgroundSet[selectedBg]
	background = display.newImageRect( backGroup, selectedBackground, 700, 375 ) --background
	--applying blur to background
	background.fill.effect = 'filter.blurGaussian'
	background.fill.effect.horizontal.blurSize = 10
	background.fill.effect.horizontal.sigma = 150
	background.fill.effect.vertical.blurSize = 10
	background.fill.effect.vertical.sigma = 150
	
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	--Score Text
	scoreText = display.newText( uiGroup, "", display.contentCenterX, 20, native.systemFont, 15 )
	scoreText:setFillColor( 0,0,0 )	
	--Back Button
	backButton = display.newImageRect( uiGroup, "Assets/Buttons/back.png", 50, 25 ) --go back button
	backButton.x = 0
	backButton.y = 16

	local secondBoard = display.newImageRect( mainGroup, "Assets/Background/board-2.png", 515, 325 )
	secondBoard.x = 160
	secondBoard.y = 200

	-- transition.from( secondBoard, { y=400 } )
	-- transition.to( secondBoard, { y=200 } )

	local basketBoard = display.newImageRect( mainGroup, "Assets/Background/board-2.png", 250, 150 )
	basketBoard.x = 475
	basketBoard.y = 260

	local textBox = display.newImageRect( categoriesGroup, "Assets/Background/text-box.png", 200, 100 )
	textBox.x = 475
	textBox.y = 100

	spawnRow( categoriesGroup, 35, 110 )
	spawnRow( categoriesGroup, 35, 185 )
	spawnRow( categoriesGroup, 35, 260 )

	-- transition.from( textCategory, { alpha=0, size=0 } )
	-- transition.to( textCategory, { alpha=1, size=35, time=500 } )

	local function respawnRow( event )
		respawn( categoriesGroup )
	end

	local textCategory = display.newText( categoriesGroup, selectedBasket["text"], 475, 110, "Fonts/FORTE.TTF", 35 )
	textCategory.font = native.newFont( "Fonts.FORTE", 16 )
	textCategory:setTextColor( 1, 0.85, 0.31  )

	local basket = display.newImageRect( categoriesGroup, selectedBasket["src"], 200, 100 )
	basket.name = selectedBasket["name"]
	basket.x = 475
	basket.y = 260
	physics.addBody( basket, "static", { radius=0.8, outline=box_outline } ) --physics box

	transition.from( basket, { height=200, width=20, alpha=0, delay=700 } )
	transition.to( basket, { height=100, width=200, alpha=1, time=600, delay=650 } )

	local respawnButton = display.newImageRect( uiGroup, "Assets/Buttons/respawn.png", 50, 25 )
	respawnButton.x = 545
	respawnButton.y = 16

	local questionButton = display.newImageRect( uiGroup, "Assets/Buttons/question.png", 65, 33 )
	questionButton.x = 475
	questionButton.y = 73

	questionButton:addEventListener( "tap", askInstructions )
	respawnButton:addEventListener( "tap", respawnRow )
	Runtime:addEventListener( "collision", collisionWithin )
	backButton:addEventListener( "tap", pauseMenu )
end
--show()
function scene:show( event )
	local phase = event.phase

	if(phase == "will")then
		--DB implementation when scene is gonna show
		local testing = [[ DROP TABLE IF EXISTS scores; ]] --WARNING!! Disable on production. Will drop the table on scene refresh
		local testing2 = [[ DROP TABLE IF EXISTS activity; ]]
		local createTable = [[
		CREATE TABLE IF NOT EXISTS scores (
		id INTEGER PRIMARY KEY, 
		score INTEGER NOT NULL,
		time_spend VARCHAR(10) NOT NULL,
		_date VARCHAR(15) NOT NULL);
		]] --query
		local createActivity = [[
		CREATE TABLE IF NOT EXISTS activity(
		id INTEGER PRIMARY KEY,
		_object VARCHAR(50) NOT NULL,
		_target VARCHAR(50) NOT NULL,
		_date VARCHAR(15) NOT NULL,
		_time VARCHAR(15) NOT NULL);
		]]
		db:exec( testing ) 		--DISABLE!!
		db:exec( createTable )	--executing table creation query
		db:exec( testing2 )
		db:exec( createActivity )
	elseif(phase == "did")then	
		activeVoice( instructions() )	
	end
end
--relaunch()
function scene:reLaunch( event ) --to keep timer continuity
 timeSpend = modalVictory.params.timeSpend
end
--hide()
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "will") then
		timer.cancel( currentTime ) --stop time counter
	elseif (phase == "did") then
		print( "level 1 hiden" )
		--inserting into DB 
		if( saveTime ~= nil)then
			local insertToDb = [[INSERT INTO scores VALUES ( NULL, "]]..score..[[", "]]..saveTime..[[", "]]..date..[[" );]]
			db:exec( insertToDb )
			-- for row in db:nrows("SELECT * FROM scores") do -- testing DB output
			--     print( "row id: "..row.id )
			--     print( "score: "..row.score )
			--     print( "total time: "..row.time_spend )
			--     print( "date: "..row._date )
			-- end
		end
		--deleting audio files
		if (dropPlay ~= nil)then audio.stop( dropPlay ) end
		if (playRewind ~= nil)then audio.stop( playRewind ) end
		if (playChalk ~= nil)then audio.stop( playChalk ) end
		if (playError ~= nil)then audio.stop( playError ) end
		playError = nil
		dropPlay = nil
		playRewind = nil
		playChalk = nil
	db:close() --close DB
	physics.stop() -- stopping physics when scene stops
	Runtime:removeEventListener( "tap", gotoPlayMenu ) 	--Go Back button listener
	Runtime:removeEventListener( "collision", collisionWithin ) -- Remove collision event listener
	composer.removeScene( "GameMode.free" )		--Remove scene when scene goes away
	end
end
function scene:destroy( event )
end
scene:addEventListener( "create", scene ) --Create scene listener
scene:addEventListener( "destroy", scene ) --Destroy scene listener
scene:addEventListener( "show", scene ) --Show scene listener
scene:addEventListener( "hide", scene )	--Hide scene listener
return scene