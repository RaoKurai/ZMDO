--[[
    init.lua
    Created: 04/16/2021 19:01:56
    Description: Autogenerated script file for the map title.
]]--
-- Commonly included lua functions and data
require 'common'

-- Package name
local title = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---title.Init
--Engine callback function
function title.Init(map)

  --This will fill the localized strings table automatically based on the locale the game is 
  -- currently in. You can use the MapStrings table after this line!
  MapStrings = COMMON:AutoLoadLocalizedStrings()

end

---title.Enter
--Engine callback function
function title.Enter(map)

  GAME:WaitFrames(60);
  GAME:FadeIn(60)
  
  GAME:WaitFrames(120);
  
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue("Thank you for playing!")
  GAME:WaitFrames(60);
  GAME:FadeOut(false, 60)
  SOUND:FadeOutBGM()
  
  GAME:WaitFrames(240);

  GAME:EnterGroundMap("melumi_house", "entrance")
end

---title.Exit
--Engine callback function
function title.Exit(map)


end

---title.Update
--Engine callback function
function title.Update(map)


end

-------------------------------
-- Entities Callbacks
-------------------------------


return title

