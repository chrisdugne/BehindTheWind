-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

scene = {} 

-----------------------------------------------------------------------------------------

function initGameData()

	GLOBALS.savedData = {
		user = "New player",
		fullGame = GLOBALS.savedData ~= nil and GLOBALS.savedData.fullGame,
		requireTutorial = true,
		levels = {{available = true}}, 
		scores = {
			classic={},
		}
	}

	utils.saveTable(GLOBALS.savedData, "savedData.json")
end

-----------------------------------------------------------------------------------------

function init(view)

	---------------------------------------

	if(view) then
		scene = view
	end

	----------------------------------------

end

-----------------------------------------------------------------------------------------
