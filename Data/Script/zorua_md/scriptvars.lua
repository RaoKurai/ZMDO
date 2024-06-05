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