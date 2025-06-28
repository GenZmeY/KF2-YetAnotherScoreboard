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

class YAS_RepInfoPlayer extends ReplicationInfo;

var public  UniqueNetID UID;
var public  Rank        Rank;
var public  int         DamageDealt;

replication
{
	if (bNetInitial)
		UID;

	if (bNetDirty)
		Rank, DamageDealt;
}

public simulated function bool SafeDestroy()
{
	return (bPendingDelete || bDeleteMe || Destroy());
}

public simulated event PreBeginPlay()
{
	if (bPendingDelete || bDeleteMe) return;

	Super.PreBeginPlay();

	if (Role == ROLE_Authority || WorldInfo.NetMode == NM_StandAlone)
	{
		if (Controller(Owner) != None && Controller(Owner).PlayerReplicationInfo != None)
		{
			UID = Controller(Owner).PlayerReplicationInfo.UniqueID;
		}
	}
}

defaultproperties
{
	Role       = ROLE_Authority
	RemoteRole = ROLE_SimulatedProxy

	bAlwaysRelevant               = true
	bSkipActorPropertyReplication = false
}