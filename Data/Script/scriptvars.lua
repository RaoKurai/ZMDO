--[[
    scriptvars.lua
      This file contains all the default values for the script variables. AKA on a new game this file is loaded!
      Script variables are stored in a table  that gets saved when the game is saved.
      Its meant to be used for scripters to add data to be saved and loaded during a playthrough.
      
      You can simply refer to the "SV" global table like any other table in any scripts!
      You don't need to write a default value in this lua script to add a new value.
      However its good practice to set a default value when you can!
      
    --Examples:
    SV.SomeVariable = "Smiles go for miles!"
    SV.AnotherVariable = 2526
    SV.AnotherVariable = { something={somethingelse={} } }
    SV.AnotherVariable = function() PrintInfo('lmao') end
]]--

-----------------------------------------------
-- Services Defaults
-----------------------------------------------
SV.Services =
{
  --Anything that applies to services should be put in here, or assigned to this or a subtable of this in the service's definition script
}

-----------------------------------------------
-- General Defaults
-----------------------------------------------
SV.General =
{
  Rescue = nil
  --Anything that applies to more than a single level, and that is too small to make a sub-table for, should be put in here ideally, or a sub-table of this
}

SV.checkpoint = 
{
  Zone    = "guildmaster_island", Segment  = -1,
  Map  = 1, Entry  = 0
}

-----------------------------------------------
-- Level Specific Defaults
-----------------------------------------------
SV.test_grounds =
{
  SpokeToPooch = false,
  AcceptedPooch = false,
  Missions = { },
  CurrentOutlaws = { },
  FinishedMissions = { }
}


SV.charvars = 
{
  StartMelanie = false,
  MelanieForms    = { { Species="ditto", Form=0, Skin="normal"} },
  MelanieIdx    = 1,
  LumiereForm = nil,
  LumiereMoves = 0,
  ExpositionLevel = 0
}



SV.grove_entrance = 
{
  IntroComplete  = false
}

SV.crystal_entrance = 
{
  IntroComplete  = false
}

SV.mystery_entrance = 
{
  IntroComplete  = false
}

SV.complete = false

----------------------------------------------