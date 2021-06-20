#!/bin/bash

# Requirements: git-bash
# https://git-scm.com/download/win

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

function winpath2unix () # $1: win path
{
	echo "$*" | \
	sed -r 's|^(.):|\\\1|' | \
	sed 's|\\|/|g'
}

function unixpath2win () # $1: unix path
{
	echo "$*" | \
	sed -r 's|^/(.)|\1:|' | \
	sed 's|/|\\|g'
}

function reg_readkey () # $1: path, $2: key
{
	winpath2unix $(
	reg query "$1" //v "$2" | \
	grep -F "$2"            | \
	awk '{ $1=$2=""; print $0 }' )
}

function show_help ()
{
	echo "$ScriptName"
	echo "Usage:"
	echo "${ScriptName} OPTION"
	echo "Options:"
	echo "  -c, --compile"
	echo "  -b, --brew"
	echo " -bu, --brew-unpublished"
	echo "  -u, --upload"
	echo "  -t, --test"
	echo "  -h, --help"
}

function cleanup()
{
	trap - SIGINT SIGTERM ERR EXIT
	restore_kfeditorconf
}

function get_latest_multini ()
{
	local ApiUrl="https://api.github.com/repos/GenZmeY/multini/releases/latest"
	local LatestTag=$(curl --silent "$ApiUrl" | grep -Po '"tag_name": "\K.*?(?=")')
	local DownloadUrl="https://github.com/GenZmeY/multini/releases/download/$LatestTag/multini-windows-amd64.exe"
	
	mkdir -p "$ThirdPartyBin"
	curl -LJs "$DownloadUrl" -o "$ThirdPartyBin/multini.exe"
}

function backup_kfeditorconf ()
{
	cp "$KFEditorConf" "$KFEditorConfBackup"
}

function restore_kfeditorconf ()
{
	if [[ -f "$KFEditorConfBackup" ]]; then
		mv -f "$KFEditorConfBackup" "$KFEditorConf"
	fi
}

function setup_modpackages ()
{
	multini --set "$KFEditorConf" 'ModPackages' 'ModPackages' 'YAS'
	multini --set "$KFEditorConf" 'ModPackages' 'ModPackagesInPath' "$(unixpath2win "$MutSource")"
}

function compiled ()
{
	test -f "$MutStructScript/YAS.u"
}

function compile ()
{
	if ! command -v multini &> /dev/null; then
		get_latest_multini
	fi
	
	backup_kfeditorconf && setup_modpackages

	rm -rf "$MutUnpublish"
	mkdir -p \
		"$MutUnpublish" \
		"$MutStructScript" \
		"$MutStructLocalization"
		
	cp -rf "$MutSource/Localization"/* "$MutStructLocalization"

	CMD //C "$(unixpath2win "$KFEditor")" make -useunpublished &
	local PID="$!"
	while ps -p "$PID" &> /dev/null
	do
		if compiled; then
			kill "$PID"; break
		fi
		sleep 2
	done
	
	restore_kfeditorconf
	
	if ! compiled; then
		echo "Compilation failed"
		return 1
	fi
}

function brew ()
{
	echo "brew command is broken. Use --brew-unpublished or brew from WorkshopUploadToolGUI instead of this."
	# CMD //C "$(unixpath2win "$KFEditor")" brewcontent -platform=PC ServerExt ServerExtMut -useunpublished
}

function brew_unpublished ()
{
	rm -rf "$MutPublish"
	if ! compiled; then
		compile
	fi
	cp -rf "$MutUnpublish" "$MutPublish"
}

function generate_wsinfo () # $1: package dir
{
	local Description=$(cat "$MutPubContent/description.txt")
	local Title=$(cat "$MutPubContent/title.txt")
	local Preview=$(unixpath2win "$MutPubContent/preview.png")
	local Tags=$(cat "$MutPubContent/tags.txt")
	local PackageDir=$(unixpath2win "$1")
	echo "\$Description \"$Description\"
\$Title \"$Title\"
\$PreviewFile \"$Preview\"
\$Tags \"$Tags\"
\$MicroTxItem \"false\"
\$PackageDirectory \"$PackageDir\"
" > "$MutWsInfo"
}

function upload ()
{
	PackageDir=$(mktemp -d -u -p "$KFDoc")
	cp -rf "$MutPublish"/* "$PackageDir"
	generate_wsinfo "$PackageDir"
	CMD //C "$(unixpath2win "$KFWorkshop")" "$MutWsInfoName"
	rm -rf "$PackageDir"
	rm -f "$MutWsInfo"
}

function create_default_testing_ini ()
{
echo "Map=\"KF-Outpost\"
Game=\"KFGameContent.KFGameInfo_Survival\"
Difficulty=\"0\"
GameLength=\"0\"
Mutators=\"YAS.YASMut\"
Args=\"\"" > "$MutTestingIni"
}

function game_test ()
{
	if ! [[ -r "$MutTestingIni" ]]; then
		create_default_testing_ini
	fi
	source "$MutTestingIni"
	CMD //C "$(unixpath2win "$KFGame")" ${Map}?Difficulty=${Difficulty}?GameLength=${GameLength}?Game=${Game}?Mutator=${Mutators}?${Args} -useunpublished -log
}

ScriptFullname=$(readlink -e "$0")
ScriptName=$(basename "$0")
ScriptDir=$(dirname "$ScriptFullname")

SteamPath=$(reg_readkey "HKCU\Software\Valve\Steam" "SteamPath")
DocumentsPath=$(reg_readkey "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" "Personal")

KFPath="$SteamPath/steamapps/common/killingfloor2"
KFBin="$KFPath/Binaries"
KFEditor="$KFBin/Win64/KFEditor.exe"
KFGame="$KFBin/Win64/KFGame.exe"
KFWorkshop="$KFBin/WorkshopUserTool.exe"

KFDoc="$DocumentsPath/My Games/KillingFloor2"
KFConfig="$KFDoc/KFGame/Config"

KFEditorConf="$KFConfig/KFEditor.ini"
KFEditorConfBackup="${KFEditorConf}.backup"

MutSource="$ScriptDir"
MutPubContent="$MutSource/PublicationContent"
MutUnpublish="$KFDoc/KFGame/Unpublished"
MutPublish="$KFDoc/KFGame/Published"

MutStructScript="$MutUnpublish/BrewedPC/Script"
MutStructPackages="$MutUnpublish/BrewedPC/Packages"
MutStructLocalization="$MutUnpublish/BrewedPC/Localization"

MutTestingIni="$MutSource/testing.ini"
MutWsInfoName="wsinfo_serverext.txt"
MutWsInfo="$KFDoc/$MutWsInfoName"

ThirdPartyBin="$MutSource/3rd-party-bin"

export PATH="$PATH:$ThirdPartyBin"

if [[ $# -eq 0 ]]; then show_help; exit 0; fi
case $1 in
	  -h|--help             ) show_help        ; ;;
	  -c|--compile          ) compile          ; ;;
	  -b|--brew             ) brew             ; ;;
	 -bu|--brew-unpublished ) brew_unpublished ; ;;
	  -u|--upload           ) upload           ; ;;
	  -t|--test             ) game_test        ; ;;
	    *                   ) echo "Command not recognized: $1"; exit 1;;
esac
