// This file is part of Yet Another Scoreboard.
// Yet Another Scoreboard - a mutator for Killing Floor 2.
//
// Copyright (C) 201?      Marco
// Copyright (C) 2020      ForrestMarkX
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

class KFGUI_CategoryList extends KFGUI_ComponentList;

// Broken, does not work correctly when closing a menu and re-opening it if a category is open
struct FCategoryItems
{
	var name ID;
	var KFGUI_Base Item;
};
var array<FCategoryItems> CategoryItems;

function AddCategory(name CatID, string CatName, optional Texture2D IconMat, optional Color IconClr, optional float XS=1.f, optional float YS=1.f)
{
	local KFGUI_CategoryButton B;

	B = KFGUI_CategoryButton(AddListComponent(class'KFGUI_CategoryButton', XS, YS));
	B.ButtonText = CatName;
	B.ID = CatID;
	B.Icon = IconMat;
	B.IconColor = IconClr;
	B.OnClickLeft = SelectedCategory;
	B.OnClickRight = SelectedCategory;
}

function KFGUI_Base AddItemToCategory(name CatID, class<KFGUI_Base> Item)
{
	local FCategoryItems CatItem;
	local KFGUI_Base G;

	G = CreateComponent(Item);
	G.ID = CatID;
	G.Owner = Owner;
	G.ParentComponent = Self;

	CatItem.ID = CatID;
	CatItem.Item = G;
	CategoryItems.AddItem(CatItem);

	return G;
}

function SelectedCategory(KFGUI_Button Sender)
{
	local int i, j, Index;
	local KFGUI_CategoryButton CatB;

	CatB = KFGUI_CategoryButton(Sender);
	if (CatB == None)
		return;

	Index = ItemComponents.Find(Sender);
	if (Index != INDEX_NONE)
	{
		if (!CatB.bOpened)
		{
			CatB.bOpened = true;
			j = Index+1;
			for (i=0; i < CategoryItems.Length; i++)
			{
				if (CategoryItems[i].ID == CatB.ID)
					AddItemAtIndex(j++, CategoryItems[i].Item);
			}
		}
		else
		{
			CatB.bOpened = false;
			for (i=0; i < CategoryItems.Length; i++)
			{
				if (CategoryItems[i].ID == CatB.ID)
					ItemComponents.RemoveItem(CategoryItems[i].Item);
			}
		}
	}
}

function EmptyList()
{
	local int i;

	for (i=0; i < ItemComponents.Length; i++)
	{
		if (KFGUI_CategoryButton(ItemComponents[i]) == None)
			ItemComponents.Remove(i, 1);
	}
	CategoryItems.Length = 0;
}

defaultproperties
{

}