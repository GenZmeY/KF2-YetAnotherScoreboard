class KF1_HUDWrapper extends KFGFxMoviePlayer_HUD;

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	local bool Ret;
	
    if( WidgetName == 'ObjectiveContainer' )
        return false;
    
	Ret = Super.WidgetInitialized(WidgetName, WidgetPath, Widget);
	
	if( WaveInfoWidget != None )
	{
		WaveInfoWidget.SetVisible(false);
	}
	
	if( MusicNotification != None )
	{
		MusicNotification.SetVisible(false);
	}
	
	if( TraderCompassWidget != None )
	{
		TraderCompassWidget.SetVisible(false);
	}	
    
    if( KeyboardWeaponSelectWidget != None )
	{
		KeyboardWeaponSelectWidget.SetVisible(false);
	}   
	
	return Ret;
}

function TickHud(float DeltaTime)
{
	local ASDisplayInfo DI;
	
	Super.TickHud(DeltaTime);
	
	if( PlayerStatusContainer != None )
	{
		DI = PlayerStatusContainer.GetDisplayInfo();
		if( DI.Visible )
		{
			DI.Visible = false;
			PlayerStatusContainer.SetDisplayInfo(DI);
		}
	}
	
	if( PlayerBackpackContainer != None )
	{
		DI = PlayerBackpackContainer.GetDisplayInfo();
		if( DI.Visible )
		{
			DI.Visible = false;
			PlayerBackpackContainer.SetDisplayInfo(DI);
		}
	}
	
	if( WaveInfoWidget != None )
	{
		DI = WaveInfoWidget.GetDisplayInfo();
		if( DI.Visible )
		{
			DI.Visible = false;
			WaveInfoWidget.SetDisplayInfo(DI);
		}
	}
	
	if( TraderCompassWidget != None )
	{
		DI = TraderCompassWidget.GetDisplayInfo();
		if( DI.Visible )
		{
			DI.Visible = false;
			TraderCompassWidget.SetDisplayInfo(DI);
		}
	}	
    
    if( KeyboardWeaponSelectWidget != None )
	{
		DI = KeyboardWeaponSelectWidget.GetDisplayInfo();
		if( DI.Visible )
		{
			DI.Visible = false;
			KeyboardWeaponSelectWidget.SetDisplayInfo(DI);
		}
	}
}

function DisplayPriorityMessage(string InPrimaryMessageString, string InSecondaryMessageString, int LifeTime, optional KFLocalMessage_Priority.EGameMessageType MessageType)
{
    local KFGameReplicationInfo KFGRI;
    local int ModifierIndex;
    local FPriorityMessage PriorityMsg;
    local KFWeeklyOutbreakInformation WeeklyInfo;
    
    KFGRI = KFGameReplicationInfo(class'WorldInfo'.static.GetWorldInfo().GRI);
    
    PriorityMsg.PrimaryText = InPrimaryMessageString;
    PriorityMsg.SecondaryText = InSecondaryMessageString;
    PriorityMsg.SecondaryAlign = PR_BOTTOM;
    PriorityMsg.LifeTime = LifeTime;
            
    switch ( MessageType )
    {
        case GMT_WaveStartSpecial:
            if( KFGRI.IsSpecialWave(ModifierIndex) )
            {
                PriorityMsg.SecondaryText = Localize("Zeds", SpecialWaveLocKey[ModifierIndex], "KFGame");
                PriorityMsg.Icon = Texture2D(DynamicLoadObject(SpecialWaveIconPath[ModifierIndex], class'Texture2D'));
            }
            break;
        case GMT_WaveStartWeekly:
            if( KFGRI.IsWeeklyWave(ModifierIndex) )
            {
                WeeklyInfo = class'KFMission_LocalizedStrings'.static.GetWeeklyOutbreakInfoByIndex(ModifierIndex);
                
                PriorityMsg.SecondaryText = WeeklyInfo.FriendlyName;
                PriorityMsg.Icon = Texture2D(DynamicLoadObject(WeeklyInfo.IconPath, class'Texture2D'));
            }
            break;
        case GMT_WaveEnd:
            PriorityMsg.Icon = Texture2D'DailyObjective_UI.KF2_Dailies_Icon_ZED';
            break;
        case GMT_WaveStart:
            PriorityMsg.Icon = Texture2D'DailyObjective_UI.KF2_Dailies_Icon_ZED';
            PriorityMsg.SecondaryIcon = Texture2D'UI_Widgets.MenuBarWidget_SWF_I11';
            PriorityMsg.SecondaryText = GetExpandedWaveInfo();
            break;
        case GMT_WaveSBoss:
            PriorityMsg.Icon = Texture2D'DailyObjective_UI.KF2_Dailies_Icon_ZED';
            PriorityMsg.SecondaryText = class'KFGFxHUD_WaveInfo'.default.BossWaveString;
            break;
        case GMT_MatchWon:
            PriorityMsg.Icon = Texture2D'UI_Award_Team.UI_Award_Team-Kills';
            break;        
        case GMT_MatchLost:
            PriorityMsg.Icon = Texture2D'UI_Award_ZEDs.UI_Award_ZED_Kills';
            break;
        case GMT_LastPlayerStanding:
            PriorityMsg.LifeTime *= 1.5f;
            PriorityMsg.Icon = Texture2D'DailyObjective_UI.KF2_Dailies_Icon_ZED';
            break;
    }
                    
    ClassicKFHUD(KFPC.myHUD).ShowPriorityMessage(PriorityMsg);
}

function string GetExpandedWaveInfo()
{
	local KFGameReplicationInfo KFGRI;
    local int Wave;
    
    KFGRI = KFGameReplicationInfo(KFPC.WorldInfo.GRI);
    if( KFPC.WorldInfo.NetMode == NM_StandAlone )
        Wave = KFGRI.WaveNum;
    else Wave = KFGRI.WaveNum+1;

    if (KFGRI.default.bEndlessMode)
        return class'KFGFxHUD_WaveInfo'.default.WaveString@string(KFGRI.WaveNum+1);
    else
    {
        if( Wave == KFGRI.GetFinalWaveNum() )
            return class'KFGFxHUD_WaveInfo'.default.FinalWaveString;
        else return class'KFGFxHUD_WaveInfo'.default.WaveString@Wave$"/"$KFGRI.GetFinalWaveNum();
    }

    return "";
}

function ShowKillMessage(PlayerReplicationInfo PRI1, PlayerReplicationInfo PRI2, optional bool bDeathMessage=false, optional Object OptionalObject)
{
    local bool bHumanDeath;
    local string KilledName, KillerName;
    local class<KFPawn_Monster> KFPM;

    if(KFPC == none)
        return;

    KFPM = class<KFPawn_Monster>(OptionalObject);

    if(bDeathMessage)
    {
        if(KFPM != none)
            KillerName=KFPM.static.GetLocalizedName();
    }
    else
    {
        if(KFPM != none)
        {
            KilledName=KFPM.static.GetLocalizedName();
            bHumanDeath=false;
        }
        else if(PRI1 != none)
            KillerName=PRI1.PlayerName;
    }

    if(PRI2 != none)
    {
        if(PRI2.GetTeamNum() == class'KFTeamInfo_Human'.default.TeamIndex)
            bHumanDeath=true;
        else bHumanDeath=false;
        KilledName=PRI2.PlayerName;
    }

    ClassicKFHUD(KFPC.myHUD).ShowKillMessage(PRI1, PRI2, bHumanDeath, KilledName, KillerName);
}

DefaultProperties
{
    WidgetBindings.Remove((WidgetName="PlayerStatWidgetMC",WidgetClass=class'KFGFxHUD_PlayerStatus'))
    WidgetBindings.Add((WidgetName="PlayerStatWidgetMC",WidgetClass=class'KF1HUD_PlayerStatus'))
    
    WidgetBindings.Remove((WidgetName="WeaponSelectContainer",WidgetClass=class'KFGFxHUD_WeaponSelectWidget'))
    WidgetBindings.Add((WidgetName="WeaponSelectContainer",WidgetClass=class'KF1HUD_WeaponSelectWidget'))
    
    WidgetBindings.Remove((WidgetName="MusicNotification", WidgetClass=class'KFGFxWidget_MusicNotification'))
    WidgetBindings.Add((WidgetName="MusicNotification", WidgetClass=class'KF1HUD_MusicNotification'))
    
    WidgetBindings.Remove((WidgetName="ChatBoxWidget", WidgetClass=class'KFGFxHUD_ChatBoxWidget'))
    WidgetBindings.Add((WidgetName="ChatBoxWidget", WidgetClass=class'KF1HUD_ChatBoxWidget'))
}