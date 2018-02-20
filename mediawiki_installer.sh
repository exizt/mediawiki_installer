#! /bin/bash
# #######################
# Mediawiki 1.30 installer script (using git)
# Version : 1.1.180220
# 
# 미디어위키를 Git 으로 설치하는 스크립트 입니다. 스크립트를 동작시키는 폴더 하위에 생성합니다.
# git : https://github.com/exizt/mediawiki_installer
# #######################
# cd "$(dirname "$0")"
script_dir=$(cd "$(dirname "$0")" && pwd)
cd $script_dir

wikiName="wiki_1_30_test"
wikiPath="$script_dir/$wikiName"

# 1. git clone
# git clone 하면서 폴더를 생성
cmd_cr_core_git_clone="git clone https://gerrit.wikimedia.org/r/p/mediawiki/core.git $wikiName"

# 1.2 원하는 브랜치로 체크아웃
# 원하는 버전대로 맞춰두어야 나중에 수월하다.
cmd_cr_core_checkout="cd $wikiName && git checkout -b REL1_30 origin/REL1_30"

# 1.3 작업 마지막에 할 것. composer update 동작 및 문구
# composer update 를 완료하면 vendor 폴더가 생성이 된다.
cmd_cr_core_after="composer update && chown -R apache:apache images/"

# 1.E. 명령어 실행 과 composer update 동작
eval "$cmd_cr_core_git_clone && $cmd_cr_core_checkout && $cmd_cr_core_after"

echo "has completed git cloning"
sleep 0.5


# 2. skins 및 extensions 하위 생성
# skins 와 extensions 폴더 하위 내용 생성
# 작업이 완료되면, skins 와 extensions 폴더 내의 파일들이 생성된다.
# git submodule update --init --recursive
# 안전한 수동 방식으로 extension 과 skin 을 설치하자.

# 2.1. Skin 받기
cd $wikiPath"/skins"
git clone https://gerrit.wikimedia.org/r/mediawiki/skins/Vector Vector && cd Vector && git checkout REL1_30
# git clone https://gerrit.wikimedia.org/r/mediawiki/skins/Vector Vector
# git clone https://github.com/wikimedia/mediawiki-skins-Vector Vector && cd Vector && git checkout REL1_30


# 2.2 Extension 받기
extension_list=("CharInsert" "Cite" "CiteThisPage" "ConfirmEdit" "Gadgets" "ImageMap" "InputBox" "Interwiki" "LocalisationUpdate" "Nuke" "ParserFunctions" "Poem" "Renameuser" "SpamBlacklist" "SyntaxHighlight_GeSHi" "TitleBlacklist" "WikiEditor" )

for extension_name in "${extension_list[@]}"; do
	echo $value
	cd $wikiPath"/extensions"
	command="git clone https://gerrit.wikimedia.org/r/p/mediawiki/extensions/${extension_name}.git && cd ${extension_name} && git checkout REL1_30"
	# echo $command
	eval $command
	sleep 0.5
done

# 2.3 installation other extensions
cd $wikiPath"/extensions"
git clone https://github.com/HydraWiki/mediawiki-embedvideo.git EmbedVideo


cd $wikiPath
echo ''
echo 'Mediawiki 1.30 installation has been completed.'

exit 0