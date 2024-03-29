require 'common'

local mystery_dungeon = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function mystery_dungeon.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_zone_37")
  

end

function mystery_dungeon.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function mystery_dungeon.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function mystery_dungeon.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_mystery_dungeon result "..tostring(result).." segment "..tostring(segmentID))
  
  --first check for rescue flag; if we're in rescue mode then take a different path
  --COMMON.ExitDungeonMissionCheck(zone.ID, segmentID)
  if rescue == true then
    COMMON.EndRescue(zone, result, segmentID)
  elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    COMMON.EndDungeonDay(result, SV.checkpoint.Zone, SV.checkpoint.Segment, SV.checkpoint.Map, SV.checkpoint.Entry)
  else
    if segmentID == 0 then
	  if SV.complete == true then
        COMMON.EndDungeonDay(result, "guildmaster_island", -1, 7, 0)
	  else
        COMMON.EndDungeonDay(result, "guildmaster_island", -1, 6, 0)
	  end
    else
      PrintInfo("No exit procedure found!")
	  COMMON.EndDungeonDay(result, SV.checkpoint.Zone, SV.checkpoint.Segment, SV.checkpoint.Map, SV.checkpoint.Entry)
    end
  end
  
end

return mystery_dungeon