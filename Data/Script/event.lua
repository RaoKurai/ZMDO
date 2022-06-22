require 'common'

SINGLE_CHAR_SCRIPT = {}

function SINGLE_CHAR_SCRIPT.Test(owner, ownerChar, character, args)
  PrintInfo("Test")
end


ShopSecurityType = luanet.import_type('PMDC.Dungeon.ShopSecurityState')
MapIndexType = luanet.import_type('RogueEssence.Dungeon.MapIndexState')

function SINGLE_CHAR_SCRIPT.ThiefCheck(owner, ownerChar, character, args)
  local baseLoc = _DUNGEON.ActiveTeam.Leader.CharLoc
  local tile = _ZONE.CurrentMap.Tiles[baseLoc.X][baseLoc.Y]

  local thief_idx = 31
  if tile.Effect.ID ~= 45 then
    local price = COMMON.GetDungeonCartPrice()
	if price > 0 then
	  _GAME:BGM("", false)
      COMMON.ClearAllPrices()
		
	  local index_from = owner.StatusStates:Get(luanet.ctype(MapIndexType))
	  _DUNGEON:LogMsg(RogueEssence.StringKey(string.format("TALK_SHOP_THIEF_%04d", index_from.Index)):ToLocal())
		
	  -- create thief status
	  local thief_status = RogueEssence.Dungeon.MapStatus(thief_idx)
      thief_status:LoadFromData()
	  -- put spawner from security status in thief status
	  local security_to = thief_status.StatusStates:Get(luanet.ctype(ShopSecurityType))
	  local security_from = owner.StatusStates:Get(luanet.ctype(ShopSecurityType))
	  security_to.Security = security_from.Security
      TASK:WaitTask(_DUNGEON:RemoveMapStatus(owner.ID))
      TASK:WaitTask(_DUNGEON:AddMapStatus(thief_status))
	  GAME:WaitFrames(60)
	end
  else
    local shop_idx = 37
	if not _ZONE.CurrentMap.Status:ContainsKey(thief_idx) and not _ZONE.CurrentMap.Status:ContainsKey(shop_idx) then
	  
	  local shop_status = RogueEssence.Dungeon.MapStatus(shop_idx)
      shop_status:LoadFromData()
      TASK:WaitTask(_DUNGEON:AddMapStatus(shop_status))
	end
  end
end

AnchorType = luanet.import_type('PMDC.Dungeon.AnchorState')

function SINGLE_CHAR_SCRIPT.ShopCheckout(owner, ownerChar, character, args)
  local baseLoc = _DUNGEON.ActiveTeam.Leader.CharLoc
  local tile = _ZONE.CurrentMap.Tiles[baseLoc.X][baseLoc.Y]

  if tile.Effect.ID ~= 45 then
	local found_shopkeep = COMMON.FindNpcWithTable(false, "Role", "Shopkeeper")
    if found_shopkeep and COMMON.CanTalk(found_shopkeep) then
      local price = COMMON.GetDungeonCartPrice()
  
      if price > 0 then
	    local is_near = false
		local loc_diff = _DUNGEON.ActiveTeam.Leader.CharLoc - found_shopkeep.CharLoc
		if loc_diff:Dist8() > 1 then
		  -- check to see if the shopkeeper can see the player and warp there
		  if found_shopkeep:CanSeeCharacter(_DUNGEON.ActiveTeam.Leader) and not found_shopkeep.CharStates:Contains(luanet.ctype(AnchorType)) then
	        -- attempt to warp the shopkeeper next to the player
		    local cand_locs = _ZONE.CurrentMap:FindNearLocs(found_shopkeep, baseLoc, 1)
		    if cand_locs.Count > 0 then
		      TASK:WaitTask(_DUNGEON:PointWarp(found_shopkeep, cand_locs[0], false))
			  is_near = true
		    end
		  end
		else
		  is_near = true
		end

		-- if it can't, fall through
		if is_near then
		  DUNGEON:CharTurnToChar(found_shopkeep, _DUNGEON.ActiveTeam.Leader)
		  DUNGEON:CharTurnToChar(_DUNGEON.ActiveTeam.Leader, found_shopkeep)
          UI:SetSpeaker(found_shopkeep)
	      UI:ChoiceMenuYesNo(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_%04d", found_shopkeep.Discriminator)):ToLocal(), STRINGS:FormatKey("MONEY_AMOUNT", price)), false)
	      UI:WaitForChoice()
	      result = UI:ChoiceResult()
	      if result then
	        if price > GAME:GetPlayerMoney() then
              UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_SHORT_%04d", found_shopkeep.Discriminator)):ToLocal())
	        else
	          -- iterate player inventory prices and remove total price
              COMMON.PayDungeonCartPrice(price)
		      SOUND:PlayBattleSE("DUN_Money")
	          UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_DONE_%04d", found_shopkeep.Discriminator)):ToLocal())
	        end
	      end
		end
      else
        UI:SetSpeaker(found_shopkeep)
        UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_END_%04d", found_shopkeep.Discriminator)):ToLocal())
      end
	end
  end
end

function SINGLE_CHAR_SCRIPT.DestinationFloor(owner, ownerChar, character, args)
  SOUND:PlayFanfare("Fanfare/Note")
  UI:ResetSpeaker()
  UI:WaitShowDialogue("You've reached a destination floor!")
end


function SINGLE_CHAR_SCRIPT.Tutorial(owner, ownerChar, character, args)
  if character == nil then
    
    UI:ResetSpeaker()
    if args.Level == 1 then
	  if SV.charvars.ExpositionLevel < 1 then
	    SOUND:PlayFanfare("Fanfare/Note")
	    if SV.charvars.StartMelanie == true then
			UI:WaitShowDialogue("As a Ditto, Melanie can transform into any enemy she defeats![br]You don't get their moves, but you do get their type and stats.")
	    elseif SV.charvars.StartMelanie == false then
			UI:WaitShowDialogue("Lumiere can sketch the last move an enemy used when he defeats them.[br]They'll appear in the bag to learn from whenever you see fit.")
	    end
		SV.charvars.ExpositionLevel = 1
	  end
    elseif args.Level == 2 then
	  if SV.charvars.ExpositionLevel < 2 then
	    SOUND:PlayFanfare("Fanfare/Note")
	    if SV.charvars.StartMelanie == true then
			UI:WaitShowDialogue("Transforming only works if you defeat the target with a regular attack.[br]You can check the target's remaining health with [S].")
	    elseif SV.charvars.StartMelanie == false then
			UI:WaitShowDialogue("Sketching only works if you defeat the target with a regular attack.[br]You can check the target's remaining health with [S].")
	    end
		SV.charvars.ExpositionLevel = 2
	  end
    elseif args.Level == 3 then
	  if SV.charvars.ExpositionLevel < 3 then
	    SOUND:PlayFanfare("Fanfare/Note")
	    if SV.charvars.StartMelanie == true then
			UI:WaitShowDialogue("Lumiere can sketch the last move an enemy used when he defeats them.[br]They'll appear in the bag to learn from whenever you see fit.")
	    elseif SV.charvars.StartMelanie == false then
			UI:WaitShowDialogue("As a Ditto, Melanie can transform into any enemy she defeats![br]You don't get their moves, but you do get their type and stats.")
	    end
		SV.charvars.ExpositionLevel = 3
	  end
    elseif args.Level == 4 then
	  if SV.charvars.ExpositionLevel < 4 then
	    SOUND:PlayFanfare("Fanfare/Note")
	    UI:WaitShowDialogue("When Melanie and Lumiere interact, they can share moves, forms, and split new team members.[br]Splitting will consume Melanie's current form, and one of Lumiere's moves.")
		SV.charvars.ExpositionLevel = 4
	  end
    end
  end
end

function SINGLE_CHAR_SCRIPT.OutlawFloor(owner, ownerChar, character, args)
  SOUND:PlayBGM("C07. Outlaw.ogg", false)
  UI:ResetSpeaker()
  UI:WaitShowDialogue("Wanted outlaw spotted!")
  
  -- add a map status for outlaw clear check
  local checkClearStatus = 35 -- outlaw clear check
  local status = RogueEssence.Dungeon.MapStatus(checkClearStatus)
  status:LoadFromData()
  TASK:WaitTask(_DUNGEON:AddMapStatus(status))
end

function SINGLE_CHAR_SCRIPT.OutlawClearCheck(owner, ownerChar, character, args)
  -- check for no outlaw in the mission list
  remaining_outlaw = false
  for name, mission in pairs(SV.test_grounds.Missions) do
    PrintInfo("Checking Mission: "..tostring(name))
    if mission.Complete == COMMON.MISSION_INCOMPLETE and _ZONE.CurrentZoneID == mission.DestZone
	  and _ZONE.CurrentMapID.Segment == mission.DestSegment and _ZONE.CurrentMapID.ID == mission.DestFloor then
	  local found_outlaw = COMMON.FindNpcWithTable(true, "Mission", name)
      if found_outlaw then
	    remaining_outlaw = true
	  else
	    -- if no outlaws of the mission list, mark quest as complete
		mission.Complete = 1
		UI:ResetSpeaker()
        UI:WaitShowDialogue("Mission status set to complete. Return to quest giver for reward.")
	  end
    end
  end
  if not remaining_outlaw then
    -- if no outlaws are found in the map, return music to normal and remove this status from the map
    SOUND:PlayBGM(_ZONE.CurrentMap.Music, true)
    local checkClearStatus = 35 -- outlaw clear check
	TASK:WaitTask(_DUNGEON:RemoveMapStatus(checkClearStatus))
  end
end



function SINGLE_CHAR_SCRIPT.RemoveAbsentGuests(owner, ownerChar, character, args)

  if character ~= nil then
    return
  end

  local party = GAME:GetPlayerGuestTable()
  for i, p in ipairs(party) do
	if p.Dead then
	  _DUNGEON:RemoveChar(p)
	end
  end
end


function SINGLE_CHAR_SCRIPT.UpdatePolymorph(owner, ownerChar, character, args)
  if character == nil then
    return
  end
  
  if character.BaseForm.Species == 132 then -- ditto
    local monId = SV.charvars.MelanieForms[SV.charvars.MelanieIdx]
	character:Transform(RogueEssence.Dungeon.MonsterID(monId.Species, monId.Form, monId.Skin, RogueEssence.Data.Gender.Genderless))
  end
end


function SINGLE_CHAR_SCRIPT.UpdateTransform(owner, ownerChar, character, args)
  if character == nil then
    return
  end
  
  if character.BaseForm.Species == 235 then -- smeargle
    if SV.charvars.LumiereForm ~= nil then
		character:Transform(RogueEssence.Dungeon.MonsterID(SV.charvars.LumiereForm.Species, SV.charvars.LumiereForm.Form, SV.charvars.LumiereForm.Skin, RogueEssence.Data.Gender.Male))
    end
  end
  
end

BATTLE_SCRIPT = {}

function BATTLE_SCRIPT.Test(owner, ownerChar, context, args)
  PrintInfo("Test")
end

function BATTLE_SCRIPT.AllyInteract(owner, ownerChar, context, args)
  COMMON.DungeonInteract(context.User, context.Target, context.CancelState, context.TurnCancel)
end

function BATTLE_SCRIPT.NeutralInteract(owner, ownerChar, context, args)
  context.CancelState.Cancel = true
  context.TurnCancel.Cancel = true
  UI:ResetSpeaker()
  UI:WaitShowDialogue(context.Target:GetDisplayName(true) .. " is dancing furiously.")
end

function BATTLE_SCRIPT.ShopkeeperInteract(owner, ownerChar, context, args)

  if COMMON.CanTalk(context.Target) then
    local price = COMMON.GetDungeonCartPrice()
  
    local oldDir = context.Target.CharDir
    DUNGEON:CharTurnToChar(context.Target, context.User)
    if price > 0 then
      context.TurnCancel.Cancel = true
      UI:SetSpeaker(context.Target)
	  UI:ChoiceMenuYesNo(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_%04d", context.Target.Discriminator)):ToLocal(), STRINGS:FormatKey("MONEY_AMOUNT", price)), false)
	  UI:WaitForChoice()
	  result = UI:ChoiceResult()
	  if result then
	    if price > GAME:GetPlayerMoney() then
          UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_SHORT_%04d", context.Target.Discriminator)):ToLocal())
	    else
	      -- iterate player inventory prices and remove total price
          COMMON.PayDungeonCartPrice(price)
	      SOUND:PlayBattleSE("DUN_Money")
	      UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_DONE_%04d", context.Target.Discriminator)):ToLocal())
	    end
	  else
	    UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_REFUSE_%04d", context.Target.Discriminator)):ToLocal())
	  end
    else
      context.CancelState.Cancel = true
      UI:SetSpeaker(context.Target)
      UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_%04d", context.Target.Discriminator)):ToLocal())
    end
    context.Target.CharDir = oldDir
  else

    UI:ResetSpeaker()
	
	local chosen_quote = RogueEssence.StringKey("TALK_CANT"):ToLocal()
    chosen_quote = string.gsub(chosen_quote, "%[myname%]", context.Target:GetDisplayName(true))
    UI:WaitShowDialogue(chosen_quote)
  end
end

function BATTLE_SCRIPT.EscortInteract(owner, ownerChar, context, args)
  context.CancelState.Cancel = true
  local oldDir = context.Target.CharDir
  DUNGEON:CharTurnToChar(context.Target, context.User)
  UI:SetSpeaker(context.Target)
  UI:WaitShowDialogue("I'm counting on you!")
  context.Target.CharDir = oldDir
end

function BATTLE_SCRIPT.RescueReached(owner, ownerChar, context, args)

  local tbl = LTBL(context.Target)
  local mission = SV.test_grounds.Missions[tbl.Mission]
  mission.Complete = 1
  
  local oldDir = context.Target.CharDir
  DUNGEON:CharTurnToChar(context.Target, chara)
  
  UI:SetSpeaker(context.Target)
  UI:WaitShowDialogue("Yay, you found me!")
  
  -- warp out
  TASK:WaitTask(_DUNGEON:ProcessBattleFX(context.Target, context.Target, _DATA.SendHomeFX))
  _DUNGEON:RemoveChar(context.Target)
  
  UI:ResetSpeaker()
  UI:WaitShowDialogue("Mission status set to complete. Return to quest giver for reward.")
end


function BATTLE_SCRIPT.EscortRescueReached(owner, ownerChar, context, args)
  
  local tbl = LTBL(context.Target)
  local escort = COMMON.FindMissionEscort(tbl.Mission)
  
  if escort then
    
    local mission = SV.test_grounds.Missions[tbl.Mission]
    mission.Complete = 1
  
    local oldDir = context.Target.CharDir
    DUNGEON:CharTurnToChar(context.Target, chara)
  
    UI:SetSpeaker(context.Target)
    UI:WaitShowDialogue("Yay, you brought the escort to me!")
  
    -- warp out
    TASK:WaitTask(_DUNGEON:ProcessBattleFX(escort, escort, _DATA.SendHomeFX))
    _DUNGEON:RemoveChar(escort)
	
    TASK:WaitTask(_DUNGEON:ProcessBattleFX(context.Target, context.Target, _DATA.SendHomeFX))
    _DUNGEON:RemoveChar(context.Target)
  
    UI:ResetSpeaker()
    UI:WaitShowDialogue("Mission status set to complete. Return to quest giver for reward.")
  end
end

function BATTLE_SCRIPT.CountTalkTest(owner, ownerChar, context, args)
  context.CancelState.Cancel = true
  
  local tbl = LTBL(context.Target)
  
  local oldDir = context.Target.CharDir
  DUNGEON:CharTurnToChar(context.Target, chara)
  
  UI:SetSpeaker(context.Target)
  
  if tbl.TalkAmount == nil then
    UI:WaitShowDialogue("I will remember how many times I've been talked to.")
	tbl.TalkAmount = 1
  else
	tbl.TalkAmount = tbl.TalkAmount + 1
  end
  UI:WaitShowDialogue("You've talked to me "..tostring(tbl.TalkAmount).." times.")
  
  context.Target.CharDir = oldDir
end


function BATTLE_SCRIPT.AllyPutty(owner, ownerChar, context, args)
	if context.User.BaseForm.Species == 132 and context.Target.BaseForm.Species == 235 then -- melanie to lumiere
		local id = context.Data.ID

		local newData = RogueEssence.Data.BattleData()
		newData.Element = 13
		newData.Category = RogueEssence.Data.BattleData.SkillCategory.Status
		newData.HitRate = -1
		newData.OnHits:Add(0, RogueEssence.Dungeon.BattleScriptEvent("GiveMorph"))
		context.Data = newData
		context.Data.ID = id
	elseif context.Target.BaseForm.Species == 132 and context.User.BaseForm.Species == 235 then -- lumiere to melanie
		local id = context.Data.ID

		local newData = RogueEssence.Data.BattleData()
		newData.Element = 13
		newData.Category = RogueEssence.Data.BattleData.SkillCategory.Status
		newData.HitRate = -1
		newData.OnHits:Add(0, RogueEssence.Dungeon.BattleScriptEvent("SplitGuest"))
		context.Data = newData
		context.Data.ID = id
	end
end
	
IndexType = luanet.import_type('PMDC.Dungeon.IndexState')

function BATTLE_SCRIPT.GainSketch(owner, ownerChar, context, args)
	if context.User.BaseForm.Species == 235 then -- smeargle
		-- take the move last used by the target, create an Art from it
		local testStatus = context.Target:GetStatusEffect(27) -- last used move
		if testStatus ~= nil then
			local state = testStatus.StatusStates:Get(luanet.ctype(IndexType))
			local move = state.Index
			local item = RogueEssence.Dungeon.InvItem(move + 500)
			local team = context.User.MemberTeam

			local entry = _DATA:GetSkill(move)
			_DUNGEON:LogMsg(STRINGS:Format(RogueEssence.StringKey("MSG_SKETCH"):ToLocal(), context.User:GetDisplayName(false), context.Target:GetDisplayName(false), entry:GetIconName()))

			SOUND:PlayBattleSE("DUN_Sketch")
			local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Sketch", 3))
			emitter.Layer = DrawLayer.Front
			emitter:SetupEmit(context.Target.MapLoc, context.Target.MapLoc, context.Target.CharDir)
			_DUNGEON:CreateAnim(emitter, DrawLayer.NoDraw)
			
			GAME:WaitFrames(10)

			if team:GetInvCount() < team:GetMaxInvSlots(_ZONE.CurrentZone) then
				SOUND:PlaySE("Battle/DUN_Pick_Up")
				team:AddToInv(item)
			else
				_DUNGEON:LogMsg(STRINGS:Format(RogueEssence.StringKey("MSG_INV_FULL"):ToLocal(), context.User:GetDisplayName(false), item:GetDisplayName()))
				-- if the bag is full, or there is no bag, the stolen item will slide off in the opposite direction they're facing
				local endLoc = context.User.CharLoc + context.User.CharDir:Reverse():GetLoc()
				TASK:WaitTask(_DUNGEON:DropItem(item, endLoc, context.User.CharLoc))
			end
		end
	end
end

	
function BATTLE_SCRIPT.GainPolymorph(owner, ownerChar, context, args)
	if context.User.BaseForm.Species == 132 then -- ditto
		-- take the baseform of the target, create or add a status effect that keeps track of that form
		local form = { Species=context.Target.BaseForm.Species, Form=context.Target.BaseForm.Form, Skin=1 }
		--if form.Species == SV.charvars.MelanieForms[SV.charvars.MelanieIdx].Species then
		--	return
		--end
		for ii = 1, #SV.charvars.MelanieForms, 1 do
			if SV.charvars.MelanieForms[ii].Species == form.Species then
				table.remove(SV.charvars.MelanieForms, ii)
				break
			end
		end
		if form.Species == 172 then
			form.Form = 1
		end
		table.insert(SV.charvars.MelanieForms, form)
		SV.charvars.MelanieIdx = #SV.charvars.MelanieForms
		
		local unlock = _DATA.Save:GetMonsterUnlock(context.Target.BaseForm.Species)
		_DATA.Save:RegisterMonster(context.Target.BaseForm.Species)

		--SOUND:PlayBattleSE("DUN_Harden")
		SOUND:PlayBattleSE("DUN_Drink")

		local emitter = RogueEssence.Content.FiniteGatherEmitter(RogueEssence.Content.AnimData("Circle_Small_White_In", 1))
		emitter.ParticlesPerBurst = 1
		emitter.Bursts = 1
		emitter.TravelTime = 10
		emitter.UseDest = true
		emitter.Layer = DrawLayer.Front
		emitter:SetupEmit(context.Target.MapLoc, context.User.MapLoc, context.Target.CharDir)
		_DUNGEON:CreateAnim(emitter, DrawLayer.NoDraw)
		
		GAME:WaitFrames(10)

		-- Update form
		local monId = SV.charvars.MelanieForms[SV.charvars.MelanieIdx]
		context.User:Transform(RogueEssence.Dungeon.MonsterID(monId.Species, monId.Form, monId.Skin, RogueEssence.Data.Gender.Genderless))
		
		SOUND:PlayBattleSE("DUN_Substitute")
		emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Puff_Green", 3))
		emitter.Layer = DrawLayer.Front
		emitter:SetupEmit(context.User.MapLoc, context.User.MapLoc, context.User.CharDir)
		_DUNGEON:CreateAnim(emitter, DrawLayer.NoDraw)
		

		_DUNGEON:LogMsg(STRINGS:Format(RogueEssence.StringKey("MSG_TRANSFORM"):ToLocal(), context.User:GetDisplayName(false), context.Target:GetDisplayName(false)))

		if unlock ~= RogueEssence.Data.GameProgress.UnlockState.Completed then
			
			local totalDex = _DATA.Save:GetTotalMonsterUnlock(RogueEssence.Data.GameProgress.UnlockState.Completed)
			if _DATA.Save:GetMonsterUnlock(132) == RogueEssence.Data.GameProgress.UnlockState.Completed then
				totalDex = totalDex - 1
			end
			if _DATA.Save:GetMonsterUnlock(235) == RogueEssence.Data.GameProgress.UnlockState.Completed then
				totalDex = totalDex - 1
			end
			
			if totalDex == 5 then
				GAME:WaitFrames(30)
				UI:SetSpeaker(context.User)
				UI:WaitShowDialogue(RogueEssence.StringKey("DLG_FORM_1"):ToLocal())
			elseif totalDex == 10 then
				GAME:WaitFrames(30)
				UI:SetSpeaker(context.User)
				UI:WaitShowDialogue(RogueEssence.StringKey("DLG_FORM_2"):ToLocal())
			elseif totalDex == 15 then
				GAME:WaitFrames(30)
				UI:SetSpeaker(context.User)
				UI:WaitShowDialogue(RogueEssence.StringKey("DLG_FORM_4"):ToLocal())

				context.User.CharDir = Dir8.Down
				-- fade
				SOUND:PlayBattleSE("EVT_Evolution_Start")
				GAME:FadeOut(true, 20)

				local newId = { Species=132, Form=1, Skin=0}
				SV.charvars.MelanieForms[1] = newId
				SV.charvars.MelanieIdx = 1
				context.User:Promote(RogueEssence.Dungeon.MonsterID(newId.Species, newId.Form, newId.Skin, RogueEssence.Data.Gender.Genderless))
				context.User:Transform(RogueEssence.Dungeon.MonsterID(newId.Species, newId.Form, newId.Skin, RogueEssence.Data.Gender.Genderless))

				GAME:WaitFrames(30)
				-- fade
				SOUND:PlayBattleSE("EVT_Title_Intro")
				GAME:FadeIn(20)
				-- evolution chime
				SOUND:PlayFanfare("Fanfare/Promotion")
				GAME:WaitFrames(30)

				UI:SetSpeaker(context.User)
				UI:WaitShowDialogue(RogueEssence.StringKey("DLG_FORM_NEW"):ToLocal())
				UI:WaitShowDialogue(RogueEssence.StringKey("DLG_FORM_NEW_2"):ToLocal())
			end
		end
	end
end


AttackHitTotalType = luanet.import_type('PMDC.Dungeon.AttackHitTotal')

function BATTLE_SCRIPT.PolymorphMiss(owner, ownerChar, context, args)
	if context.User.BaseForm.Species == 132 then -- ditto
		-- only on normal attack
		local total = 0
		local state = context.GlobalContextStates:GetWithDefault(luanet.ctype(AttackHitTotalType))
		if state ~= nil then
			total = state.Count
		end
		
		if total == 0 then
			-- on miss all
			-- take the baseform of the target, create or add a status effect that keeps track of that form

			if #SV.charvars.MelanieForms == 1 then
				return
			end
			SV.charvars.MelanieIdx = (SV.charvars.MelanieIdx + #SV.charvars.MelanieForms - 2) % #SV.charvars.MelanieForms + 1
			local monId = SV.charvars.MelanieForms[SV.charvars.MelanieIdx]
			-- Update form
			context.User:Transform(RogueEssence.Dungeon.MonsterID(monId.Species, monId.Form, monId.Skin, RogueEssence.Data.Gender.Genderless))
			SOUND:PlayBattleSE("DUN_Substitute")
			local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Puff_Green", 3))
			emitter.Layer = DrawLayer.Front
			emitter:SetupEmit(context.User.MapLoc, context.User.MapLoc, context.User.CharDir)
			_DUNGEON:CreateAnim(emitter, DrawLayer.NoDraw)
		end
	end
end
	
function BATTLE_SCRIPT.PolymorphRelease(owner, ownerChar, context, args)
	-- only on normal attack
	local total = 0
	local state = context.GlobalContextStates:GetWithDefault(luanet.ctype(AttackHitTotalType))
	if state ~= nil then
		total = state.Count
	end
	
	if total == 0 then
		-- on miss all
		-- take the baseform of the target, create or add a status effect that keeps track of that form
		TASK:WaitTask(context.User:RemoveStatusEffect(130, true))
		context.User:Transform(context.User.BaseForm)

		SOUND:PlayBattleSE("DUN_Substitute")
		local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Puff_Green", 3))
		emitter.Layer = DrawLayer.Front
		emitter:SetupEmit(context.User.MapLoc, context.User.MapLoc, context.User.CharDir)
		_DUNGEON:CreateAnim(emitter, DrawLayer.NoDraw)
	end
end
	
function BATTLE_SCRIPT.GiveMorph(owner, ownerChar, context, args)

	if SV.charvars.MelanieIdx == 1 then
		_DUNGEON:LogMsg(STRINGS:Format("{0} isn't transformed!", context.User:GetDisplayName(false)))
		return
	end

	local monId = SV.charvars.MelanieForms[SV.charvars.MelanieIdx]
	table.remove(SV.charvars.MelanieForms, SV.charvars.MelanieIdx)
	SV.charvars.MelanieIdx = (SV.charvars.MelanieIdx - 1) % #SV.charvars.MelanieForms + 1

	monId.Skin = 0

	local morphStatus = RogueEssence.Dungeon.StatusEffect(130)
	morphStatus:LoadFromData()
	SV.charvars.LumiereForm = monId
	TASK:WaitTask(context.Target:AddStatusEffect(context.Target, morphStatus, nil))

	-- Update form
	local backId = SV.charvars.MelanieForms[SV.charvars.MelanieIdx]
	context.User:Transform(RogueEssence.Dungeon.MonsterID(backId.Species, backId.Form, backId.Skin, RogueEssence.Data.Gender.Genderless))
	context.Target:Transform(RogueEssence.Dungeon.MonsterID(monId.Species, monId.Form, monId.Skin, RogueEssence.Data.Gender.Male))


	local monsterEntry = _DATA:GetMonster(monId.Species)
	_DUNGEON:LogMsg(STRINGS:Format(RogueEssence.StringKey("MSG_TRANSFORM"):ToLocal(), context.Target:GetDisplayName(false), monsterEntry:GetColoredName()))

	SOUND:PlayBattleSE("DUN_Substitute")
	local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Puff_Green", 3))
	emitter.Layer = DrawLayer.Front
	emitter:SetupEmit(context.Target.MapLoc, context.Target.MapLoc, context.Target.CharDir)
	_DUNGEON:CreateAnim(emitter, DrawLayer.NoDraw)
	
	GAME:WaitFrames(10)
end

	
function BATTLE_SCRIPT.SplitGuest(owner, ownerChar, context, args)
	if SV.charvars.MelanieIdx == 1 then
		_DUNGEON:LogMsg(STRINGS:Format("{0} isn't transformed!", context.Target:GetDisplayName(false)))
		return
	end
	if context.User.BaseSkills[1].SkillNum == -1 then
		_DUNGEON:LogMsg(STRINGS:Format("{0} doesn't have enough moves!", context.User:GetDisplayName(false)))
		return
	end

	SOUND:PlayBattleSE("DUN_Astonish_2")

	local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Circle_Small_White_In", 1))
	emitter.Layer = DrawLayer.Front
	emitter:SetupEmit(context.Target.MapLoc, context.Target.MapLoc, context.Target.CharDir)
	_DUNGEON:CreateAnim(emitter, DrawLayer.NoDraw)

	GAME:WaitFrames(10)

	-- create new mon

	local monId = SV.charvars.MelanieForms[SV.charvars.MelanieIdx]
	if monId.Species == 172 then
		monId.Form = 0
	end
	monId.Skin = 0
	local skill = context.User.BaseSkills[0].SkillNum

	local names = { "me", "la", "nie", "mel", "lan", "ie", "lu", "mi", "ere", "lum" }
	local syllables = _DATA.Save.Rand:Next() % 4 + 2
	local finalName = ""
	for ii = 1, syllables, 1 do
		local syllable = _DATA.Save.Rand:Next() % #names + 1
		finalName = finalName..names[syllable]
		table.remove(names, syllable)
	end
	
	if finalName == "melanie" or finalName == "lumiere" or finalName == "melumi" or finalName == "mellumi" or finalName == "melumiere" then
		finalName = ""
		for ii = 1, syllables, 1 do
			local syllable = _DATA.Save.Rand:Next() % #names + 1
			finalName = finalName..names[syllable]
			table.remove(names, syllable)
		end
	end
	finalName = finalName:gsub("^%l", string.upper)

	local character = RogueEssence.Dungeon.CharData()
	character.BaseForm = RogueEssence.Dungeon.MonsterID(monId.Species, monId.Form, monId.Skin, RogueEssence.Data.Gender.Genderless)
	character.Nickname = finalName
	character.Discriminator = _DATA.Save.Rand:Next()
	character.Level = 20

	character.BaseSkills[0] = RogueEssence.Dungeon.SlotSkill(skill)
	character.BaseIntrinsics[0] = context.Target.Intrinsics[0].Element.ID

	local new_mob = RogueEssence.Dungeon.Character(character, context.User.MemberTeam)
	context.User.MemberTeam.Guests:Add(new_mob)
	new_mob.CharLoc = context.Target.CharLoc
	new_mob.CharDir = context.Target.CharDir
	new_mob.Tactic = RogueEssence.Data.AITactic(context.Target.Tactic)

	new_mob.Skills[0].Element.Enabled = true
    local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("AllyInteract")
    new_mob.ActionEvents:Add(talk_evt)
	new_mob:RefreshTraits()

	-- remove the form and move
	table.remove(SV.charvars.MelanieForms, SV.charvars.MelanieIdx)
	SV.charvars.MelanieIdx = (SV.charvars.MelanieIdx - 1) % #SV.charvars.MelanieForms + 1
	local newId = SV.charvars.MelanieForms[SV.charvars.MelanieIdx]
	context.Target:Transform(RogueEssence.Dungeon.MonsterID(newId.Species, newId.Form, newId.Skin, RogueEssence.Data.Gender.Genderless))
	context.User:DeleteSkill(0)

	-- send the new mon out
	local noHealStatus = RogueEssence.Dungeon.StatusEffect(131)
	noHealStatus:LoadFromData()
	TASK:WaitTask(new_mob:AddStatusEffect(new_mob, noHealStatus, nil))

	local dest = _ZONE.CurrentMap:GetClosestTileForChar(new_mob, context.Target.CharLoc)
	local endLoc = nil
	if dest ~= nil then
		endLoc = dest
	else
		endLoc = context.Target.CharLoc
	end

	local jumpTo = RogueEssence.Dungeon.CharAnimJump()
	jumpTo.FromLoc = new_mob.CharLoc
	jumpTo.CharDir = new_mob.CharDir
	jumpTo.ToLoc = endLoc

	jumpTo.MajorAnim = true
	TASK:WaitTask(new_mob:StartAnim(jumpTo))

	_DUNGEON:LogMsg(STRINGS:Format(RogueEssence.StringKey("MSG_SPLIT"):ToLocal(), new_mob:GetDisplayName(false), context.Target:GetDisplayName(false)))

	TASK:WaitTask(_DUNGEON:ArriveOnTile(new_mob))

	TASK:WaitTask(new_mob:OnMapStart())
end

MoveLearnContextType = luanet.import_type('PMDC.Dungeon.MoveLearnContext')



function BATTLE_SCRIPT.SwapUlt(owner, ownerChar, context, args)
	local learnContext = context.ContextStates:GetWithDefault(luanet.ctype(MoveLearnContextType))
	if learnContext ~= nil then
		if context.User.BaseForm.Species == 235 and learnContext.MoveLearn == 148 and SV.charvars.LumiereMoves >= 20 then
			learnContext.MoveLearn = 711
		end
	end
end


function BATTLE_SCRIPT.UltLearn(owner, ownerChar, context, args)

	if context.User.BaseForm.Species == 235 then
		local relearnable = 0
		for ii = 0, context.User.Relearnables.Count - 1, 1 do
			if context.User.Relearnables[ii] then
				relearnable = relearnable + 1
			end
		end
		
		if SV.charvars.LumiereMoves == relearnable then
			-- do nothing
		elseif relearnable == 5 then
			GAME:WaitFrames(30)
			UI:SetSpeaker(context.User)
			UI:WaitShowDialogue(RogueEssence.StringKey("DLG_SKILL_1"):ToLocal())
		elseif relearnable == 10 then
			GAME:WaitFrames(30)
			UI:SetSpeaker(context.User)
			UI:WaitShowDialogue(RogueEssence.StringKey("DLG_SKILL_3"):ToLocal())
		elseif relearnable == 15 then
			GAME:WaitFrames(30)
			UI:SetSpeaker(context.User)
			UI:WaitShowDialogue(RogueEssence.StringKey("DLG_SKILL_4"):ToLocal())
			UI:WaitShowDialogue(RogueEssence.StringKey("DLG_SKILL_NEW"):ToLocal())
			local skill = 711
			
			GAME:TryLearnSkill(context.User, skill)
		end
		SV.charvars.LumiereMoves = relearnable
	end
end

function AddStat(stat, target)
	local prevStat = 0
	local newStat = 0
	
	if stat == RogueEssence.Data.Stat.HP and target.MaxHPBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST then
		prevStat = target.MaxHP
		target.MaxHPBonus = target.MaxHPBonus + 1
		newStat = target.MaxHP
	elseif stat == RogueEssence.Data.Stat.Attack and target.AtkBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST then
		prevStat = target.BaseAtk
		target.AtkBonus = target.AtkBonus + 1
		newStat = target.BaseAtk
	elseif stat == RogueEssence.Data.Stat.Defense and target.DefBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST then
		prevStat = target.BaseDef
		target.DefBonus = target.DefBonus + 1
		newStat = target.BaseDef
	elseif stat == RogueEssence.Data.Stat.MAtk and target.MAtkBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST then
		prevStat = target.BaseMAtk
		target.MAtkBonus = target.MAtkBonus + 1
		newStat = target.BaseMAtk
	elseif stat == RogueEssence.Data.Stat.MDef and target.MDefBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST then
		prevStat = target.BaseMDef
		target.MDefBonus = target.MDefBonus + 1
		newStat = target.BaseMDef
	elseif stat == RogueEssence.Data.Stat.Speed and target.SpeedBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST then
		prevStat = target.BaseSpeed
		target.SpeedBonus = target.SpeedBonus + 1
		newStat = target.BaseSpeed
	end
	
	if newStat - prevStat > 0 then
		local localStat = RogueEssence.Text.ToLocal(stat)
		_DUNGEON:LogMsg(STRINGS:Format(RogueEssence.StringKey("MSG_STAT_BOOST"):ToLocal(), target:GetDisplayName(false), localStat, tostring(newStat - prevStat)))
	end
end

function BATTLE_SCRIPT.AltGummi(owner, ownerChar, context, args)
	local targetElement = args.Element
	
	local heal = 5
	local stats = { }
	if context.Target:HasElement(targetElement) then
		heal = 15
		table.insert(stats, RogueEssence.Data.Stat.HP)
		table.insert(stats, RogueEssence.Data.Stat.Attack)
		table.insert(stats, RogueEssence.Data.Stat.Defense)
		table.insert(stats, RogueEssence.Data.Stat.MAtk)
		table.insert(stats, RogueEssence.Data.Stat.MDef)
		table.insert(stats, RogueEssence.Data.Stat.Speed)
	else
		local randStat = _DATA.Save.Rand:Next() % 6
		if randStat == 0 then
			table.insert(stats, RogueEssence.Data.Stat.HP)
		elseif randStat == 1 then
			table.insert(stats, RogueEssence.Data.Stat.Attack)
		elseif randStat == 2 then
			table.insert(stats, RogueEssence.Data.Stat.Defense)
		elseif randStat == 3 then
			table.insert(stats, RogueEssence.Data.Stat.MAtk)
		elseif randStat == 4 then
			table.insert(stats, RogueEssence.Data.Stat.MDef)
		elseif randStat == 5 then
			table.insert(stats, RogueEssence.Data.Stat.Speed)
		end
	end
	
	for ii = 1, #stats, 1 do
		AddStat(stats[ii], context.Target)
	end
	
	if heal > 5 then
		_DUNGEON:LogMsg(STRINGS:Format(RogueEssence.StringKey("MSG_HUNGER_FILL_MIN"):ToLocal(), context.Target:GetDisplayName(false)))
	end

	context.Target.Fullness = context.Target.Fullness + heal

	if context.Target.Fullness > context.Target.MaxFullness then
		context.Target.Fullness = context.Target.MaxFullness
	end
end
	
STATUS_SCRIPT = {}

function STATUS_SCRIPT.Test(owner, ownerChar, context, args)
  PrintInfo("Test")
end


MAP_STATUS_SCRIPT = {}

function MAP_STATUS_SCRIPT.Test(owner, ownerChar, character, status, msg, args)
  PrintInfo("Test")
end


function MAP_STATUS_SCRIPT.ShopGreeting(owner, ownerChar, character, status, msg, args)
  
  if status ~= owner or character ~= nil then
    return
  end
  local found_shopkeep = COMMON.FindNpcWithTable(false, "Role", "Shopkeeper")
  if found_shopkeep and COMMON.CanTalk(found_shopkeep) then
    DUNGEON:CharTurnToChar(found_shopkeep, _DUNGEON.ActiveTeam.Leader)
    UI:SetSpeaker(found_shopkeep)
    UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_START_%04d", found_shopkeep.Discriminator)):ToLocal())
	GAME:WaitFrames(10)
  end
end


function MAP_STATUS_SCRIPT.SetShopkeeperHostile(owner, ownerChar, character, status, msg, args)
  
  if status ~= owner or character ~= nil then
    return
  end
  local found_shopkeep = COMMON.FindNpcWithTable(false, "Role", "Shopkeeper")
  if found_shopkeep then
    local teamIndex = _ZONE.CurrentMap.AllyTeams:IndexOf(found_shopkeep.MemberTeam)
	_DUNGEON:RemoveTeam(RogueEssence.Dungeon.Faction.Friend, teamIndex)
	_DUNGEON:AddTeam(RogueEssence.Dungeon.Faction.Foe, found_shopkeep.MemberTeam)
	local tactic = _DATA:GetAITactic(23) -- shopkeeper attack tactic
	found_shopkeep.Tactic = RogueEssence.Data.AITactic(tactic)
	found_shopkeep.Tactic:Initialize(found_shopkeep)
	
	local berserk_idx = 128
	local berserk = RogueEssence.Dungeon.StatusEffect(berserk_idx)
	TASK:WaitTask(found_shopkeep:AddStatusEffect(nil, berserk, nil))
  end
  -- force everyone to skip their turn for this entire session
  _ZONE.CurrentMap.CurrentTurnMap:SkipRemainingTurns()
end

REFRESH_SCRIPT = {}

function REFRESH_SCRIPT.Test(owner, ownerChar, character, args)
  PrintInfo("Test")
end


SKILL_CHANGE_SCRIPT = {}

function SKILL_CHANGE_SCRIPT.Test(owner, character, skillIndices, args)
  PrintInfo("Test")
end


ZONE_GEN_SCRIPT = {}

function ZONE_GEN_SCRIPT.Test(zoneContext, context, queue, seed, args)
  PrintInfo("Test")
end

PresetMultiTeamSpawnerType = luanet.import_type('RogueEssence.LevelGen.PresetMultiTeamSpawner`1')
PlaceRandomMobsStepType = luanet.import_type('RogueEssence.LevelGen.PlaceRandomMobsStep`1')
PlaceEntranceMobsStepType = luanet.import_type('RogueEssence.LevelGen.PlaceEntranceMobsStep`2')
MapEffectStepType = luanet.import_type('RogueEssence.LevelGen.MapEffectStep`1')
MapGenContextType = luanet.import_type('RogueEssence.LevelGen.ListMapGenContext')
EntranceType = luanet.import_type('RogueEssence.LevelGen.MapGenEntrance')

function ZONE_GEN_SCRIPT.SpawnMissionNpcFromSV(zoneContext, context, queue, seed, args)
  -- choose a the floor to spawn it on
  local destinationFloor = false
  local outlawFloor = false
  for name, mission in pairs(SV.test_grounds.Missions) do
    PrintInfo("Checking Mission: "..tostring(name))
    if mission.Complete == COMMON.MISSION_INCOMPLETE and zoneContext.CurrentZone == mission.DestZone
	  and zoneContext.CurrentSegment == mission.DestSegment and zoneContext.CurrentID == mission.DestFloor then
      PrintInfo("Spawning Mission Goal")
	  if mission.Type == COMMON.MISSION_TYPE_OUTLAW then -- outlaw
        local specificTeam = RogueEssence.LevelGen.SpecificTeamSpawner()
        local post_mob = RogueEssence.LevelGen.MobSpawn()
        post_mob.BaseForm = RogueEssence.Dungeon.MonsterID(mission.TargetSpecies, 0, 0, Gender.Unknown)
        post_mob.Tactic = 20
        post_mob.Level = RogueElements.RandRange(50)
		post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnLuaTable('{ Mission = "'..name..'" }'))
	    specificTeam.Spawns:Add(post_mob)
        PrintInfo("Creating Spawn")
        local picker = LUA_ENGINE:MakeGenericType(PresetMultiTeamSpawnerType, { MapGenContextType }, { })
	    picker.Spawns:Add(specificTeam)
        PrintInfo("Creating Step")
        local mobPlacement = LUA_ENGINE:MakeGenericType(PlaceEntranceMobsStepType, { MapGenContextType, EntranceType }, { picker })
        PrintInfo("Enqueueing")
	    -- Priority 5.2.1 is for NPC spawning in PMDO, but any dev can choose to roll with their own standard of priority.
	    local priority = RogueElements.Priority(5, 2, 1)
	    queue:Enqueue(priority, mobPlacement)
        PrintInfo("Done")
	    outlawFloor = true
	  else
        local specificTeam = RogueEssence.LevelGen.SpecificTeamSpawner()
        local post_mob = RogueEssence.LevelGen.MobSpawn()
        post_mob.BaseForm = RogueEssence.Dungeon.MonsterID(mission.TargetSpecies, 0, 0, Gender.Unknown)
        post_mob.Tactic = 21
        post_mob.Level = RogueElements.RandRange(50)
	    if mission.Type == COMMON.MISSION_TYPE_RESCUE then -- rescue
	      local dialogue = RogueEssence.Dungeon.BattleScriptEvent("RescueReached")
          post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnInteractable(dialogue))
          post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnLuaTable('{ Mission = "'..name..'" }'))
        elseif mission.Type == COMMON.MISSION_TYPE_ESCORT then -- escort
	      local dialogue = RogueEssence.Dungeon.BattleScriptEvent("EscortRescueReached")
          post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnInteractable(dialogue))
          post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnLuaTable('{ Mission = "'..name..'" }'))
	    end
	    specificTeam.Spawns:Add(post_mob)
        PrintInfo("Creating Spawn")
        local picker = LUA_ENGINE:MakeGenericType(PresetMultiTeamSpawnerType, { MapGenContextType }, { })
	    picker.Spawns:Add(specificTeam)
        PrintInfo("Creating Step")
        local mobPlacement = LUA_ENGINE:MakeGenericType(PlaceRandomMobsStepType, { MapGenContextType }, { picker })
        PrintInfo("Setting everything else")
        mobPlacement.Ally = true
        mobPlacement.Filters:Add(PMDC.LevelGen.RoomFilterConnectivity(PMDC.LevelGen.ConnectivityRoom.Connectivity.Main))
        mobPlacement.ClumpFactor = 20
        PrintInfo("Enqueueing")
	    -- Priority 5.2.1 is for NPC spawning in PMDO, but any dev can choose to roll with their own standard of priority.
	    local priority = RogueElements.Priority(5, 2, 1)
	    queue:Enqueue(priority, mobPlacement)
        PrintInfo("Done")
	    destinationFloor = true
	  end
    end
  end
  
  if destinationFloor then
    -- add destination floor notification
    local activeEffect = RogueEssence.Data.ActiveEffect()
    activeEffect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("DestinationFloor"))
	local destNote = LUA_ENGINE:MakeGenericType( MapEffectStepType, { MapGenContextType }, { activeEffect })
	local priority = RogueElements.Priority(-6)
	queue:Enqueue(priority, destNote)
  end
  if outlawFloor then
    -- add destination floor notification
    local activeEffect = RogueEssence.Data.ActiveEffect()
    activeEffect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("OutlawFloor"))
	local destNote = LUA_ENGINE:MakeGenericType( MapEffectStepType, { MapGenContextType }, { activeEffect })
	local priority = RogueElements.Priority(-6)
	queue:Enqueue(priority, destNote)
  end
end


FLOOR_GEN_SCRIPT = {}

function FLOOR_GEN_SCRIPT.Test(map, args)
  PrintInfo("Test")
end




