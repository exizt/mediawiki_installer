#! /bin/bash
# ####################################
# Mediawiki 1.30 installer script (using git)
# Version : 1.1.180220
# 
# 미디어위키를 Git 으로 설치하는 스크립트 입니다. 스크립트를 동작시키는 폴더 하위에 생성합니다.
# git : https://github.com/exizt/mediawiki_installer
# ####################################
script_dir=$(cd "$(dirname "$0")" && pwd)
cd $script_dir

wikiName="wiki_1_30"
wikiPath="$script_dir/$wikiName"




# ## 1. make mediawiki core ## 


# 1.(1) command for git clone
# clone git and create wiki directories
cmd_cr_core_git_clone="git clone https://gerrit.wikimedia.org/r/p/mediawiki/core.git $wikiName"


# 1.(2) command for checkout git
# 원하는 버전대로 맞춰두어야 나중에 수월하다.
cmd_cr_core_checkout="cd $wikiName && git checkout -b REL1_30 origin/REL1_30"


# 1.(3) command for composer update and image folder permission
# composer update 를 완료하면 vendor 폴더가 생성이 된다.
# create vender folder after composer update
cmd_cr_core_after="composer update && chown -R apache:apache images/"

# 1.E. 명령어 실행 과 composer update 동작
# execute commands (1) (2) (3)
eval "$cmd_cr_core_git_clone && $cmd_cr_core_checkout && $cmd_cr_core_after"

echo "has completed git cloning"
sleep 0.5


# ## 2. make mediawiki skins ## 


# 2번과 3번을 사용 안 하고, 한번에 스킨과 확장기능 전부를 한번에 설치하려면. 아래의 명령어를 사용한다.
# git submodule update --init --recursive


# 2. download and clone 'mediawiki skins'
# skins 폴더 하위 내용 생성. 나는 Vector 만 사용할 것이라서, Vector 만 생성함.
cd $wikiPath"/skins"
git clone https://gerrit.wikimedia.org/r/mediawiki/skins/Vector Vector && cd Vector && git checkout REL1_30



# ## 3. make mediawiki extensions ## 


# 3.1 download and clone 'media wiki extetions' from git
extension_list=("CharInsert" "Cite" "CiteThisPage" "ConfirmEdit" "Gadgets" "ImageMap" "InputBox" "Interwiki" "LocalisationUpdate" "Nuke" "ParserFunctions" "Poem" "Renameuser" "SpamBlacklist" "SyntaxHighlight_GeSHi" "TitleBlacklist" "WikiEditor" )
for extension_name in "${extension_list[@]}"; do
	echo $value
	cd $wikiPath"/extensions"
	command="git clone https://gerrit.wikimedia.org/r/p/mediawiki/extensions/${extension_name}.git && cd ${extension_name} && git checkout REL1_30"
	# echo $command
	eval $command
	sleep 0.5
done

# 3.2 download and clone other extensions
cd $wikiPath"/extensions"
git clone https://github.com/HydraWiki/mediawiki-embedvideo.git EmbedVideo


# 4. fin
cd $wikiPath
echo ''
echo 'Mediawiki 1.30 installation has been completed.'

exit 0