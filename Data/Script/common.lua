--[[
    common.lua
    A collection of frequently used functions and values!
]]--
require 'common_gen'

----------------------------------------
-- Debugging
----------------------------------------
DEBUG = 
{
  EnableDbgCoro = function() end, --Call this function inside coroutines you want to allow debugging of, at the start. Default is empty
  --FIXME: fix mobdebug and sockets
  IsDevMode = function() return false end, --RogueEssence.DiagManager.Instance.DevMode end,
  GroundAIShowDebugInfo = false,
}

DEBUG.GroundAIShowDebugInfo = false--DEBUG.IsDevMode()

--Disable debugging for non devs
if DEBUG.IsDevMode() then
  ___mobdebug = require('mobdebug')
  ___mobdebug.coro() --Enable coroutine debugging
  ___mobdebug.checkcount = 1 --Increase debugger update frequency
  ___mobdebug.verbose=true --Enable debugger verbose mode
  ___mobdebug.start() --Enable debugging
  DEBUG.EnableDbgCoro = function() require('mobdebug').on() end --Set the content of the function to this in dev mode, so it does something
end


----------------------------------------
-- Lib Definitions
----------------------------------------
--Reserve the "class" symbol for instantiating classes
Class    = require 'lib.middleclass'
--Reserve the "Mediator" symbol for instantiating the message lib class
Mediator = require 'lib.mediator' 
--Reserve the "Serpent" symbol for the serializer
Serpent = require 'lib.serpent'

----------------------------------------------------------
-- Console Writing
----------------------------------------------------------

--Prints to console!
function PrintInfo(text)
  if DiagManager then 
    DiagManager.Instance:LogInfo( '[SE]:' .. text) 
  else
    print('[SE]:' .. text)
  end
end

--Prints to console!
function PrintError(text)
  if DiagManager then 
    DiagManager.Instance:LogInfo( '[SE]:' .. text) 
  else
    print('[SE](ERROR): ' .. text)
  end
end

--Will print the stack and the specified error message
function PrintStack(err)
  PrintInfo(debug.traceback(tostring(err),2)) 
end

function PrintSVAndStrings(mapstr)
  print("DUMPING SCRIPT VARIABLE STATE..")
  print(Serpent.block(SV))
  print(Serpent.block(mapstr))
  print("-------------------------------")
end

----------------------------------------
-- Common namespace
----------------------------------------
COMMON = {}

--Automatically load the appropriate localization for the specified package, or defaults to english!
function COMMON.AutoLoadLocalizedStrings()
  PrintInfo("AutoLoading Strings!..")
  --Get the package path
  local packagepath = SCRIPT:CurrentScriptDir()
  
  --After we made the path, load the file
  return STRINGS:MakePackageStringTable(packagepath)
end

COMMON.MISSION_TYPE_RESCUE = 0
COMMON.MISSION_TYPE_ESCORT = 1
COMMON.MISSION_TYPE_OUTLAW = 2

COMMON.MISSION_INCOMPLETE = 0
COMMON.MISSION_COMPLETE = 1

COMMON.PERSONALITY = { }
COMMON.PERSONALITY[0] = { -- partner
  FULL = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},
  HALF = {0, 1, 2},
  PINCH = {0, 1, 2},
  WAIT = {0, 1, 2, 3}
}
COMMON.PERSONALITY[1] = { -- confident
  FULL = {20, 21, 22, 23, 24, 25, 26},
  HALF = {5, 6, 7},
  PINCH = {5, 6, 7},
  WAIT = {5, 6, 7}
}
COMMON.PERSONALITY[2] = { -- nervous
  FULL = {40, 41, 42, 43, 44, 45, 46, 47, 48, 49},
  HALF = {10, 11, 12, 13},
  PINCH = {10, 11, 12},
  WAIT = {10, 11, 12}
}
COMMON.PERSONALITY[3] = { -- cautious
  FULL = {60, 61, 62, 63, 64, 65, 66},
  HALF = {15, 16, 17},
  PINCH = {15, 16, 17},
  WAIT = {15, 16, 17}
}
COMMON.PERSONALITY[4] = { -- musing
  FULL = {80, 81, 82, 83, 84, 85, 86},
  HALF = {20, 21, 22, 23},
  PINCH = {20, 21, 22},
  WAIT = {20, 21, 22}
}
COMMON.PERSONALITY[5] = { -- legend
  FULL = {100, 101, 102, 103, 104},
  HALF = {25, 26, 27},
  PINCH = {25, 26, 27},
  WAIT = {25, 26}
}
COMMON.PERSONALITY[6] = { -- robot
  FULL = {120, 121, 122, 123, 124, 125, 126},
  HALF = {30, 31, 32},
  PINCH = {30, 31, 32},
  WAIT = {30, 31, 32}
}
COMMON.PERSONALITY[7] = { -- jock
  FULL = {140, 141, 142, 143, 144, 145, 146, 147},
  HALF = {35, 36, 37},
  PINCH = {35, 36, 37},
  WAIT = {35, 36, 37}
}
COMMON.PERSONALITY[8] = { -- child
  FULL = {160, 161, 162, 163, 142, 144},
  HALF = {40, 41, 42},
  PINCH = {40, 41, 42},
  WAIT = {40, 41, 42}
}
COMMON.PERSONALITY[9] = { -- selfless
  FULL = {180, 181, 182, 183, 184, 2, 6, 10},
  HALF = {45, 46, 47},
  PINCH = {45, 46, 47},
  WAIT = {45, 46, 47, 0, 3}
}
COMMON.PERSONALITY[10] = { -- reckless
  FULL = {200, 201, 202, 203, 204, 205, 206},
  HALF = {50, 51, 52},
  PINCH = {50, 51, 52},
  WAIT = {50, 51, 52}
}
COMMON.PERSONALITY[11] = { -- lazy
  FULL = {220, 221, 222, 223, 224, 225, 226, 227, 228},
  HALF = {55, 56, 57},
  PINCH = {55, 56, 57},
  WAIT = {55, 56, 57, 58}
}
COMMON.PERSONALITY[12] = { -- loud
  FULL = {240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252},
  HALF = {60, 61, 62},
  PINCH = {60, 61, 62},
  WAIT = {60, 61, 62, 63}
}
COMMON.PERSONALITY[13] = { -- snooty
  FULL = {260, 261, 262, 263, 264, 265, 266, 267, 268},
  HALF = {65, 66, 67},
  PINCH = {65, 66, 67},
  WAIT = {65, 66, 67}
}
COMMON.PERSONALITY[14] = { -- hyped
  FULL = {280, 281, 282, 283, 284, 285, 261, 266},
  HALF = {70, 71, 72},
  PINCH = {70, 71, 72},
  WAIT = {70, 71, 72}
}
COMMON.PERSONALITY[15] = { -- reserved
  FULL = {300, 301, 302, 303, 304, 305, 22},
  HALF = {75, 76, 77},
  PINCH = {75, 76, 77},
  WAIT = {75, 76, 77}
}
COMMON.PERSONALITY[16] = { -- greedy
  FULL = {320, 321, 322, 323, 324, 325, 326, 327},
  HALF = {80, 81, 82},
  PINCH = {80, 81, 82},
  WAIT = {80, 81, 82}
}
COMMON.PERSONALITY[24] = { -- baby / manaphy
  FULL = {640, 641, 642, 643, 644, 645, 646, 647, 648},
  HALF = {135, 136, 137, 138, 139},
  PINCH = {135, 136, 137, 138, 139},
  WAIT = {135, 136, 137, 138, 139}
}
COMMON.PERSONALITY[26] = { -- formal
  FULL = {680, 681, 682, 683, 684, 685, 686, 687},
  HALF = {145, 146, 147, 148, 149},
  PINCH = {145, 146, 147, 148, 149},
  WAIT = {145, 146, 147, 148, 149}
}
COMMON.PERSONALITY[29] = { -- knight
  FULL = {740, 741, 742, 743, 744, 745},
  HALF = {160, 161, 162, 163},
  PINCH = {160, 161, 162, 163},
  WAIT = {150, 151, 152, 153}
}
COMMON.PERSONALITY[30] = { -- teenager
  FULL = {750, 751, 752, 753, 754, 755},
  HALF = {165, 166, 167, 168},
  PINCH = {165, 166, 167, 168},
  WAIT = {155, 156, 157, 158}
}
COMMON.PERSONALITY[31] = { -- normal
  FULL = {760, 761, 762, 763, 764, 765},
  HALF = {170, 171, 172, 173},
  PINCH = {170, 171, 172, 173},
  WAIT = {160, 161, 162, 163}
}
COMMON.PERSONALITY[32] = { -- dialga
  FULL = {770, 771, 772, 773, 774, 775},
  HALF = {175, 176, 177, 178},
  PINCH = {175, 176, 177, 178},
  WAIT = {165, 166, 167, 168}
}
COMMON.PERSONALITY[33] = { -- palkia
  FULL = {780, 781, 782, 783, 784, 785},
  HALF = {180, 181, 182, 183},
  PINCH = {180, 181, 182, 183},
  WAIT = {170, 171, 172, 173}
}
COMMON.PERSONALITY[34] = { -- regigigas
  FULL = {790, 791, 792, 793, 794, 795},
  HALF = {185, 186, 187, 188},
  PINCH = {185, 186, 187, 188},
  WAIT = {175, 176, 177, 178}
}
COMMON.PERSONALITY[35] = { -- darkrai
  FULL = {800, 801, 802, 803, 804, 805},
  HALF = {190, 191, 192, 193},
  PINCH = {190, 191, 192, 193},
  WAIT = {180, 181, 182, 183}
}
COMMON.PERSONALITY[36] = { -- shopkeeper
  FULL = {810, 811, 812, 813, 814, 815},
  HALF = {195, 196, 197, 198},
  PINCH = {195, 196, 197, 198},
  WAIT = {185, 186, 187, 188}
}
COMMON.PERSONALITY[37] = { -- escort
  FULL = {820},
  HALF = {200},
  PINCH = {200},
  WAIT = {190}
}


----------------------------------------------------------
-- Convenience Scription Functions
----------------------------------------------------------
function COMMON.RespawnAllies()
  GROUND:RefreshPlayer()
  

  local party = GAME:GetPlayerPartyTable()
  local playeridx = GAME:GetTeamLeaderIndex()

  --Place player teammates
  for i = 1,3,1
  do
    GROUND:RemoveCharacter("Teammate" .. tostring(i))
  end
  local total = 1
  for i,p in ipairs(party) do
    if i ~= (playeridx + 1) then --Indices in lua tables begin at 1
      GROUND:SpawnerSetSpawn("TEAMMATE_" .. tostring(total),p)
      local chara = GROUND:SpawnerDoSpawn("TEAMMATE_" .. tostring(total))
      --GROUND:GiveCharIdleChatter(chara)
      total = total + 1
    end
  end
end

function COMMON.RespawnPartner(follower)
  GROUND:RefreshPlayer()
  
  --Place player partner
  GROUND:RemoveCharacter("Partner")
  local playeridx = GAME:GetTeamLeaderIndex()
  local partneridx = 0
  if playeridx == 0 then
    partneridx = 1
  end
  local partner = _DATA.Save.ActiveTeam.Players[partneridx]
  GROUND:SpawnerSetSpawn("PARTNER_SPAWN", partner)
  local chara = GROUND:SpawnerDoSpawn("PARTNER_SPAWN")
  
  if follower == true then
    AI:SetCharacterAI(chara, "ai.ground_partner", CH('PLAYER'), chara.Position)
    chara.CollisionDisabled = true
  end
end

function COMMON.ShowTeamAssemblyMenu(obj, init_fun)
  SOUND:PlaySE("Menu/Skip")
  UI:AssemblyMenu()
  UI:WaitForChoice()
  result = UI:ChoiceResult()
  if result then
    GAME:WaitFrames(10)
	SOUND:PlayBattleSE("EVT_Assembly_Bell")
	GROUND:ObjectSetAnim(obj, 6, -1, -1, RogueElements.Dir8.Down, 3)
	GAME:FadeOut(false, 20)
	init_fun()
    GAME:FadeIn(20)
  end
end

function COMMON.ShowDestinationMenu(dungeon_entrances, ground_entrances)
  
  --check for unlock of dungeons
  local open_dests = {}
  for ii = 1,#dungeon_entrances,1 do
    if GAME:DungeonUnlocked(dungeon_entrances[ii]) then
	  local zone_summary = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(dungeon_entrances[ii])
	  local zone_name = zone_summary:GetColoredName()
      table.insert(open_dests, { Name=zone_name, Dest=RogueEssence.Dungeon.ZoneLoc(dungeon_entrances[ii], 0, 0, 0) })
	end
  end
  
  --check for unlock of grounds
  for ii = 1,#ground_entrances,1 do
    if ground_entrances[ii].Flag then
	  local ground_id = ground_entrances[ii].Zone
	  local zone = _DATA:GetZone(ground_id)
	  local ground = _DATA:GetGround(zone.GroundMaps[ground_entrances[ii].ID])
	  local ground_name = ground:GetColoredName()
      table.insert(open_dests, { Name=ground_name, Dest=RogueEssence.Dungeon.ZoneLoc(ground_id, -1, ground_entrances[ii].ID, ground_entrances[ii].Entry) })
	end
  end
  
  local dest = RogueEssence.Dungeon.ZoneLoc.Invalid
  if #open_dests == 1 then
    if open_dests[1].Dest.StructID.Segment < 0 then
	  --single ground entry
      UI:ResetSpeaker()
      
	  UI:ChoiceMenuYesNo(STRINGS:FormatKey("DLG_ASK_ENTER_GROUND", open_dests[1].Name))
      UI:WaitForChoice()
      if UI:ChoiceResult() then
	    dest = open_dests[1].Dest
	  end
	else
	  --single dungeon entry
      UI:ResetSpeaker()
      SOUND:PlaySE("Menu/Skip")
	  UI:DungeonChoice(open_dests[1].Name, open_dests[1].Dest)
      UI:WaitForChoice()
      if UI:ChoiceResult() then
	    dest = open_dests[1].Dest
	  end
	end
  elseif #open_dests > 1 then
    
    UI:ResetSpeaker()
    SOUND:PlaySE("Menu/Skip")
    UI:DestinationMenu(open_dests)
	UI:WaitForChoice()
	dest = UI:ChoiceResult()
  end
  
  if dest:IsValid() then
    SOUND:PlayBGM("", true)
    GAME:FadeOut(false, 20)
	if dest.StructID.Segment > -1 then
	  GAME:EnterDungeon(dest.ID, dest.StructID.Segment, dest.StructID.ID, dest.EntryPoint, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
	else
	  GAME:EnterZone(dest.ID, dest.StructID.Segment, dest.StructID.ID, dest.EntryPoint)
	end
  end
end

function COMMON.UnlockWithFanfare(dungeon_id)
  if not GAME:DungeonUnlocked(dungeon_id) then
    UI:WaitShowDialogue(STRINGS:FormatKey("DLG_NEW_AREA_TO"))
    GAME:UnlockDungeon(dungeon_id)
	local zone = RogueEssence.Data.DataManager.Instance.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(dungeon_id)
    SOUND:PlayFanfare("Fanfare/NewArea")
    UI:WaitShowDialogue(STRINGS:FormatKey("DLG_NEW_AREA", zone:GetColoredName()))
  end

end


function COMMON.FindNpcWithTable(foes, key, value)
  local team_list = _ZONE.CurrentMap.AllyTeams
  if foes then
    team_list = _ZONE.CurrentMap.MapTeams
  end
  local team_count = team_list.Count
  for team_idx = 0, team_count-1, 1 do
	-- search for a wild mon with the table value
	local player_count = team_list[team_idx].Players.Count
	for player_idx = 0, player_count-1, 1 do
	  player = team_list[team_idx].Players[player_idx]
	  local player_tbl = LTBL(player)
	  if player_tbl[key] == value then
		return player
	  end
	end
  end
  return nil
end

function COMMON.CanTalk(chara)
  if chara:GetStatusEffect("sleep") ~= nil then
    return false
  end
  if chara:GetStatusEffect("freeze") ~= nil then
    return false
  end
  if chara:GetStatusEffect("confuse") ~= nil then
    return false
  end
  return true
end


function COMMON.DungeonInteract(chara, target, action_cancel, turn_cancel)
  action_cancel.Cancel = true
  turn_cancel.Cancel = true
  
  local action_res = RogueEssence.Dungeon.ActionResult()
  if COMMON.CanTalk(target) then
    local tbl = target.LuaDataTable
	if target.BaseForm.Species == "ditto" then
		DUNGEON:CharTurnToChar(target, chara)
		
		local mon = _DATA:GetMonster(chara.CurrentForm.Species)
		local phrases = { "Let's do our best, Lumiere!",
		"I'll copy all the Pokémon, and give form to your colors, Lumiere!",
		"We'll always be together, okay?",
		"I'll protect you, Lumiere!",
		"Take your time, Lumiere, go at your own pace.",
		"Tired of being a "..mon.Name:ToLocal().."?[pause=0] I can fix that!",
		"Got any sketches to show me?"
		}
		
		if target.CurrentForm.Species == "eevee" then
			table.insert(phrases, "I wonder what I'll evolve into...?[pause=0] Jolteon?[pause=20] Flareon?[pause=20] Lumineon?[pause=20] Empoleon?")
		elseif target.CurrentForm.Species == "piplup" then
			table.insert(phrases, "Ah, how nostalgic...")
		elseif target.CurrentForm.Species == "pichu" then
			table.insert(phrases, "Surprise![pause=0] A blast from the past!")
		elseif target.CurrentForm.Species == "togetic" then
			table.insert(phrases, "Let me spread joy to you!")
		elseif target.CurrentForm.Species == "mareep" then
			table.insert(phrases, "There's someone in Pe'Kemon city that looks like this![pause=0] Except...[pause=30] airier.")
		elseif target.CurrentForm.Species == "pachirisu" then
			table.insert(phrases, "Wanna cuddle?[pause=0] My nuzzles are extra tingly!")
		elseif target.CurrentForm.Species == "plusle" and chara.CurrentForm.Species == "minun" then
			table.insert(phrases, "Hey look, we match now!")
		elseif target.CurrentForm.Species == "minun" and chara.CurrentForm.Species == "plusle" then
			table.insert(phrases, "Hey look, we match now!")
		elseif target.CurrentForm.Species == "buneary" then
			table.insert(phrases, "I may be a Buneary for this moment, but I will always be YOUR bun!")
		elseif target.CurrentForm.Species == "vaporeon" then
			table.insert(phrases, "Now that I'm a Vaporeon, I can liquefy myself![pause=30] Wait...")
		elseif target.CurrentForm.Species == "jolteon" then
			table.insert(phrases, "Wow, I feel twitchy!")
		elseif target.CurrentForm.Species == "flareon" then
			table.insert(phrases, "This form sure is stuffy.[pause=0] My mane traps all the heat!")
		elseif target.CurrentForm.Species == "espeon" then
			table.insert(phrases, "You lyke thys form, ya?")
		elseif target.CurrentForm.Species == "umbreon" then
			table.insert(phrases, "I'll be your glowbun this time!")
		elseif target.CurrentForm.Species == "sylveon" then
			table.insert(phrases, "Join your hand with my feeler,[pause=0] and we'll join our hearts~")
		elseif target.CurrentForm.Species == "porygon" then
			table.insert(phrases, "Beep boop.[pause=0] Today's a good day to code.")
		elseif target.CurrentForm.Species == "shedinja" then
			table.insert(phrases, "I will be your (Wonder) Guard.")
		elseif target.CurrentForm.Species == "charizard" then
			table.insert(phrases, "Rawr![pause=30] Imma dragon*!")
		elseif target.CurrentForm.Species == "flygon" then
			table.insert(phrases, "Ah, how I love this form...")
		elseif target.CurrentForm.Species == "altaria" then
			table.insert(phrases, "I feel soft, light as a cloud!")
		elseif target.CurrentForm.Species == "tyranitar" then
			table.insert(phrases, "No one's gonna mess with us now!")
		elseif target.CurrentForm.Species == "drifloon" then
			table.insert(phrases, "...FLOON!")
		elseif target.CurrentForm.Species == "lucario" then
			table.insert(phrases, "I'm sensing Pokémon everywhere!")
		elseif target.CurrentForm.Species == "dragonite" then
			table.insert(phrases, "This big dragon is friendly!")
		end
		
		local species = false
		if #phrases == 7 then
			species = true
		end
		
		if _ZONE.CurrentZoneID == 39 then
		    table.insert(phrases, "My cells are mysteriosity incarnate![pause=0] Every time I attack the air, I'll change!")
		    table.insert(phrases, "I can transform into any wild Pokémon![pause=0] Just let me topple them with a regular attack!")
		end
		
		if _DATA.Save.ActiveTeam.Players[0].BaseForm.Species == "ditto" then
		  table.insert(phrases, "Press [1] if you want me to take the lead!")
		else
		  table.insert(phrases, "Press [2] if you want me to take the lead!")
		end
		
		local chosen_idx = math.random(1, #phrases)
		local chosen_phrase = phrases[chosen_idx]
		if species then
			if math.random(1, 2) == 1 then
				chosen_phrase = phrases[7]
			end
		end
		
		UI:SetSpeaker(target)
		local tutorial_choices = {"Share Form", "Split Form", "Exit"}
		UI:BeginChoiceMenu(chosen_phrase, tutorial_choices, 1, 3)
		UI:WaitForChoice()
		result = UI:ChoiceResult()
		if result == 1 then
			-- melanie hits lumiere with normal attack
			action_res.Success = RogueEssence.Dungeon.ActionResult.ResultType.Success
			TASK:WaitTask(_DUNGEON:ProcessUseSkill(target, -1, action_res))
		elseif result == 2 then
			-- lumiere hits melanie with normal attack
			action_res.Success = RogueEssence.Dungeon.ActionResult.ResultType.Success
			TASK:WaitTask(_DUNGEON:ProcessUseSkill(chara, -1, action_res))
		end
	elseif target.BaseForm.Species == "smeargle" then
		DUNGEON:CharTurnToChar(target, chara)
		
		local mon = _DATA:GetMonster(chara.CurrentForm.Species)
		local phrases = { "Oh, what is it, Melanie?",
		"I'll sketch all the moves, and color your shape with them, Melanie~",
		"I'll never leave you behind, Melanie.",
		"I'll protect you, Melanie!",
		"Wanna learn something new, Melanie?",
		"I wonder what it's like to be a "..mon.Name:ToLocal().."..."
		}
		
		if target.CurrentForm.Species == "piplup" then
			table.insert(phrases, "Waddle waddle~")
		elseif target.CurrentForm.Species == "pichu" then
			table.insert(phrases, "Ah, how nostalgic...")
		elseif target.CurrentForm.Species == "togetic" then
			table.insert(phrases, "Let me spread joy to you!")
		elseif target.CurrentForm.Species == "mareep" then
			table.insert(phrases, "If you ever need to rest,[pause=0] just lay down on my soft fluffy wool.")
		elseif target.CurrentForm.Species == "pachirisu" then
			table.insert(phrases, "Anychu and everychu is your friend!")
		elseif target.CurrentForm.Species == "plusle" and chara.CurrentForm.Species == "minun" then
			table.insert(phrases, "Now aren't we just a perfect pair of chus?")
		elseif target.CurrentForm.Species == "minun" and chara.CurrentForm.Species == "plusle" then
			table.insert(phrases, "Now aren't we just a perfect pair of chus?")
		elseif target.CurrentForm.Species == "buneary" then
			table.insert(phrases, "I may be a Buneary for this moment, but I will always be YOUR bun!")
		elseif target.CurrentForm.Species == "jolteon" then
			table.insert(phrases, "Wow, I feel twitchy!")
		elseif target.CurrentForm.Species == "flareon" then
			table.insert(phrases, "This form sure is stuffy.[pause=0] My mane traps all the heat!")
		elseif target.CurrentForm.Species == "espeon" then
			table.insert(phrases, "You lyke thys form, ya?")
		elseif target.CurrentForm.Species == "umbreon" then
			table.insert(phrases, "I'll light the way!")
		elseif target.CurrentForm.Species == "sylveon" then
			table.insert(phrases, "Join your hand with my feeler,[pause=0] and we'll join our hearts~")
		elseif target.CurrentForm.Species == "porygon" then
			table.insert(phrases, "Beep boop.[pause=0] Today's a good day to code.")
		elseif target.CurrentForm.Species == "shedinja" then
			table.insert(phrases, "I will be your (Wonder) Guard.")
		elseif target.CurrentForm.Species == "charizard" then
			table.insert(phrases, "Rawr![pause=30] Imma dragon*!")
		elseif target.CurrentForm.Species == "flygon" then
			table.insert(phrases, "Ah, how I love this form...")
		elseif target.CurrentForm.Species == "altaria" then
			table.insert(phrases, "I feel soft, light as a cloud!")
		elseif target.CurrentForm.Species == "tyranitar" then
			table.insert(phrases, "No one's gonna mess with us now!")
		elseif target.CurrentForm.Species == "drifloon" then
			table.insert(phrases, "...FLOON!")
		elseif target.CurrentForm.Species == "lucario" then
			table.insert(phrases, "I'm sensing Pokémon everywhere!")
		elseif target.CurrentForm.Species == "dragonite" then
			table.insert(phrases, "Whoa, I can give even bigger hugs now!")
		end
		
		local species = false
		if #phrases == 6 then
			species = true
		end
		
		if _ZONE.CurrentZoneID == 39 then
		    table.insert(phrases, "Your genes sure are mysterious...[pause=0] it looks like you change every time you attack the air.")
		    table.insert(phrases, "If I defeat a Pokémon with a regular attack, I can sketch its last used move.")
		end
		
		if _DATA.Save.ActiveTeam.Players[0].BaseForm.Species == "smeargle" then
		  table.insert(phrases, "Press [1] if you want me to take the lead!")
		else
		  table.insert(phrases, "Press [2] if you want me to take the lead!")
		end
		
		local chosen_idx = math.random(1, #phrases)
		local chosen_phrase = phrases[chosen_idx]
		if species then
			if math.random(1, 2) == 1 then
				chosen_phrase = phrases[6]
			end
		end
		
		UI:SetSpeaker(target)
		local tutorial_choices = {"Share Form", "Split Form", "Exit"}
		UI:BeginChoiceMenu(chosen_phrase, tutorial_choices, 1, 3)
		UI:WaitForChoice()
		result = UI:ChoiceResult()
		if result == 1 then
			-- melanie hits lumiere with normal attack
			action_res.Success = RogueEssence.Dungeon.ActionResult.ResultType.Success
			TASK:WaitTask(_DUNGEON:ProcessUseSkill(chara, -1, action_res))
		elseif result == 2 then
			-- lumiere hits melanie with normal attack
			action_res.Success = RogueEssence.Dungeon.ActionResult.ResultType.Success
			TASK:WaitTask(_DUNGEON:ProcessUseSkill(target, -1, action_res))
		end
	elseif tbl.TalkAmount == nil then
		local skillNum = target.BaseSkills[0].SkillNum
		local move = RogueEssence.Data.DataManager.Instance:GetSkill(skillNum)
		UI:SetSpeaker(target)
		if chara.BaseForm.Species == "ditto" then
			UI:WaitShowDialogue("I have your form, and Lumiere's "..move:GetIconName().."!")
		elseif chara.BaseForm.Species == "smeargle" then
			UI:WaitShowDialogue("I have Melanie's form, and your "..move:GetIconName().."!")
		end
		
		tbl.TalkAmount = 1
	else
		
		local ratio = target.HP * 100 // target.MaxHP
		
		local mon = RogueEssence.Data.DataManager.Instance:GetMonster(target.BaseForm.Species)
		local form = mon.Forms[target.BaseForm.Form]
		
		local personality = form:GetPersonalityType(target.Discriminator)
		
		local personality_group = COMMON.PERSONALITY[personality]
		local pool = {}
		local key = ""
		if ratio <= 25 then
		  UI:SetSpeakerEmotion("Pain")
		  pool = personality_group.PINCH
		  key = "TALK_PINCH_%04d"
		elseif ratio <= 50 then
		  UI:SetSpeakerEmotion("Worried")
		  pool = personality_group.HALF
		  key = "TALK_HALF_%04d"
		else
		  pool = personality_group.FULL
		  key = "TALK_FULL_%04d"
		end
		
		local running_pool = {table.unpack(pool)}
		local valid_quote = false
		local chosen_quote = ""
		
		while not valid_quote and #running_pool > 0 do
		  valid_quote = true
		  local chosen_idx = math.random(1, #running_pool)
		  local chosen_pool_idx = running_pool[chosen_idx]
		  chosen_quote = RogueEssence.StringKey(string.format(key, chosen_pool_idx)):ToLocal()
		
      chosen_quote = string.gsub(chosen_quote, "%[player%]", chara:GetDisplayName(true))
      chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))
		  
		  if string.find(chosen_quote, "%[move%]") then
			local moves = {}
			for move_idx = 0, 3 do
			  if target.BaseSkills[move_idx].SkillNum ~= "" then
				table.insert(moves, target.BaseSkills[move_idx].SkillNum)
			  end
			end
			if #moves > 0 then
			  local chosen_move = RogueEssence.Data.DataManager.Instance:GetSkill(moves[math.random(1, #moves)])
  	      chosen_quote = string.gsub(chosen_quote, "%[move%]", chosen_move:GetIconName())
			else
			  valid_quote = false
			end
		  end
		  
		  if string.find(chosen_quote, "%[kind%]") then
			if GAME:GetCurrentFloor().TeamSpawns.CanPick then
			  local team_spawn = GAME:GetCurrentFloor().TeamSpawns:Pick(GAME.Rand)
			  local chosen_list = team_spawn:ChooseSpawns(GAME.Rand)
			  if chosen_list.Count > 0 then
				local chosen_mob = chosen_list[math.random(0, chosen_list.Count-1)]
				local mon = RogueEssence.Data.DataManager.Instance:GetMonster(chosen_mob.BaseForm.Species)
            chosen_quote = string.gsub(chosen_quote, "%[kind%]", mon:GetColoredName())
			  else
				valid_quote = false
			  end
			else
			  valid_quote = false
			end
		  end
		  
		  if string.find(chosen_quote, "%[item%]") then
			if GAME:GetCurrentFloor().ItemSpawns.CanPick then
			  local item = GAME:GetCurrentFloor().ItemSpawns:Pick(GAME.Rand)
          chosen_quote = string.gsub(chosen_quote, "%[item%]", item:GetDisplayName())
			else
			  valid_quote = false
			end
		  end
		
		  if not valid_quote then
			-- PrintInfo("Rejected "..chosen_quote)
			table.remove(running_pool, chosen_idx)
			chosen_quote = ""
		  end
		end
		-- PrintInfo("Selected "..chosen_quote)
		
		local oldDir = target.CharDir
		DUNGEON:CharTurnToChar(target, chara)
	  
		UI:SetSpeaker(target)
	  
		UI:WaitShowDialogue(chosen_quote)
	  
		target.CharDir = oldDir
	
	end
  else
  
    UI:ResetSpeaker()
	
	local chosen_quote = RogueEssence.StringKey("TALK_CANT"):ToLocal()
    chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))
	
    UI:WaitShowDialogue(chosen_quote)
  
  end
  
  if action_res.Success == RogueEssence.Dungeon.ActionResult.ResultType.TurnTaken then
    action_cancel.Cancel = false
    turn_cancel.Cancel = false
  elseif action_res.Success == RogueEssence.Dungeon.ActionResult.ResultType.Success then
    action_cancel.Cancel = false
  end
  
  
end

function COMMON.ShowTeamStorageMenu()
  UI:ResetSpeaker()
  
  local state = 0
  
  while state > -1 do
    
	local has_items = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount() > 0
	local has_storage = GAME:GetPlayerStorageCount() > 0
	
	
	local storage_choices = { { STRINGS:FormatKey('MENU_STORAGE_STORE'), has_items},
	{ STRINGS:FormatKey('MENU_STORAGE_TAKE_ITEM'), has_storage},
	{ STRINGS:FormatKey("MENU_STORAGE_MONEY"), true},
	{ STRINGS:FormatKey("MENU_CANCEL"), true}}
	UI:BeginChoiceMenu(STRINGS:FormatKey('DLG_WHAT_DO'), storage_choices, 1, 4)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	
	if result == 1 then
	  UI:StorageMenu()
	  UI:WaitForChoice()
	elseif result == 2 then
	  UI:WithdrawMenu()
	  UI:WaitForChoice()
	elseif result == 3 then
	  UI:BankMenu()
	  UI:WaitForChoice()
	elseif result == 4 then
	  state = -1
	end
	
  end
  
end

function COMMON.GroundInteract(chara, target)
  GROUND:CharTurnToChar(target, chara)
  UI:SetSpeaker(target)
  
  local mon = RogueEssence.Data.DataManager.Instance:GetMonster(target.CurrentForm.Species)
  local form = mon.Forms[target.CurrentForm.Form]
  
  local personality = form:GetPersonalityType(target.Data.Discriminator)
  
  local personality_group = COMMON.PERSONALITY[personality]
  local pool = personality_group.WAIT
  local key = "TALK_WAIT_%04d"
  
  local running_pool = {table.unpack(pool)}
  local valid_quote = false
  local chosen_quote = ""
  
  while not valid_quote and #running_pool > 0 do
    valid_quote = true
    local chosen_idx = math.random(1, #running_pool)
	local chosen_pool_idx = running_pool[chosen_idx]
    chosen_quote = RogueEssence.StringKey(string.format(key, chosen_pool_idx)):ToLocal()
	
    chosen_quote = string.gsub(chosen_quote, "%[hero%]", chara:GetDisplayName())
    
	if not valid_quote then
      -- PrintInfo("Rejected "..chosen_quote)
	  table.remove(running_pool, chosen_idx)
	  chosen_quote = ""
	end
  end
  -- PrintInfo("Selected "..chosen_quote)
  
  
  UI:WaitShowDialogue(chosen_quote)
end

function COMMON.Rescued(zone, name, mail)
  --Dummied out
end

function COMMON.EndRescue(zone, result, rescue, segmentID)
  --Dummied out
end

function COMMON.BeginDungeon(zoneId, segmentID, mapId)
  --COMMON.EnterDungeonMissionCheck(zoneId, segmentID)
end


function COMMON.EndDungeonDay(result, zoneId, structureId, mapId, entryId)
  COMMON.EndDayCycle()
  GAME:EndDungeonRun(result, zoneId, structureId, mapId, entryId, true, true)
  if GAME:InRogueMode() then
    GAME:RestartToTitle()
  else
	GAME:EnterZone(zoneId, structureId, mapId, entryId)
  end
end

function COMMON.EndSession(result, zoneId, structureId, mapId, entryId)
  GAME:EndDungeonRun(result, zoneId, structureId, mapId, entryId, false, false)
  GAME:EnterZone(zoneId, structureId, mapId, entryId)
end


function COMMON.EndDayCycle()
  --reshuffle items
  
  _DATA.Save.ActiveTeam.Guests:Clear()
  
  SV.base_shop = { }
  
end