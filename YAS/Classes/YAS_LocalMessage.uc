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

class YAS_LocalMessage extends Object
	abstract;

var const             String PlayersDefault;
var private localized String Players;

var const             String SpectatorsDefault;
var private localized String Spectators;

enum E_YAS_LocalMessageType
{
	YAS_Players,
	YAS_Spectators
};

public static function String GetLocalizedString(E_YAS_LocalMessageType LMT)
{
	switch (LMT)
	{
		case YAS_Players:
			return (default.Players != "" ? default.Players : default.PlayersDefault);

		case YAS_Spectators:
			return (default.Spectators != "" ? default.Spectators : default.SpectatorsDefault);
	}

	return "";
}

defaultproperties
{
	PlayersDefault    = "Players"
	SpectatorsDefault = "Spectators"
}
