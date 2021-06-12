class ScoreboardExtRepInfo extends ReplicationInfo;

// Server vars
var public ScoreboardExtMut Mut;

// Client vars
var private KFScoreBoard SC;
var private OnlineSubsystemSteamworks SW;

// Fitst time replication
var public array<UIDRankRelation> SteamGroupRelations;
var public array<RankInfo> CustomRanks;
var public SCESettings Settings;
var public UIDRankRelation RankRelation; // Current player rank relation

var private int CustomRanksRepProgress, SteamGroupsRepProgress;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();

    if (bDeleteMe) return;
	
	if (Role < ROLE_Authority)
	{
		ClientInit();
	}
}

private reliable client function ClientInit()
{
	if (SC == None)
		SC = ScoreboardExtHUD(GetALocalPlayerController().myHUD).Scoreboard;
	
	if (SW == None)
		SW = OnlineSubsystemSteamworks(class'GameEngine'.static.GetOnlineSubsystem());
	
	if (SC == None || SW == None)
		SetTimer(0.1f, false, nameof(ClientInit));
	else
		ClearTimer(nameof(ClientInit));
}

public function StartFirstTimeReplication()
{
	SetTimer(0.01f, true, nameof(ReplicateCustomRanks));
	SetTimer(0.01f, true, nameof(ReplicateSteamGroupRelations));
}

private reliable client function ClientSetSettings(SCESettings Set)
{
	SC.Settings = Set;
}

private function ReplicateCustomRanks()
{
	if (CustomRanksRepProgress < CustomRanks.Length)
	{
		ClientAddCustomRank(CustomRanks[CustomRanksRepProgress]);
		++CustomRanksRepProgress;
	}
	else
	{
		ClearTimer(nameof(ReplicateCustomRanks));
	}
}

private reliable client function ClientAddCustomRank(RankInfo Rank)
{
	CustomRanks.AddItem(Rank);
}

private function ReplicateSteamGroupRelations()
{
	if (SteamGroupsRepProgress < SteamGroupRelations.Length)
	{
		ClientAddSteamGroupRelation(SteamGroupRelations[SteamGroupsRepProgress]);
		++SteamGroupsRepProgress;
	}
	else
	{
		ClearTimer(nameof(ReplicateSteamGroupRelations));
		if (RankRelation.RankID == INDEX_NONE)
			FindMyRankInSteamGroups();
	}
}

private reliable client function ClientAddSteamGroupRelation(UIDRankRelation Rel)
{
	SteamGroupRelations.AddItem(Rel);
}

private reliable client function FindMyRankInSteamGroups()
{
	local UIDRankRelation SteamGroupRel;
	
	foreach SteamGroupRelations(SteamGroupRel)
		if (SW.CheckPlayerGroup(SteamGroupRel.UID))
			RankRelation.RankID = SteamGroupRel.RankID;
		
	if (RankRelation.RankID != INDEX_NONE)
		ServerApplyRank(RankRelation.RankID);
}

private reliable server function ServerApplyRank(int RankID)
{
	RankRelation.RankID = RankID;
	Mut.UpdatePlayerRank(RankRelation);
}

public function AddRankRelation(UIDRankRelation Rel)
{
	ClientAddRankRelation(Rel);
}

private reliable client function ClientAddRankRelation(UIDRankRelation Rel)
{
	SC.RankRelations.AddItem(Rel);
}

public function RemoveRankRelation(UIDRankRelation Rel)
{
	ClientRemoveRankRelation(Rel);
}

private unreliable client function ClientRemoveRankRelation(UIDRankRelation Rel)
{
	SC.RankRelations.RemoveItem(Rel);
}

public function UpdateRankRelation(UIDRankRelation Rel)
{
	ClientUpdateRankRelation(Rel);
}

private reliable client function ClientUpdateRankRelation(UIDRankRelation Rel)
{
	local int Index;
	
	Index = SC.RankRelations.Find('UID', Rel.UID);
	
	if (Index != INDEX_NONE)
		SC.RankRelations[Index] = Rel;
}

defaultproperties
{	
	CustomRanksRepProgress = 0;
	SteamGroupsRepProgress = 0;
}