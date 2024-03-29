--[[
    init.lua
    Created: 04/16/2021 09:17:18
    Description: Autogenerated script file for the map grove_exit.
]]--
-- Commonly included lua functions and data
require 'common'

-- Package name
local grove_exit = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---grove_exit.Init
--Engine callback function
function grove_exit.Init(map)

  --This will fill the localized strings table automatically based on the locale the game is 
  -- currently in. You can use the MapStrings table after this line!
  MapStrings = COMMON.AutoLoadLocalizedStrings()
  
end

---grove_exit.Enter
--Engine callback function
function grove_exit.Enter(map)
  
  if SV.complete then
    grove_exit.FinalCutscene()
  else
    grove_exit.Cutscene()
  end
end

---grove_exit.Exit
--Engine callback function
function grove_exit.Exit(map)


end

---grove_exit.Update
--Engine callback function
function grove_exit.Update(map)


end

function grove_exit.Cutscene()
  GAME:CutsceneMode(true)
  
  starter = CH("PLAYER")
  if starter.Data.BaseForm.Species == "ditto" then
	local mon_id = RogueEssence.Dungeon.MonsterID("smeargle", 0, "normal", Gender.Male)
	local player = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 30, "", 0)
	player.Nickname = "Lumiere"
    local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("AllyInteract")
    player.ActionEvents:Add(talk_evt)
	_DATA.Save.ActiveTeam.Players:Add(player)
	_DATA.Save:RegisterMonster("smeargle")
  else
	local mon_id = RogueEssence.Dungeon.MonsterID("ditto", 0, "normal", Gender.Genderless)
	local player = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 30, "", 0)
	player.Nickname = "Melanie"
    local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("AllyInteract")
    player.ActionEvents:Add(talk_evt)
	_DATA.Save.ActiveTeam.Players:Add(player)
	_DATA.Save:RegisterMonster("ditto")
  end
  
  COMMON.RespawnPartner(false)
  
  GAME:MoveCamera(224, 308, 1, false)
  GAME:FadeIn(20)
  
  local player = CH('PLAYER')
  local partner = CH('Partner')
  
  
  GAME:WaitFrames(30)
  local turnTime = 4
  SOUND:PlayBattleSE("EVT_Emote_Confused")
  GROUND:CharAnimateTurnTo(partner, Direction.Left, turnTime)
  GAME:WaitFrames(30)
  SOUND:PlayBattleSE("EVT_Emote_Confused")
  GROUND:CharAnimateTurn(partner, Direction.Right, turnTime, false)
  GAME:WaitFrames(30)
  GROUND:CharAnimateTurnTo(partner, Direction.Down, turnTime)
  
  SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
  GROUND:CharSetEmote(partner, "exclaim", 1)
  
  if player.Data.BaseForm.Species == "ditto" then
  
    local coro2 = TASK:BranchCoroutine(function() grove_exit.Concurrent_Sequence() end)
  
    UI:SetSpeaker(player)
    UI:WaitShowDialogue("Lumiere![pause=30] There you are!")
  
    UI:WaitShowDialogue("HUGGGG!!")
    GROUND:CharSetEmote(player, "glowing", 6)
    GAME:WaitFrames(30)
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue("Melanie!")
  
    TASK:JoinCoroutines({coro2})
    --release hug
    GROUND:CharEndAnim(player)
    GROUND:MoveInDirection(player, Direction.Down, 10, false, 2)
    GROUND:CharAnimateTurnTo(player, Direction.Up, 0)
  
    UI:SetSpeaker(player)
    UI:WaitShowDialogue("I'm so glad you're okay!")
  
    GROUND:CharSetEmote(partner, "glowing", 6)
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue("Haha,[pause=30] Same here.[pause=0] I just went through the weirdest place.")
    UI:WaitShowDialogue("The passages all were twisty,[pause=30] and it was filled with all these weird Pe'kemon!")
  
    UI:SetSpeaker(player)
    UI:WaitShowDialogue("Oh my gosh,[pause=30] I saw them too!")
    UI:WaitShowDialogue("They came in so many shapes and sizes,[pause=30] I couldn't help but copy a few, hehe!")
    GROUND:CharSetEmote(player, "happy", 3)
    GAME:WaitFrames(60);
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue("Speaking of places with lots of shapes,[pause=30] I can't wait to see this Pe'kemon City you've been talking about.")
    UI:SetSpeaker(player)
    UI:WaitShowDialogue("That's right![pause=30] We're almost there.[pause=0] It should just be over that hill.")
  else
    
    local coro2 = TASK:BranchCoroutine(function() grove_exit.Concurrent_Sequence_Simple() end)
  
    UI:SetSpeaker(player)
    UI:WaitShowDialogue("Melanie![pause=0] Boy am I glad to see you!")
	
    TASK:JoinCoroutines({coro2})
	
    GROUND:CharSetEmote(partner, "glowing", 6)
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue("Lumiere![pause=0] I was looking for you!")
	
    UI:WaitShowDialogue("I just went through such a weird place![pause=0] Full of dropped items and bizarred Pe'kemon!")
	
	local origForm = partner.Data.BaseForm
	
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 3)
    GROUND:CharAnimateTurnTo(partner, Direction.Down, 3)
	partner.Data.BaseForm = RogueEssence.Dungeon.MonsterID("piplup", 0, "melanie", Gender.Male)
    GAME:WaitFrames(20);
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue("The Piplup were small,")
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 3)
    GROUND:CharAnimateTurnTo(partner, Direction.Down, 3)
	partner.Data.BaseForm = RogueEssence.Dungeon.MonsterID("chikorita", 0, "melanie", Gender.Male)
    GAME:WaitFrames(20);
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue("The Chikorita stood on four legs,")
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 3)
    GROUND:CharAnimateTurnTo(partner, Direction.Down, 3)
	partner.Data.BaseForm = RogueEssence.Dungeon.MonsterID("buneary", 0, "melanie", Gender.Male)
    GAME:WaitFrames(20);
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue("And the Buneary didn't want to talk to me at all![pause=0] That never happens!")
	
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 3)
    GROUND:CharAnimateTurnTo(partner, Direction.Down, 3)
	partner.Data.BaseForm = origForm
    UI:SetSpeaker(player)
    UI:WaitShowDialogue("Same here.[pause=0] It had so many passages I thought I was going in circles.")
    UI:WaitShowDialogue("Well,[pause=30] at least we can get back on the road to Pe'kemon City.")
	
    GAME:WaitFrames(30);
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	
    GAME:WaitFrames(30);
    GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
    GAME:WaitFrames(30);
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue("That's right![pause=30] We're almost there.[pause=0] It should be just over that hill.")
  end
  SOUND:PlayBattleSE("EVT_Fade_White")
  GAME:FadeOut(true, 80)
  
  GAME:EnterGroundMap("crystal_entrance", "entrance")
end


function grove_exit.Concurrent_Sequence()
  local player = CH('PLAYER')
  
  GROUND:MoveInDirection(player, Direction.Up, 82, false, 2)
  
  GROUND:CharSetAnim(player, "Charge", true)
end

function grove_exit.Concurrent_Sequence_Simple()
  local player = CH('PLAYER')
  
  GROUND:MoveInDirection(player, Direction.Up, 74, false, 2)
end

function grove_exit.FinalCutscene()

  GAME:MoveCamera(224, 100, 1, false)
  
  COMMON.RespawnPartner(false)
  
  local player = CH('PLAYER')
  local partner = CH('Partner')
  local zorua = CH('Zorua')
  
  GROUND:TeleportTo(player, 104, 292, Direction.UpRight)
  GROUND:TeleportTo(partner, 104, 316, Direction.UpRight)
  
  GAME:CutsceneMode(true)
  GAME:FadeIn(20)
  
  
  
  GAME:WaitFrames(20);
  
  UI:SetSpeaker(zorua)
  
  UI:WaitShowDialogue("I knew I could make a Mystery Dungeon, but it came complete with Pokémon too!")
  UI:WaitShowDialogue("This is gonna be awesome, I can't wait till Zikare sees them.")
  UI:WaitShowDialogue("She's gonna be in for a big surprise!")
  
  
  GROUND:CharSetEmote(zorua, "glowing", 6)
  GROUND:MoveInDirection(zorua, Direction.Up, 70, false, 2)
  
  GAME:MoveCamera(224, 300, 60, false)
  
  GROUND:MoveInDirection(player, Direction.UpRight, 18, false, 2)
  GROUND:CharAnimateTurnTo(player, Direction.Up, 0)
  
  GROUND:MoveInDirection(partner, Direction.UpRight, 30, false, 2)
  GROUND:CharAnimateTurnTo(partner, Direction.Up, 0)
  
  GAME:WaitFrames(30);
  
  if player.Data.BaseForm.Species == "ditto" then
    GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
  
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue("Was that Zorua responsible for all the Mystery Dungeons?")
  
    GROUND:CharAnimateTurnTo(player, Direction.Right, 4)
    UI:SetSpeaker(player)
    UI:WaitShowDialogue("That's Kazure.[pause=30] The infamous Zorua of Pe'kemon City!")
    UI:WaitShowDialogue("Remember when I said some 'kemons in the city pull pranks?[pause=30] He's the prank lord!")
  
  
    GROUND:CharAnimateTurnTo(player, Direction.UpRight, 0)
    GROUND:MoveInDirection(partner, Direction.UpRight, 30, false, 2)
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 0)
  
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue("Hey look, up ahead! I can see the city lights!")
  
    TASK:BranchCoroutine(GAME:_MoveCamera(224, 240, 60, false))
  
    GROUND:MoveInDirection(player, Direction.UpRight, 30, false, 2)
    GROUND:CharAnimateTurnTo(player, Direction.Up, 0)
  
    UI:SetSpeaker(player)
    UI:WaitShowDialogue("That's Pe'Kemon city! Do you like it?")
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue("It's amazing!")
    UI:WaitShowDialogue("I can't wait to see all the sights![pause=0] Maybe I'll sketch them in an album!")
    UI:SetSpeaker(player)
    UI:WaitShowDialogue("I wonder what Kazure's up to this time...[pause=30] Looks like he's gonna put on a show.")
    UI:WaitShowDialogue("If it involves something like a Mystery Dungeon, it's bound to be spectacular!")
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue("If you plan on following him around,[pause=30] tell me what you see.[pause=0] Maybe I can sketch that out too!")
  else
  
    GROUND:CharAnimateTurnTo(player, Direction.Right, 4)
  
    UI:SetSpeaker(player)
    UI:WaitShowDialogue("Was that Zorua responsible for all the Mystery Dungeons?")
  
    GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue("That's Kazure.[pause=30] The infamous Zorua of Pe'kemon City!")
    UI:WaitShowDialogue("Remember how I told you some 'kemons pull pranks?[pause=30] He's the prank mon!")
  
  
    GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 0)
    GROUND:MoveInDirection(player, Direction.UpRight, 30, false, 2)
    GROUND:CharAnimateTurnTo(player, Direction.Up, 0)
  
    UI:SetSpeaker(player)
    UI:WaitShowDialogue("Hey look, up ahead! I can see the city lights!")
  
    TASK:BranchCoroutine(GAME:_MoveCamera(224, 240, 60, false))
  
    GROUND:MoveInDirection(partner, Direction.UpRight, 30, false, 2)
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 0)
  
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue("That's Pe'Kemon city! Do you like it?")
    UI:SetSpeaker(player)
    UI:WaitShowDialogue("It's amazing!")
    UI:WaitShowDialogue("I can't wait to meet the 'kemons you told me about![pause=0] Maybe I'll sketch them in an album.")
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue("Even the Zorua?[pause=0] After he took you on this wild ride?")
    UI:SetSpeaker(player)
    UI:WaitShowDialogue("Haah,[pause=30] maybe you can follow him around,[pause=30] and tell me all about it~")
  end
  
  local coro1 = TASK:BranchCoroutine(function() grove_exit.Concurrent_Exit() end)
  GAME:WaitFrames(10);
  GROUND:MoveInDirection(partner, Direction.Up, 60, false, 2)
  
  TASK:JoinCoroutines({coro1})
  
  GAME:FadeOut(false, 40)
  GAME:CutsceneMode(false)
  
  GAME:WaitFrames(20)
  UI:SetAutoFinish(true)
  UI:WaitShowVoiceOver("And that is the story...", -1)
  UI:WaitShowVoiceOver("...of how Melanie and Lumiere reached Pe'kemon City,", -1)
  UI:WaitShowVoiceOver("and began to follow the exploits of the Zorua...", -1)
  UI:WaitShowVoiceOver("...as they put their grand schemes into action.", -1)
  
  GAME:EnterGroundMap("title", "entrance", true)
  
end

function grove_exit.Concurrent_Exit()
  local player = CH('PLAYER')
  
  GROUND:MoveInDirection(player, Direction.Up, 90, false, 2)
end

-------------------------------
-- Entities Callbacks
-------------------------------


return grove_exit

