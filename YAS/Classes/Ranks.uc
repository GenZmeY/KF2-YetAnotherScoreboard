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

class Ranks extends Object
	dependson(YAS_Types)
	config(YAS);

var public config SystemRank  Player;
var public config SystemRank  Admin;
var public config Array<Rank> Rank;

public static function InitConfig(int Version, int LatestVersion)
{
	switch (Version)
	{
		case `NO_CONFIG:
			ApplyDefault();

		default: break;
	}

	if (LatestVersion != Version)
	{
		StaticSaveConfig();
	}
}

private static function ApplyDefault()
{
	local Rank NewRank;

	// System ranks:
	default.Player.RankName    = "";
	default.Player.RankColor   = MakeColor(250, 250, 250, 250);
	default.Player.PlayerColor = MakeColor(250, 250, 250, 250);

	default.Admin.RankName    = "Admin";
	default.Admin.RankColor   = MakeColor(250, 0, 0, 250);
	default.Admin.PlayerColor = MakeColor(250, 0, 0, 250);

	default.Rank.Length = 0;

	// Example custom rank:
	NewRank.RankID      = 1;
	NewRank.RankName    = "Man of culture";
	NewRank.RankColor   = MakeColor(0, 250, 0, 250);
	NewRank.PlayerColor = MakeColor(250, 250, 250, 250);

	default.Rank.AddItem(NewRank);
}

defaultproperties
{

}