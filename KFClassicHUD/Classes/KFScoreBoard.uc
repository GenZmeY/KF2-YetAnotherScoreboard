class KFScoreBoard extends KFGUI_Page;

var transient float PerkXPos, PlayerXPos, StateXPos, TimeXPos, HealXPos, KillsXPos, AssistXPos, CashXPos, DeathXPos, PingXPos;
var transient float NextScoreboardRefresh;

var int PlayerIndex;
var KFGUI_List PlayersList;
var Texture2D DefaultAvatar;

var KFGameReplicationInfo KFGRI;
var array<KFPlayerReplicationInfo> KFPRIArray;

var KFPlayerController OwnerPC;

var Color PingColor;
var float PingBars,IdealPing,MaxPing;

function InitMenu()
{
    Super.InitMenu();
    PlayersList = KFGUI_List(FindComponentID('PlayerList'));
    OwnerPC = KFPlayerController(GetPlayer());
}

static function CheckAvatar(KFPlayerReplicationInfo KFPRI, KFPlayerController PC)
{
    local Texture2D Avatar;
    
    if( KFPRI.Avatar == None || KFPRI.Avatar == default.DefaultAvatar )
    {
        Avatar = FindAvatar(PC, KFPRI.UniqueId);
        if( Avatar == None )
            Avatar = default.DefaultAvatar;
            
        KFPRI.Avatar = Avatar;
    }
}

delegate bool InOrder( KFPlayerReplicationInfo P1, KFPlayerReplicationInfo P2 )
{
    if( P1 == None || P2 == None )
        return true;
        
    if( P1.GetTeamNum() < P2.GetTeamNum() )
        return false;
        
    if( P1.Kills == P2.Kills )
    {
        if( P1.Assists == P2.Assists )
            return true;
            
        return P1.Assists < P2.Assists;
    }
        
    return P1.Kills < P2.Kills;
}

function DrawMenu()
{
    local string S;
    local PlayerController PC;
    local KFPlayerReplicationInfo KFPRI;
    local PlayerReplicationInfo PRI;
    local float XPos, YPos, YL, XL, FontScalar, XPosCenter, DefFontHeight, BoxW, BoxX;
    local int i, j, NumSpec, NumPlayer, NumAlivePlayer, Width;

    PC = GetPlayer();
    if( KFGRI==None )
    {
        KFGRI = KFGameReplicationInfo(PC.WorldInfo.GRI);
        if( KFGRI==None )
            return;
    }
    
    // Sort player list.
    if( NextScoreboardRefresh < PC.WorldInfo.TimeSeconds )
    {
        NextScoreboardRefresh = PC.WorldInfo.TimeSeconds + 0.1;
        
        for( i=(KFGRI.PRIArray.Length-1); i>0; --i )
        {
            for( j=i-1; j>=0; --j )
            {
                if( !InOrder(KFPlayerReplicationInfo(KFGRI.PRIArray[i]),KFPlayerReplicationInfo(KFGRI.PRIArray[j])) )
                {
                    PRI = KFGRI.PRIArray[i];
                    KFGRI.PRIArray[i] = KFGRI.PRIArray[j];
                    KFGRI.PRIArray[j] = PRI;
                }
            }
        }
    }

    // Check players.
    PlayerIndex = -1;
    NumPlayer = 0;
    for( i=(KFGRI.PRIArray.Length-1); i>=0; --i )
    {
        KFPRI = KFPlayerReplicationInfo(KFGRI.PRIArray[i]);
        if( KFPRI==None )
            continue;
        if( KFPRI.bOnlySpectator )
        {
            ++NumSpec;
            continue;
        }
        if( KFPRI.PlayerHealth>0 && KFPRI.PlayerHealthPercent>0 && KFPRI.GetTeamNum()==0 )
            ++NumAlivePlayer;
        ++NumPlayer;
    }
    
    KFPRIArray.Length = NumPlayer;
    j = KFPRIArray.Length;
    for( i=(KFGRI.PRIArray.Length-1); i>=0; --i )
    {
        KFPRI = KFPlayerReplicationInfo(KFGRI.PRIArray[i]);
        if( KFPRI!=None && !KFPRI.bOnlySpectator )
        {
            KFPRIArray[--j] = KFPRI;
            if( KFPRI==PC.PlayerReplicationInfo )
                PlayerIndex = j;
        }
    }

    // Header font info.
    Canvas.Font = Owner.CurrentStyle.PickFont(FontScalar);
    YL = Owner.CurrentStyle.DefaultHeight;
    DefFontHeight = YL;

    XPosCenter = (Canvas.ClipX * 0.5);
    
    // Server Name
    
    XPos = XPosCenter;
    YPos += DefFontHeight;
    
    S = KFGRI.ServerName;
    Canvas.TextSize(S, XL, YL, FontScalar, FontScalar);
    
    BoxW = XL + (Owner.HUDOwner.ScaledBorderSize*4);
    BoxX = XPos - (BoxW * 0.5);
    Canvas.SetDrawColor(10, 10, 10, 200);
    Owner.CurrentStyle.DrawRectBox(BoxX, YPos, BoxW, DefFontHeight, 4);
    Canvas.SetDrawColor(250, 0, 0, 255);
    
    Owner.CurrentStyle.DrawTextShadow(S, BoxX + ((BoxW-XL) * 0.5f), YPos + ((DefFontHeight-YL) * 0.5f), 1, FontScalar);

    // Deficulty | Wave | MapName

    XPos = XPosCenter;
    YPos += DefFontHeight+Owner.HUDOwner.ScaledBorderSize;

    S = Class'KFCommon_LocalizedStrings'.Static.GetDifficultyString (KFGRI.GameDifficulty) $"  |  "$class'KFGFxHUD_ScoreboardMapInfoContainer'.default.WaveString@KFGRI.WaveNum $"  |  " $class'KFCommon_LocalizedStrings'.static.GetFriendlyMapName(PC.WorldInfo.GetMapName(true));
    Canvas.TextSize(S, XL, YL, FontScalar, FontScalar);
    
    BoxW = XL + (Owner.HUDOwner.ScaledBorderSize*4);
    BoxX = XPos - (BoxW * 0.5);
    Canvas.SetDrawColor(10, 10, 10, 200);
    Owner.CurrentStyle.DrawRectBox(BoxX, YPos, BoxW, DefFontHeight, 4);
    Canvas.SetDrawColor(0, 250, 0, 255);
    
    Owner.CurrentStyle.DrawTextShadow(S, BoxX + ((BoxW-XL) * 0.5f), YPos + ((DefFontHeight-YL) * 0.5f), 1, FontScalar);
    
    // Players | Spectators | Alive | Time

    XPos = XPosCenter;
    YPos += DefFontHeight+Owner.HUDOwner.ScaledBorderSize;
    
    S = " Players : " $ NumPlayer $ "  |  Spectators : " $ NumSpec $ "  |  Alive : " $ NumAlivePlayer $ "  |  Elapsed Time : " $ Owner.CurrentStyle.GetTimeString(KFGRI.ElapsedTime) $ " ";
    Canvas.TextSize(S, XL, YL, FontScalar, FontScalar);
    
    BoxW = XL + (Owner.HUDOwner.ScaledBorderSize*4);
    BoxX = XPos - (BoxW * 0.5);
    Canvas.SetDrawColor(10, 10, 10, 200);
    Owner.CurrentStyle.DrawRectBox(BoxX, YPos, BoxW, DefFontHeight, 4);
    Canvas.SetDrawColor(250, 250, 0, 255);
    
    Owner.CurrentStyle.DrawTextShadow(S, BoxX + ((BoxW-XL) * 0.5f), YPos + ((DefFontHeight-YL) * 0.5f), 1, FontScalar);
    
    Width = Canvas.ClipX * 0.625;

    XPos = (Canvas.ClipX - Width) * 0.5;
    YPos += DefFontHeight * 2.0;
    
    Canvas.SetDrawColor (10, 10, 10, 200);
    Owner.CurrentStyle.DrawRectBox(XPos, YPos, Width, DefFontHeight, 4);

    Canvas.SetDrawColor(250, 250, 250, 255);

    // Calc X offsets
    PerkXPos = Width * 0.01;
    PlayerXPos = Width * 0.2;
    KillsXPos = Width * 0.5;
    AssistXPos = Width * 0.6;
    CashXPos = Width * 0.7;
    StateXPos = Width * 0.8;
    PingXPos = Width * 0.92;

    // Header texts
    Canvas.SetPos (XPos + PerkXPos, YPos);
    Canvas.DrawText (class'KFGFxMenu_Inventory'.default.PerkFilterString, , FontScalar, FontScalar);

    Canvas.SetPos (XPos + KillsXPos, YPos);
    Canvas.DrawText (class'KFGFxHUD_ScoreboardWidget'.default.KillsString, , FontScalar, FontScalar);

    Canvas.SetPos (XPos + AssistXPos, YPos);
    Canvas.DrawText (class'KFGFxHUD_ScoreboardWidget'.default.AssistsString, , FontScalar, FontScalar);

    Canvas.SetPos (XPos + CashXPos, YPos);
    Canvas.DrawText (class'KFGFxHUD_ScoreboardWidget'.default.DoshString, , FontScalar, FontScalar);

    Canvas.SetPos (XPos + StateXPos, YPos);
    Canvas.DrawText ("STATE", , FontScalar, FontScalar);
    
    Canvas.SetPos (XPos + PlayerXPos, YPos);
    Canvas.DrawText (class'KFGFxHUD_ScoreboardWidget'.default.PlayerString, , FontScalar, FontScalar);

    Canvas.SetPos (XPos + PingXPos, YPos);
    Canvas.DrawText (class'KFGFxHUD_ScoreboardWidget'.default.PingString, , FontScalar, FontScalar);

    PlayersList.XPosition = ((Canvas.ClipX - Width) * 0.5) / InputPos[2];
    PlayersList.YPosition = (YPos + (YL + 4)) / InputPos[3];
    PlayersList.YSize = (1.f - PlayersList.YPosition) - 0.15;
    
    PlayersList.ChangeListSize(KFPRIArray.Length);
}

function DrawPlayerEntry( Canvas C, int Index, float YOffset, float Height, float Width, bool bFocus )
{
    local string S, StrValue;
    local float FontScalar, TextYOffset, XL, YL, PerkIconPosX, PerkIconPosY, PerkIconSize, PrestigeIconScale;
    local KFPlayerReplicationInfo KFPRI;
    local byte Level, PrestigeLevel;
    local bool bIsZED;
    local int Ping;
    
    YOffset *= 1.05;
    KFPRI = KFPRIArray[Index];
    
    if( KFGRI.bVersusGame )
        bIsZED = KFTeamInfo_Zeds(KFPRI.Team) != None;
    
    C.Font = Owner.CurrentStyle.PickFont(FontScalar);
    
    TextYOffset = YOffset + (Height * 0.5f) - (Owner.CurrentStyle.DefaultHeight * 0.5f);
    if (PlayerIndex == Index)
        C.SetDrawColor (51, 30, 101, 150);
    else C.SetDrawColor (30, 30, 30, 150);
    
    Owner.CurrentStyle.DrawRectBox(0.f, YOffset, Width, Height, 4);
    
    C.SetDrawColor(250,250,250,255);

    // Perk
    if( bIsZED )
    {
        C.SetDrawColor(255,0,0,255);
        C.SetPos (PerkXPos, YOffset - ((Height-5) * 0.5f));
        C.DrawRect (Height-5, Height-5, Texture2D'UI_Widgets.MenuBarWidget_SWF_IF');
        
        S = "ZED";
        C.SetPos (PerkXPos + Height, TextYOffset);
        C.DrawText (S, , FontScalar, FontScalar);
    }
    else
    {
        if( KFPRI.CurrentPerkClass!=None )
        {
			PrestigeLevel = KFPRI.GetActivePerkPrestigeLevel();
			Level = KFPRI.GetActivePerkLevel();
			
			PerkIconPosX = PerkXPos;
			PerkIconPosY = YOffset + (Owner.HUDOwner.ScaledBorderSize * 2);
			PerkIconSize = Height-(Owner.HUDOwner.ScaledBorderSize * 4);
			PrestigeIconScale = 0.6625f;
			
            C.DrawColor = HUDOwner.WhiteColor;
			if (PrestigeLevel > 0)
			{
				C.SetPos(PerkIconPosX, PerkIconPosY);
				C.DrawTile(KFPRI.CurrentPerkClass.default.PrestigeIcons[PrestigeLevel - 1], PerkIconSize, PerkIconSize, 0, 0, 256, 256);
				
				C.SetPos(PerkIconPosX + ((PerkIconSize/2) - ((PerkIconSize*PrestigeIconScale)/2)), PerkIconPosY + ((PerkIconSize/2) - ((PerkIconSize*PrestigeIconScale)/1.75)));
				C.DrawTile(KFPRI.CurrentPerkClass.default.PerkIcon, PerkIconSize * PrestigeIconScale, PerkIconSize * PrestigeIconScale, 0, 0, 256, 256);
			}
			else
			{
				C.SetPos(PerkIconPosX, PerkIconPosY);
				C.DrawTile(KFPRI.CurrentPerkClass.default.PerkIcon, PerkIconSize, PerkIconSize, 0, 0, 256, 256);
			}		
			
			C.SetDrawColor(250,250,250,255);
			C.SetPos(PerkIconPosX + PerkIconSize + (Owner.HUDOwner.ScaledBorderSize*2), TextYOffset);
			C.DrawText(Level@KFPRI.CurrentPerkClass.default.PerkName, , FontScalar, FontScalar);
        }
        else
        {
            C.SetDrawColor(250,250,250,255);
            S = "No Perk";
            C.SetPos (PerkXPos + Height, TextYOffset);
            C.DrawText (S, , FontScalar, FontScalar);
        }
    }
    
    // Avatar
    if( KFPRI.Avatar != None )
    {
        if( KFPRI.Avatar == default.DefaultAvatar )
            CheckAvatar(KFPRI, OwnerPC);
            
        C.SetDrawColor(255,255,255,255);
        C.SetPos(PlayerXPos - (Height * 1.075), YOffset + (Height * 0.5f) - ((Height - 6) * 0.5f));
        C.DrawTile(KFPRI.Avatar,Height - 6,Height - 6,0,0,KFPRI.Avatar.SizeX,KFPRI.Avatar.SizeY);
        Owner.CurrentStyle.DrawBoxHollow(PlayerXPos - (Height * 1.075), YOffset + (Height * 0.5f) - ((Height - 6) * 0.5f), Height - 6, Height - 6, 1);
    } 
    else if( !KFPRI.bBot )
        CheckAvatar(KFPRI, OwnerPC);

    // Player
    C.SetPos (PlayerXPos, TextYOffset);
    
    if( Len(KFPRI.PlayerName) > 25 )
        S = Left(KFPRI.PlayerName, 25);
    else S = KFPRI.PlayerName;
    C.DrawText (S, , FontScalar, FontScalar);
    
    C.SetDrawColor(255,255,255,255);

    // Kill
    C.SetPos (KillsXPos, TextYOffset);
    C.DrawText (string (KFPRI.Kills), , FontScalar, FontScalar);

    // Assist
    C.SetPos (AssistXPos, TextYOffset);
    C.DrawText (string (KFPRI.Assists), , FontScalar, FontScalar);

    // Cash
    C.SetPos (CashXPos, TextYOffset);
    if( bIsZED )
    {
        C.SetDrawColor(250, 0, 0, 255);
        StrValue = "Brains!";
    }
    else
    {
        C.SetDrawColor(250, 250, 100, 255);
        StrValue = "£"$GetNiceSize(int(KFPRI.Score));
    }
    C.DrawText (StrValue, , FontScalar, FontScalar);
    
    C.SetDrawColor(255,255,255,255);

    // State
    if( !KFPRI.bReadyToPlay && KFGRI.bMatchHasBegun )
    {
        C.SetDrawColor(250,0,0,255);
        S = "LOBBY";
    }
    else if( !KFGRI.bMatchHasBegun )
    {
        C.SetDrawColor(250,0,0,255);
        S = KFPRI.bReadyToPlay ? "Ready" : "Not Ready";    
    }
    else if( bIsZED && KFTeamInfo_Zeds(GetPlayer().PlayerReplicationInfo.Team) == None )
    {
        C.SetDrawColor(250,0,0,255);
        S = "Unknown";
    }
    else if (KFPRI.PlayerHealth <= 0 || KFPRI.PlayerHealthPercent <= 0)
    {
        C.SetDrawColor(250,0,0,255);
        S = (KFPRI.bOnlySpectator) ? "Spectator" : "DEAD";
    }
    else
    {
        if (ByteToFloat(KFPRI.PlayerHealthPercent) >= 0.8)
            C.SetDrawColor(0,250,0,255);
        else if (ByteToFloat(KFPRI.PlayerHealthPercent) >= 0.4)
            C.SetDrawColor(250,250,0,255);
        else C.SetDrawColor(250,100,100,255);
        
        S =  string (KFPRI.PlayerHealth) @"HP";
    }

    C.SetPos (StateXPos, TextYOffset);
    C.DrawText (S, , FontScalar, FontScalar);
    
    C.SetDrawColor(250,250,250,255);

    // Ping
    if (KFPRI.bBot)
        S = "-";
    else
    {
        Ping = int(KFPRI.Ping * `PING_SCALE);
        
        if (Ping <= 100)
            C.SetDrawColor(0,250,0,255);
        else if (Ping <= 200)
            C.SetDrawColor(250,250,0,255);
        else C.SetDrawColor(250,100,100,255);
        
        S = string(Ping);
    }
        
    C.TextSize(MaxPing, XL, YL, FontScalar, FontScalar);
    
    C.SetPos(PingXPos, TextYOffset);
    C.DrawText(S,, FontScalar, FontScalar);
    
    DrawPingBars(C, YOffset + (Height/2) - ((Height*0.5)/2), Width - (Height*0.5) - (Owner.HUDOwner.ScaledBorderSize*2), Height*0.5, Height*0.5, float(Ping));
}

final function DrawPingBars( Canvas C, float YOffset, float XOffset, float W, float H, float Ping )
{
    local float PingMul, BarW, BarH, BaseH, XPos, YPos;
    local byte i;
    
    PingMul = 1.f - FClamp(FMax(Ping - IdealPing, 1.f) / MaxPing, 0.f, 1.f);
    BarW = W / PingBars;
    BaseH = H / PingBars;

    PingColor.R = (1.f - PingMul) * 255;
    PingColor.G = PingMul * 255;

    for(i=1; i<PingBars; i++)
    {
        BarH = BaseH * i;
        XPos = XOffset + ((i - 1) * BarW);
        YPos = YOffset + (H - BarH);

        C.SetPos(XPos,YPos);
        C.SetDrawColor(20, 20, 20, 255);
        Owner.CurrentStyle.DrawWhiteBox(BarW,BarH);

        if( PingMul >= (i / PingBars) )
        {
            C.SetPos(XPos,YPos);
            C.DrawColor = PingColor;
            Owner.CurrentStyle.DrawWhiteBox(BarW,BarH);
        }

        C.SetDrawColor(80, 80, 80, 255);
        Owner.CurrentStyle.DrawBoxHollow(XPos,YPos,BarW,BarH,1);
    }
}

static final function Texture2D FindAvatar( KFPlayerController PC, UniqueNetId ClientID )
{
    local string S;
    
    S = PC.GetSteamAvatar(ClientID);
    if( S=="" )
        return None;
    return Texture2D(PC.FindObject(S,class'Texture2D'));
}

final static function string GetNiceSize(int Num)
{
    if( Num < 1000 ) return string(Num);
    else if( Num < 1000000 ) return (Num / 1000) $ "K";
    else if( Num < 1000000000 ) return (Num / 1000000) $ "M";

    return (Num / 1000000000) $ "B";
}

function ScrollMouseWheel( bool bUp )
{
    PlayersList.ScrollMouseWheel(bUp);
}

defaultproperties
{
    bEnableInputs=true
    
    PingColor=(R=255,G=255,B=60,A=255)
    IdealPing=50.0
    MaxPing=200.0
    PingBars=5.0
    
    Begin Object Class=KFGUI_List Name=PlayerList
        XSize=0.625
        OnDrawItem=DrawPlayerEntry
        ID="PlayerList"
        bClickable=false
        ListItemsPerPage=16
    End Object
    Components.Add(PlayerList)
    
    DefaultAvatar=Texture2D'UI_HUD.ScoreBoard_Standard_SWF_I26'
}