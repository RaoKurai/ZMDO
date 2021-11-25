--[[
    init.lua
    Created: 04/16/2021 09:20:25
    Description: Autogenerated script file for the map melumi_house.
]]--
-- Commonly included lua functions and data
require 'common'

-- Package name
local melumi_house = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---melumi_house.Init
--Engine callback function
function melumi_house.Init(map)

  --This will fill the localized strings table automatically based on the locale the game is 
  -- currently in. You can use the MapStrings table after this line!
  MapStrings = COMMON.AutoLoadLocalizedStrings()

  COMMON.RespawnPartner(false)
end

---melumi_house.Enter
--Engine callback function
function melumi_house.Enter(map)

  SV.checkpoint = 
  {
    Zone    = 1, Segment  = -1,
    Map  = 7, Entry  = 0
  }
  

	local totalDex = _DATA.Save:GetTotalMonsterUnlock(RogueEssence.Data.GameProgress.UnlockState.Completed)
	if _DATA.Save:GetMonsterUnlock(132) == RogueEssence.Data.GameProgress.UnlockState.Completed then
		totalDex = totalDex - 1
	end
	if _DATA.Save:GetMonsterUnlock(235) == RogueEssence.Data.GameProgress.UnlockState.Completed then
		totalDex = totalDex - 1
	end
	
  if totalDex >= 15 and SV.charvars.LumiereMoves >= 15 then
    GROUND:Unhide("Paper")
  end
  GAME:FadeIn(30)
  
end

---melumi_house.Exit
--Engine callback function
function melumi_house.Exit(map)


end

---melumi_house.Update
--Engine callback function
function melumi_house.Update(map)


end

-------------------------------
-- Entities Callbacks
-------------------------------

function melumi_house.Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local dungeon_entrances = { 2, 3, 4 }
  local ground_entrances = { }
  COMMON.ShowDestinationMenu(dungeon_entrances,ground_entrances)
end

function melumi_house.Storage_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON:ShowTeamStorageMenu()
end


  
function melumi_house.Paper_Action(obj, activator)
  GAME:FadeOut(false, 30)
  UI:WaitShowBG("ThankYou", 1, 10);
  UI:WaitInput(true);
  UI:WaitHideBG(30);
  GAME:FadeIn(10)
end

function melumi_house.Partner_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:SetSpeaker(chara)
  local phrases = { }
  if chara.Data.BaseForm.Species == 132 then
    table.insert(phrases, "If you ever want to visit the Mystery Dungeons again, we can go together!")
    table.insert(phrases, "I wonder what Kazure is up to...[pause=0] It's gotta be something big.")
    table.insert(phrases, "There's going to be a special festival this year.[pause=0] The hundredth anniversary!")
    table.insert(phrases, "I can't wait to show you what the city's like!")
    table.insert(phrases, "It's good to be home...")
  else
    table.insert(phrases, "If you ever want to visit the Mystery Dungeons again, I have your back!")
    table.insert(phrases, "I can't wait to see what the city is like!")
    table.insert(phrases, "Boy is it nice to finally have a place to rest.")
    table.insert(phrases, "I wonder what kinds of Mystery Aspects I'll see here...")
  end
  
  local chosen_idx = math.random(1, #phrases)
  local chosen_phrase = phrases[chosen_idx]
  UI:WaitShowDialogue(chosen_phrase)
end

return melumi_house
