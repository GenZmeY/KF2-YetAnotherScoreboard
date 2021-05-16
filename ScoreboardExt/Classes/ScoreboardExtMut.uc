class ScoreboardExtMut extends KFMutator;

function PostBeginPlay()
{
    Super.PostBeginPlay();
    WorldInfo.Game.HUDType = class'ScoreboardExtHUD'; 
}

defaultproperties
{
}