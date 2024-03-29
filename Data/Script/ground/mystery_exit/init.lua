--[[
    init.lua
    Created: 04/16/2021 09:19:28
    Description: Autogenerated script file for the map mystery_exit.
]]--
-- Commonly included lua functions and data
require 'common'

-- Package name
local mystery_exit = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---mystery_exit.Init
--Engine callback function
function mystery_exit.Init(map)

  --This will fill the localized strings table automatically based on the locale the game is 
  -- currently in. You can use the MapStrings table after this line!
  MapStrings = COMMON.AutoLoadLocalizedStrings()

  COMMON.RespawnPartner(false)
end

---mystery_exit.Enter
--Engine callback function
function mystery_exit.Enter(map)

  mystery_exit.Cutscene()
  
end

---mystery_exit.Exit
--Engine callback function
function mystery_exit.Exit(map)


end

---mystery_exit.Update
--Engine callback function
function mystery_exit.Update(map)


end


function mystery_exit.Cutscene()
  GAME:CutsceneMode(true)
  
  GAME:MoveCamera(272, 562, 1, false)
  GAME:FadeIn(20)
  
  local player = CH('PLAYER')
  local partner = CH('Partner')
  
  local coro1 = TASK:BranchCoroutine(function() mystery_exit.Concurrent_Sequence() end)
  GROUND:MoveInDirection(partner, Direction.Up, 80, false, 2)
  
  TASK:JoinCoroutines({coro1})
  
  
  if player.Data.BaseForm.Species == "ditto" then
  
    UI:SetSpeaker(player)
    UI:WaitShowDialogue("We've come a long way down...[pause=0] or is it up?")
    UI:WaitShowDialogue("Lumiere,[pause=30] I don't know when we'll get out of here...")
    UI:WaitShowDialogue("But one thing's for sure,[pause=30] we will always...")
  
    SOUND:FadeOutBGM()
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue("Shhh, there's someone ahead!")
  
  else
    
    UI:SetSpeaker(player)
    UI:WaitShowDialogue("We've come a long way down...[pause=0] are you sure we're going the right way?")
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue("Well,[pause=30] I don't know when we'll get out of here...")
    UI:WaitShowDialogue("But one thing's for sure,[pause=30] we will always...")
	
    SOUND:FadeOutBGM()
    UI:SetSpeaker(player)
    UI:WaitShowDialogue("Shhh, there's someone ahead!")
  end
  
  
  
  local coro1 = TASK:BranchCoroutine(function() mystery_exit.Hide_Sequence(player) end)
  mystery_exit.Hide_Sequence(partner)
  
  TASK:JoinCoroutines({coro1})
  
  UI:ResetSpeaker()
  
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['KEKEKE']))
  
  GAME:MoveCamera(272, 200, 60, false)
  
  SOUND:PlayBGM("Mystery Dungeon.ogg", false)
  
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['KEKEKE_2']))
  GAME:WaitFrames(20)
  local zorua = CH('Zorua')
  GROUND:CharSetAnim(zorua, "Shoot", false)
  
  GAME:WaitFrames(20);
  
  SOUND:PlayBattleSE("EVT_Fade_White")
  GAME:FadeOut(true, 80)
  
  SV.complete = true
  GAME:EnterGroundMap("grove_exit", "entrance", true)
end



function mystery_exit.Concurrent_Sequence()
  
  local player = CH('PLAYER')
  GROUND:MoveInDirection(player, Direction.Up, 80, false, 2)
  
  local turnTime = 4
  GROUND:CharAnimateTurnTo(player, Direction.Down, turnTime)
end

function mystery_exit.Hide_Sequence(chara)
  
  GROUND:MoveInDirection(chara, Direction.UpLeft, 32, false, 2)
  
  local turnTime = 4
  GROUND:CharAnimateTurnTo(chara, Direction.UpRight, turnTime)
end

-------------------------------
-- Entities Callbacks
-------------------------------


return mystery_exit

