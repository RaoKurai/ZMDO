

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
    AI:SetCharacterAI(chara, "origin.ai.ground_partner", CH('PLAYER'), chara.Position)
    chara.CollisionDisabled = true
  end
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



function COMMON.EndDayCycle()
  --reshuffle items
  
  _DATA.Save.ActiveTeam.Guests:Clear()
  
end