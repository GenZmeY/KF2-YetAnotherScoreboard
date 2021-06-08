class KFScoreBoard extends KFGUI_Page
	dependson(Types);

var transient float RankXPos, PerkXPos, PlayerXPos, HealthXPos, TimeXPos, KillsXPos, AssistXPos, CashXPos, DeathXPos, PingXPos;
var transient float StatusWBox, PlayerWBox, PerkWBox, CashWBox, KillsWBox, AssistWBox, HealthWBox, PingWBox;
var transient float NextScoreboardRefresh;

var int PlayerIndex;
var KFGUI_List PlayersList;
var Texture2D DefaultAvatar;

var KFGameReplicationInfo KFGRI;
var array<KFPlayerReplicationInfo> KFPRIArray;

var KFPlayerController OwnerPC;

var Color PingColor;
var float PingBars,IdealPing,MaxPing;

// Ranks
var array<RankInfo> CustomRanks;
var array<UIDRankRelation> PlayerRankRelations;

var SCESettings Settings;
var SCEStyle    Style;

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

function string WaveText()
{
	local int CurrentWaveNum;
	
	CurrentWaveNum = KFGRI.WaveNum;
    if(KFGRI.IsBossWave())
    {
		return class'KFGFxHUD_WaveInfo'.default.BossWaveString;
    }
	else if (KFGRI.IsFinalWave())
	{
		return class'KFGFxHUD_ScoreboardMapInfoContainer'.default.FinalString;
	}
    else
    {
		if (KFGRI.default.bEndlessMode)
		{
    		return "" $ CurrentWaveNum;
		}
		else
		{
			return CurrentWaveNum $ " / " $ KFGRI.GetFinalWaveNum();
		}
    }
}

function DrawMenu()
{
	local string S;
	local PlayerController PC;
	local KFPlayerReplicationInfo KFPRI;
	local PlayerReplicationInfo PRI;
	local float XPos, YPos, YL, XL, FontScalar, XPosCenter, BoxW, BoxX, BoxH;
	local int i, j, NumSpec, NumPlayer, NumAlivePlayer, Width, Edge;
	local float BorderSize;

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

	Canvas.Font = Owner.CurrentStyle.PickFont(FontScalar);
	Canvas.TextSize("ABC", XL, YL, FontScalar, FontScalar);
	BorderSize = Owner.HUDOwner.ScaledBorderSize;
	Edge = 8;
	
	// Server Info
	XPosCenter = Canvas.ClipX * 0.5;
	Width = Canvas.ClipX * 0.4; // Full Box Width
	XPos = XPosCenter - Width * 0.5;
	YPos = YL;
	
	BoxW = Width;
	BoxX = XPos;
	BoxH = YL + BorderSize;
	
	// Top Rect (Server name)
	SetDrawColor(Canvas, Style.ServerNameBoxColor);
	Owner.CurrentStyle.DrawRectBox(BoxX, YPos, BoxW, BoxH, Edge, 2);
	
	SetDrawColor(Canvas, Style.ServerNameTextColor);
	S = KFGRI.ServerName;
	DrawTextShadowHVCenter(S, BoxX, YPos, BoxW, FontScalar);
	
	YPos += BoxH;
	
	// Mid Left Rect (Info)
	BoxW = Width * 0.7;
	BoxH = YL * 2 + BorderSize * 2;
	SetDrawColor(Canvas, Style.GameInfoBoxColor);
	Owner.CurrentStyle.DrawRectBox(BoxX, YPos, BoxW, BoxH, Edge, 1);
	
	SetDrawColor(Canvas, Style.GameInfoTextColor);
	S = class'KFCommon_LocalizedStrings'.static.GetFriendlyMapName(PC.WorldInfo.GetMapName(true));
	DrawTextShadowHLeftVCenter(S, BoxX + Edge, YPos, FontScalar);
	
	S = KFGRI.GameClass.default.GameName $ " - " $ class'KFCommon_LocalizedStrings'.Static.GetDifficultyString (KFGRI.GameDifficulty);
	DrawTextShadowHLeftVCenter(S, BoxX + Edge, YPos + YL, FontScalar);
	
	// Mid Right Rect (Wave)
	BoxX = BoxX + BoxW;
	BoxW = Width - BoxW;
	SetDrawColor(Canvas, Style.WaveBoxColor);
	Owner.CurrentStyle.DrawRectBox(BoxX, YPos, BoxW, BoxH, Edge, 0);
	
	SetDrawColor(Canvas, Style.WaveTextColor);
	S = class'KFGFxHUD_ScoreboardMapInfoContainer'.default.WaveString; 
	DrawTextShadowHVCenter(S, BoxX, YPos, BoxW, FontScalar);
	DrawTextShadowHVCenter(WaveText(), BoxX, YPos + YL, BoxW, FontScalar);
	
	YPos += BoxH;
	
	// Bottom Rect (Players count)
	BoxX = XPos;
	BoxW = Width;
	BoxH = YL + BorderSize;
	SetDrawColor(Canvas, Style.PlayerCountBoxColor);
	Owner.CurrentStyle.DrawRectBox(BoxX, YPos, BoxW, BoxH, Edge, 4);
	
	SetDrawColor(Canvas, Style.PlayerCountTextColor);
	S = "Players: " $ NumPlayer $ " / " $ KFGRI.MaxHumanCount $ "    " $ "Spectators: " $ NumSpec; 
	Canvas.TextSize(S, XL, YL, FontScalar, FontScalar);
	DrawTextShadowHLeftVCenter(S, BoxX + Edge, YPos, FontScalar);
	
	S = Owner.CurrentStyle.GetTimeString(KFGRI.ElapsedTime);
	DrawTextShadowHVCenter(S, XPos + Width * 0.7, YPos, Width * 0.3, FontScalar);
	
	// TODO: ranked / unranked
	//if (KFGameInfo(PC.WorldInfo.Game).IsUnrankedGame())
	//	S = class'KFGFxMenu_ServerBrowser'.default.UnrankedString;
	//else
	//	S = class'KFGFxMenu_ServerBrowser'.default.RankedString;
	//DrawTextShadowHVCenter(S, XPos + XL, YPos, Width * 0.7 + XL, FontScalar);
	
	YPos += BoxH;

	// Header
	Width = Canvas.ClipX * 0.625;
	XPos = (Canvas.ClipX - Width) * 0.5;
	YPos += YL;
	BoxH = YL + BorderSize;
	SetDrawColor(Canvas, Style.ListHeaderBoxColor);
		Owner.CurrentStyle.DrawRectBox(
		XPos - BorderSize * 2,
		YPos,
		Width + BorderSize * 4,
		BoxH,
		Edge,
		2);

	// Calc X offsets
	RankXPos   = Owner.HUDOwner.ScaledBorderSize * 8 + Edge;
	PlayerXPos = Width * 0.20;
	PerkXPos   = Width * 0.40;
	CashXPos   = Width * 0.57;
	KillsXPos  = Width * 0.66;
	AssistXPos = Width * 0.75;
	HealthXPos = Width * 0.84;
	PingXPos   = Width * 0.93;

	StatusWBox = PlayerXPos - RankXPos;
	PlayerWBox = PerkXPos   - PlayerXPos;
	PerkWBox   = CashXPos   - PerkXPos;
	CashWBox   = KillsXPos  - CashXPos;
	KillsWBox  = AssistXPos - KillsXPos;
	AssistWBox = HealthXPos - AssistXPos;
	HealthWBox = PingXPos   - HealthXPos;
	PingWBox   = Width	    - PingXPos;

	// Header texts
	SetDrawColor(Canvas, Style.ListHeaderTextColor);
	DrawTextShadowHLeftVCenter("RANK", XPos + RankXPos, YPos, FontScalar);
	DrawTextShadowHLeftVCenter(class'KFGFxHUD_ScoreboardWidget'.default.PlayerString, XPos + PlayerXPos, YPos, FontScalar);
	DrawTextShadowHLeftVCenter(class'KFGFxMenu_Inventory'.default.PerkFilterString, XPos + PerkXPos, YPos, FontScalar);
	DrawTextShadowHVCenter(class'KFGFxHUD_ScoreboardWidget'.default.KillsString, XPos + KillsXPos, YPos, KillsWBox, FontScalar);
	DrawTextShadowHVCenter(class'KFGFxHUD_ScoreboardWidget'.default.AssistsString, XPos + AssistXPos, YPos, AssistWBox, FontScalar);
	DrawTextShadowHVCenter(class'KFGFxHUD_ScoreboardWidget'.default.DoshString, XPos + CashXPos, YPos, CashWBox, FontScalar);
	DrawTextShadowHVCenter("HEALTH", XPos + HealthXPos, YPos, HealthWBox, FontScalar);
	DrawTextShadowHVCenter(class'KFGFxHUD_ScoreboardWidget'.default.PingString, XPos + PingXPos, YPos, PingWBox, FontScalar);

	PlayersList.XPosition = ((Canvas.ClipX - Width) * 0.5) / InputPos[2];
	PlayersList.YPosition = (YPos + YL + BorderSize * 4) / InputPos[3];
	PlayersList.YSize = (1.f - PlayersList.YPosition) - 0.15;

	PlayersList.ChangeListSize(KFPRIArray.Length);
}

function DrawTextShadowHVCenter(string Str, float XPos, float YPos, float BoxWidth, float FontScalar)
{
	local float TextWidth;
	local float TextHeight;

	Canvas.TextSize(Str, TextWidth, TextHeight, FontScalar, FontScalar);

	Owner.CurrentStyle.DrawTextShadow(Str, XPos + (BoxWidth - TextWidth)/2 , YPos, 1, FontScalar);
}

function DrawTextShadowHLeftVCenter(string Str, float XPos, float YPos, float FontScalar)
{
	Owner.CurrentStyle.DrawTextShadow(Str, XPos, YPos, 1, FontScalar);
}

function DrawTextShadowHRightVCenter(string Str, float XPos, float YPos, float BoxWidth, float FontScalar)
{
	local float TextWidth;
	local float TextHeight;

	Canvas.TextSize(Str, TextWidth, TextHeight, FontScalar, FontScalar);
	
	Owner.CurrentStyle.DrawTextShadow(Str, XPos + BoxWidth - TextWidth, YPos, 1, FontScalar);
}

function SetDrawColor(Canvas C, ColorRGBA Color)
{
	C.SetDrawColor(Color.R, Color.G, Color.B, Color.A);
}

function DrawPlayerEntry( Canvas C, int Index, float YOffset, float Height, float Width, bool bFocus )
{
	local string S, StrValue;
	local float FontScalar, TextYOffset, XL, YL, PerkIconPosX, PerkIconPosY, PerkIconSize, PrestigeIconScale;
	local float XPos, BoxWidth;
	local KFPlayerReplicationInfo KFPRI;
	local byte Level, PrestigeLevel;
	local bool bIsZED;
	local int Ping;
	
	local RankInfo CurrentRank;
	local bool HasRank;
	local int PlayerInfoIndex, PlayerRankIndex;

	YOffset *= 1.05;
	KFPRI = KFPRIArray[Index];
	
	HasRank = false;
	PlayerInfoIndex = PlayerRankRelations.Find('UID', KFPRI.UniqueId);
	if (PlayerInfoIndex != INDEX_NONE )
	{
		PlayerRankIndex = CustomRanks.Find('ID', PlayerRankRelations[PlayerInfoIndex].RankID);
		if (PlayerRankIndex != INDEX_NONE)
		{
			HasRank = true;
			CurrentRank = CustomRanks[PlayerRankIndex];
		}
	}
	
	if (KFPRI.bAdmin)
	{
		if (!HasRank || (HasRank && !CurrentRank.OverrideAdminRank))
		{
			CurrentRank.Rank = SystemAdminRank;
			CurrentRank.TextColor = SystemAdminColor;
			CurrentRank.ApplyColorToFields = SystemAdminApplyColorToFields;
			HasRank = true;
		}
	}
	else // Player
	{
		if (!HasRank)
		{
			CurrentRank.Rank = SystemPlayerRank;
			CurrentRank.TextColor = SystemPlayerColor;
			CurrentRank.ApplyColorToFields = SystemPlayerApplyColorToFields;
			HasRank = true;
		}
	}
	// Now all players belongs to 'Rank'

	if( KFGRI.bVersusGame )
		bIsZED = KFTeamInfo_Zeds(KFPRI.Team) != None;

	XPos = 0.f;

	C.Font = Owner.CurrentStyle.PickFont(FontScalar);

	Canvas.TextSize("ABC", XL, YL, FontScalar, FontScalar);
	
	// change rect color by HP
	if( !KFPRI.bReadyToPlay && KFGRI.bMatchHasBegun )
	{
		SetDrawColor(C, Style.LeftHPBoxColorNone);
	}
	else if ( !KFGRI.bMatchHasBegun )
	{
		SetDrawColor(C, Style.LeftHPBoxColorNone);
	}
	else if( bIsZED && KFTeamInfo_Zeds(GetPlayer().PlayerReplicationInfo.Team) == None )
	{
		SetDrawColor(C, Style.LeftHPBoxColorNone);
	}
	else if (KFPRI.PlayerHealth <= 0 || KFPRI.PlayerHealthPercent <= 0)
	{
		SetDrawColor(C, Style.LeftHPBoxColorDead);
	}
	else
	{
		if (ByteToFloat(KFPRI.PlayerHealthPercent) >= float(Settings.HP_High) / 100.0)
			SetDrawColor(C, Style.LeftHPBoxColorHigh);
		else if (ByteToFloat(KFPRI.PlayerHealthPercent) >= float(Settings.HP_Low) / 100.0)
			SetDrawColor(C, Style.LeftHPBoxColorMid);
		else
			SetDrawColor(C, Style.LeftHPBoxColorLow);
	}
	
	BoxWidth = Owner.HUDOwner.ScaledBorderSize * 8;
	Owner.CurrentStyle.DrawRectBox(
		XPos,
		YOffset,
		BoxWidth,
		Height,
		8, 1);
		
	XPos += BoxWidth;
	
	TextYOffset = YOffset + (Height * 0.5f) - (YL * 0.5f);
	if (PlayerIndex == Index)
		SetDrawColor(C, Style.PlayerOwnerBoxColor);
	else
		SetDrawColor(C, Style.PlayerBoxColor);

	BoxWidth = CashXPos + Owner.HUDOwner.ScaledBorderSize - BoxWidth;
	Owner.CurrentStyle.DrawRectBox(XPos, YOffset, BoxWidth, Height, 8);
	
	XPos += BoxWidth;
	
	// Right stats box
	BoxWidth = Width - XPos;
	SetDrawColor(C, Style.StatsBoxColor);
	Owner.CurrentStyle.DrawRectBox(
		XPos,
		YOffset,
		BoxWidth,
		Height,
		8, 3);

	// Rank
	if (CurrentRank.ApplyColorToFields.Rank)
		SetDrawColor(C, CurrentRank.TextColor);
	else
		SetDrawColor(C, Style.RankTextColor);
	S = CurrentRank.Rank;
	DrawTextShadowHLeftVCenter(S, RankXPos, TextYOffset, FontScalar);

	// Perk
	if( bIsZED )
	{
		if (CurrentRank.ApplyColorToFields.Perk)
			SetDrawColor(C, CurrentRank.TextColor);
		else
			SetDrawColor(C, Style.ZedTextColor);
		C.SetPos (PerkXPos, YOffset - ((Height-5) * 0.5f));
		C.DrawRect (Height-5, Height-5, Texture2D'UI_Widgets.MenuBarWidget_SWF_IF');

		S = "ZED";
		DrawTextShadowHLeftVCenter(S, PerkXPos + Height, TextYOffset, FontScalar);
	}
	else
	{
		if( KFPRI.CurrentPerkClass!=None )
		{
			PrestigeLevel = KFPRI.GetActivePerkPrestigeLevel();
			Level = KFPRI.GetActivePerkLevel();

			PerkIconPosY = YOffset + (Owner.HUDOwner.ScaledBorderSize * 2);
			PerkIconSize = Height-(Owner.HUDOwner.ScaledBorderSize * 4);
			PerkIconPosX = PerkXPos - PerkIconSize - (Owner.HUDOwner.ScaledBorderSize*2);
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

			if (CurrentRank.ApplyColorToFields.Perk)
				SetDrawColor(C, CurrentRank.TextColor);
			else
				SetDrawColor(C, Style.PerkTextColor); // TODO: LevelTextColor
			S = Level@KFPRI.CurrentPerkClass.default.PerkName;
			DrawTextShadowHLeftVCenter(S, PerkXPos, TextYOffset, FontScalar);
		}
		else
		{
			if (CurrentRank.ApplyColorToFields.Perk)
				SetDrawColor(C, CurrentRank.TextColor);
			else
				SetDrawColor(C, Style.PerkTextColor);
			S = "No Perk";
			DrawTextShadowHLeftVCenter(S, PerkXPos, TextYOffset, FontScalar);
		}
	}

	// Avatar
	if( KFPRI.Avatar != None )
	{
		if( KFPRI.Avatar == default.DefaultAvatar )
			CheckAvatar(KFPRI, OwnerPC);

		SetDrawColor(C, Style.AvatarBorderColor); // Check
		C.SetPos(PlayerXPos - (Height * 1.075), YOffset + (Height * 0.5f) - ((Height - 6) * 0.5f));
		C.DrawTile(KFPRI.Avatar,Height - 6,Height - 6,0,0,KFPRI.Avatar.SizeX,KFPRI.Avatar.SizeY);
		Owner.CurrentStyle.DrawBoxHollow(PlayerXPos - (Height * 1.075), YOffset + (Height * 0.5f) - ((Height - 6) * 0.5f), Height - 6, Height - 6, 1);
	}
	else if( !KFPRI.bBot )
		CheckAvatar(KFPRI, OwnerPC);

	// Player
	if (CurrentRank.ApplyColorToFields.Player)
		SetDrawColor(C, CurrentRank.TextColor);
	else
		SetDrawColor(C, Style.PlayerNameTextColor);
	if( Len(KFPRI.PlayerName) > 25 )
		S = Left(KFPRI.PlayerName, 25);
	else S = KFPRI.PlayerName;
	DrawTextShadowHLeftVCenter(S, PlayerXPos, TextYOffset, FontScalar);

	// Kill
	if (CurrentRank.ApplyColorToFields.Kills)
		SetDrawColor(C, CurrentRank.TextColor);
	else
		SetDrawColor(C, Style.KillsTextColor);
	DrawTextShadowHVCenter(string (KFPRI.Kills), KillsXPos, TextYOffset, KillsWBox, FontScalar);

	// Assist
	if (CurrentRank.ApplyColorToFields.Assists)
		SetDrawColor(C, CurrentRank.TextColor);
	else
		SetDrawColor(C, Style.AssistsTextColor);
	DrawTextShadowHVCenter(string (KFPRI.Assists), AssistXPos, TextYOffset, AssistWBox, FontScalar);
	
	// Cash
	if( bIsZED )
	{
		SetDrawColor(C, Style.ZedTextColor);
		StrValue = "Brains!";
	}
	else
	{
		if (CurrentRank.ApplyColorToFields.Dosh)
			SetDrawColor(C, CurrentRank.TextColor);
		else
			SetDrawColor(C, Style.DoshTextColor);
		StrValue = GetNiceSize(int(KFPRI.Score));
	}
	DrawTextShadowHVCenter(StrValue, CashXPos, TextYOffset, CashWBox, FontScalar);

	// State
	if( !KFPRI.bReadyToPlay && KFGRI.bMatchHasBegun )
	{
		SetDrawColor(C, Style.StateTextColorLobby);
		S = "LOBBY";
	}
	else if( !KFGRI.bMatchHasBegun )
	{
		if (KFPRI.bReadyToPlay)
		{
			SetDrawColor(C, Style.StateTextColorReady);
			S = "Ready";
		}
		else
		{
			SetDrawColor(C, Style.StateTextColorNotReady);
			S = "Not Ready";	
		}
	}
	else if( bIsZED && KFTeamInfo_Zeds(GetPlayer().PlayerReplicationInfo.Team) == None )
	{
		SetDrawColor(C, Style.StateTextColorNone);
		S = "Unknown";
	}
	else if (KFPRI.PlayerHealth <= 0 || KFPRI.PlayerHealthPercent <= 0)
	{
		if (KFPRI.bOnlySpectator)
		{
			SetDrawColor(C, Style.StateTextColorSpectator);
			S = "Spectator";
		}
		else
		{
			SetDrawColor(C, Style.StateTextColorDead);
			S = "DEAD";
		}
	}
	else
	{
		if (ByteToFloat(KFPRI.PlayerHealthPercent) >= float(Settings.HP_High) / 100.0)
			SetDrawColor(C, Style.StateTextColorHighHP);
		else if (ByteToFloat(KFPRI.PlayerHealthPercent) >= float(Settings.HP_Low) / 100.0)
			SetDrawColor(C, Style.StateTextColorMidHP);
		else
			SetDrawColor(C, Style.StateTextColorLowHP);
		S =  string (KFPRI.PlayerHealth) @"HP";
	}
	
	if (CurrentRank.ApplyColorToFields.Health)
		SetDrawColor(C, CurrentRank.TextColor);
	DrawTextShadowHVCenter(S, HealthXPos, TextYOffset, HealthWBox, FontScalar);

	// Ping
	if (KFPRI.bBot)
	{
		SetDrawColor(C, Style.PingTextColorNone);
		S = "-";
	}
	else
	{
		Ping = int(KFPRI.Ping * `PING_SCALE);

		if (CurrentRank.ApplyColorToFields.Ping)
			SetDrawColor(C, CurrentRank.TextColor);
		else if (Ping <= Settings.Ping_Low)
			SetDrawColor(C, Style.PingTextColorLow);
		else if (Ping <= Settings.Ping_High)
			SetDrawColor(C, Style.PingTextColorMid);
		else
			SetDrawColor(C, Style.PingTextColorHigh);

		S = string(Ping);
	}

	C.TextSize(MaxPing, XL, YL, FontScalar, FontScalar);
	DrawTextShadowHVCenter(S, PingXPos, TextYOffset, PingWBox/2, FontScalar);
	C.SetDrawColor(250,250,250,255);

	DrawPingBars(C, YOffset + (Height/2) - ((Height*0.5)/2), Width - (Height*0.5) - (Owner.HUDOwner.ScaledBorderSize*2), Height*0.5, Height*0.5, float(Ping));
}

final function DrawPingBars( Canvas C, float YOffset, float XOffset, float W, float H, float Ping )
{
	local float PingMul, BarW, BarH, BaseH, XPos, YPos;
	local byte i;

	PingMul = 1.f - FClamp(FMax(Ping - Settings.Ping_Low, 1.f) / Settings.Ping_High, 0.f, 1.f);
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