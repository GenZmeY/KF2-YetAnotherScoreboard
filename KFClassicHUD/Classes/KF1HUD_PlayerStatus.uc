class KF1HUD_PlayerStatus extends KFGFxHUD_PlayerStatus;

function UpdateXP(int XPDelta, int XPPercent, bool bLevelUp, Class<KFPerk> PerkClass)
{
    if(!bLevelUp && MyPC.GetPerkLevelFromPerkList(PerkClass) < `MAX_PERK_LEVEL)
        ClassicKFHUD(MyPC.MyHUD).NotifyXPEarned(XPDelta,PerkClass.default.PerkIcon,MakeColor(255, 255 * (KFPlayerReplicationInfo(MyPC.PlayerReplicationInfo).GetActivePerkLevel()/`MAX_PERK_LEVEL), 0, 255));
    
    Super.UpdateXP(XPDelta, XPPercent, bLevelUp, PerkClass);
}

DefaultProperties
{
    
}
