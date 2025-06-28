// This file is part of Yet Another Scoreboard.
// Yet Another Scoreboard - a mutator for Killing Floor 2.
//
// Copyright (C) 2021-2024 GenZmeY (mailto: genzmey@gmail.com)
//
// Yet Another Scoreboard is free software: you can redistribute it
// and/or modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation,
// either version 3 of the License, or (at your option) any later version.
//
// Yet Another Scoreboard is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with Yet Another Scoreboard. If not, see <https://www.gnu.org/licenses/>.

class YAS extends Info
	config(YAS);

const LatestVersion = 1;

const CfgRanks           = class'Ranks';
const CfgRankRelations   = class'RankRelations';
const CfgMessageOfTheDay = class'MessageOfTheDay';

const UpdateInterval = 1.0f;

const MatchUID             = "0x";
const MatchPlayerSteamID64 = "76561";
const MatchGroupSteamID64  = "10358279";

var private config int        Version;
var private config E_LogLevel LogLevel;

var private KFGameInfo            KFGI;
var private KFGameInfo_Survival   KFGIS;
var private KFGameInfo_Endless    KFGIE;
var private KFGameReplicationInfo KFGRI;
var private KFOnlineGameSettings  KFOGS;

var private OnlineSubsystemSteamworks OSS;

var private Array<YAS_RepInfoOwner> RepInfos;

var private Array<CachedRankRelation> PlayerRelations;
var private Array<CachedRankRelation> GroupRelations;

var private int LastMessageID;

public simulated function bool SafeDestroy()
{
	`Log_Trace();

	return (bPendingDelete || bDeleteMe || Destroy());
}

public event PreBeginPlay()
{
	`Log_Trace();

	if (WorldInfo.NetMode == NM_Client)
	{
		`Log_Fatal("NetMode == NM_Client");
		SafeDestroy();
		return;
	}

	Super.PreBeginPlay();

	PreInit();
}

public event PostBeginPlay()
{
	`Log_Trace();

	if (bPendingDelete || bDeleteMe) return;

	Super.PostBeginPlay();

	PostInit();
}

private function PreInit()
{
	`Log_Trace();

	if (Version == `NO_CONFIG)
	{
		LogLevel = LL_Info;
		SaveConfig();
	}

	CfgRanks.static.InitConfig(Version, LatestVersion);
	CfgRankRelations.static.InitConfig(Version, LatestVersion);
	CfgMessageOfTheDay.static.InitConfig(Version, LatestVersion);

	switch (Version)
	{
		case `NO_CONFIG:
			`Log_Info("Config created");

		case MaxInt:
			`Log_Info("Config updated to version" @ LatestVersion);
			break;

		case LatestVersion:
			`Log_Info("Config is up-to-date");
			break;

		default:
			`Log_Warn("The config version is higher than the current version (are you using an old mutator?)");
			`Log_Warn("Config version is" @ Version @ "but current version is" @ LatestVersion);
			`Log_Warn("The config version will be changed to" @ LatestVersion);
			break;
	}

	if (LatestVersion != Version)
	{
		Version = LatestVersion;
		SaveConfig();
	}

	if (LogLevel == LL_WrongLevel)
	{
		LogLevel = LL_Info;
		`Log_Warn("Wrong 'LogLevel', return to default value");
		SaveConfig();
	}
	`Log_Base("LogLevel:" @ LogLevel);

	OSS = OnlineSubsystemSteamworks(class'GameEngine'.static.GetOnlineSubsystem());
	if (OSS != None)
	{
		InitRanks();
	}
	else
	{
		`Log_Error("Can't get online subsystem!");
	}
}

private function InitRanks()
{
	local Array<RankRelation> Relations;
	local RankRelation Relation;

	Relations = CfgRankRelations.default.Relation;

	foreach Relations(Relation)
	{
		if (IsUID(Relation.ObjectID) || IsPlayerSteamID64(Relation.ObjectID))
		{
			AddRelation(Relation, PlayerRelations);
		}
		else if (IsGroupSteamID64(Relation.ObjectID))
		{
			AddRelation(Relation, GroupRelations);
		}
		else
		{
			`Log_Warn("Can't parse ID:" @ Relation.ObjectID);
		}
	}
}

private function AddRelation(RankRelation Relation, out Array<CachedRankRelation> OutArray)
{
	local CachedRankRelation CachedRankRelation;
	local Array<Rank> Ranks;
	local Rank Rank;

	if (AnyToUID(Relation.ObjectID, CachedRankRelation.UID))
	{
		CachedRankRelation.RawID = Relation.ObjectID;

		Ranks = CfgRanks.default.Rank;
		foreach Ranks(Rank)
		{
			if (Rank.RankID == Relation.RankID)
			{
				CachedRankRelation.Rank = Rank;
				break;
			}
		}

		if (CachedRankRelation.Rank.RankID > 0)
		{
			OutArray.AddItem(CachedRankRelation);
		}
		else
		{
			`Log_Warn("Rank with ID" @ Relation.RankID @ "not found");
		}
	}
	else
	{
		`Log_Warn("Can't convert to UniqueNetID:" @ Relation.ObjectID);
	}
}

private static function bool IsUID(String ID)
{
	return (Left(ID, Len(MatchUID)) ~= MatchUID);
}

private static function bool IsPlayerSteamID64(String ID)
{
	return (Left(ID, Len(MatchPlayerSteamID64)) ~= MatchPlayerSteamID64);
}

private static function bool IsGroupSteamID64(String ID)
{
	return (Left(ID, Len(MatchGroupSteamID64)) ~= MatchGroupSteamID64);
}

private function bool AnyToUID(String ID, out UniqueNetId UID)
{
	return IsUID(ID) ? OSS.StringToUniqueNetId(ID, UID) : OSS.Int64ToUniqueNetId(ID, UID);
}

private function PostInit()
{
	`Log_Trace();

	if (WorldInfo == None || WorldInfo.Game == None)
	{
		SetTimer(1.0f, false, nameof(PostInit));
		return;
	}

	KFGI = KFGameInfo(WorldInfo.Game);
	if (KFGI == None || KFGameInfo_VersusSurvival(KFGI) != None) // VersusSurvival is not supported (yet)
	{
		`Log_Fatal("Incompatible gamemode:" @ WorldInfo.Game);
		SafeDestroy();
		return;
	}

	KFGI.HUDType = class'YAS_HUD';

	if (KFGI.GameReplicationInfo == None)
	{
		SetTimer(1.0f, false, nameof(PostInit));
		return;
	}

	KFGRI = KFGameReplicationInfo(KFGI.GameReplicationInfo);
	if (KFGRI == None)
	{
		`Log_Fatal("Incompatible Replication info:" @ KFGI.GameReplicationInfo);
		SafeDestroy();
		return;
	}

	if (KFGI.PlayfabInter != None && KFGI.PlayfabInter.GetGameSettings() != None)
	{
		KFOGS = KFOnlineGameSettings(KFGI.PlayfabInter.GetGameSettings());
	}
	else if (KFGI.GameInterface != None)
	{
		KFOGS = KFOnlineGameSettings(
			KFGI.GameInterface.GetGameSettings(
				KFGI.PlayerReplicationInfoClass.default.SessionName));
	}

	if (KFOGS == None)
	{
		SetTimer(1.0f, false, nameof(PostInit));
		return;
	}

	KFGIS = KFGameInfo_Survival(KFGI);
	KFGIE = KFGameInfo_Endless(KFGI);

	SetTimer(UpdateInterval, true, nameof(UpdateTimer));

	if (CfgMessageOfTheDay.default.Message.Length > 0)
	{
		MessageOfTheDayTimer();
		SetTimer(CfgMessageOfTheDay.default.DisplayTime, true, nameof(MessageOfTheDayTimer));
	}
}

private function UpdateTimer()
{
	local YAS_RepInfoOwner RepInfo;

	foreach RepInfos(RepInfo)
	{
		RepInfo.DynamicServerName = KFOGS.OwningPlayerName;
		RepInfo.UsesStats         = KFOGS.bUsesStats;
		RepInfo.Custom            = KFOGS.bCustom;
		RepInfo.PasswordRequired  = KFOGS.bRequiresPassword;
	}
}

private function MessageOfTheDayTimer()
{
	local YAS_RepInfoOwner RepInfo;
	local int MessageIndex;

	if (CfgMessageOfTheDay.default.bRandomize)
	{
		MessageIndex = Rand(CfgMessageOfTheDay.default.Message.Length);
	}
	else
	{
		MessageIndex = LastMessageID + 1;
	}

	if (MessageIndex == LastMessageID)
	{
		++MessageIndex;
	}

	if (MessageIndex >= CfgMessageOfTheDay.default.Message.Length)
	{
		MessageIndex = 0;
	}

	foreach RepInfos(RepInfo)
	{
		RepInfo.MessageOfTheDay = CfgMessageOfTheDay.default.Message[MessageIndex];
	}

	LastMessageID = MessageIndex;
}

public function NotifyLogin(Controller C)
{
	local YAS_RepInfoOwner RepInfo;

	`Log_Trace();

	RepInfo = CreateRepInfo(C);
	if (RepInfo == None)
	{
		`Log_Error("Can't create RepInfo for:" @ C);
		return;
	}

	InitRank(RepInfo);
}

public function NotifyLogout(Controller C)
{
	local YAS_RepInfoOwner RepInfo;

	`Log_Trace();

	RepInfo = FindRepInfo(C);

	if (!DestroyRepInfo(RepInfo))
	{
		`Log_Error("Can't destroy RepInfo of:" @ C);
	}
}

public function YAS_RepInfoOwner CreateRepInfo(Controller C)
{
	local YAS_RepInfoOwner  OwnerRepInfo;
	local YAS_RepInfoPlayer PlayerRepInfo;

	`Log_Trace();

	OwnerRepInfo  = Spawn(class'YAS_RepInfoOwner', C);
	PlayerRepInfo = Spawn(class'YAS_RepInfoPlayer', C);

	if (OwnerRepInfo != None && PlayerRepInfo != None)
	{
		RepInfos.AddItem(OwnerRepInfo);

		PlayerRepInfo.Rank           = class'YAS_Types'.static.FromSystemRank(CfgRanks.default.Player);
		OwnerRepInfo.PlayerRepInfo   = PlayerRepInfo;
		OwnerRepInfo.YAS             = Self;
		OwnerRepInfo.LogLevel        = LogLevel;
		OwnerRepInfo.RankPlayer      = CfgRanks.default.Player;
		OwnerRepInfo.RankAdmin       = CfgRanks.default.Admin;
		OwnerRepInfo.MessageOfTheDay = CfgMessageOfTheDay.default.Message[LastMessageID];

		return OwnerRepInfo;
	}

	return None;
}

private function YAS_RepInfoOwner FindRepInfo(Controller C)
{
	local YAS_RepInfoOwner RepInfo;

	if (C == None) return None;

	foreach RepInfos(RepInfo)
	{
		if (RepInfo.Owner == C)
		{
			return RepInfo;
		}
	}

	return None;
}

public function bool DestroyRepInfo(YAS_RepInfoOwner RepInfo)
{
	`Log_Trace();

	if (RepInfo == None) return false;

	RepInfos.RemoveItem(RepInfo);
	RepInfo.PlayerRepInfo.SafeDestroy();
	RepInfo.SafeDestroy();

	return true;
}

private function InitRank(YAS_RepInfoOwner RepInfo)
{
	local CachedRankRelation Rel;
	local String JoinedGroupIDs;
	local PlayerReplicationInfo PRI;
	local KFPlayerController KFPC;
	local Array<String> StringGroupIDs;

	`Log_Trace();

	KFPC = RepInfo.GetKFPC();

	if (KFPC == None) return;

	PRI = KFPC.PlayerReplicationInfo;
	if (PRI == None) return;

	foreach PlayerRelations(Rel)
	{
		if (Rel.UID.Uid == PRI.UniqueID.Uid)
		{
			RepInfo.PlayerRepInfo.Rank = Rel.Rank;
			break;
		}
	}

	if (RepInfo.PlayerRepInfo.Rank.RankID <= 0 && !KFPC.bIsEosPlayer)
	{
		foreach GroupRelations(Rel)
		{
			StringGroupIDs.AddItem(Rel.RawID);
		}
		JoinArray(StringGroupIDs, JoinedGroupIDs);
		RepInfo.CheckGroupRanks(JoinedGroupIDs);
	}
}

public function Rank RankByGroupID(UniqueNetId GroupUID)
{
	local CachedRankRelation Rel;

	foreach GroupRelations(Rel) if (Rel.UID == GroupUID) break;

	return Rel.Rank;
}

public simulated function vector GetTargetLocation(optional actor RequestedBy, optional bool bRequestAlternateLoc)
{
	local Controller C;
	C = Controller(RequestedBy);
	if (C != None) { bRequestAlternateLoc ? NotifyLogout(C) : NotifyLogin(C); }
	return Super.GetTargetLocation(RequestedBy, bRequestAlternateLoc);
}

DefaultProperties
{

}