#! /bin/bash
# ####################################
# GIT 을 이용해서 Mediawiki 설치하기
# @Version : 1.3.190123
# @git : https://github.com/exizt/mediawiki_installer_script
# 
# 리눅스 용으로 만들었는데... 윈도우에서도 동작이 되네요.
# ####################################
# 
# [Configurations]
#
# 생성할 폴더명
CF_MW_DIRNAME="wiki_1_33"
# 
# 브랜치. 보통 REL1_33 과 같은 식임.
CF_MW_BRANCH="REL1_33"
# 
# 확장 기능 들.
CF_MW_EXTENSIONS=("CharInsert" "Cite" "CiteThisPage" "ConfirmEdit" "Gadgets" "ImageMap" "InputBox" "Interwiki" "LocalisationUpdate" "Nuke" "ParserFunctions" "Poem" "Renameuser" "SpamBlacklist" "SyntaxHighlight_GeSHi" "TitleBlacklist" "WikiEditor" "Math" "Kartographer" "CodeEditor")
# 
# ####################################
# Variables
script_dir=$(cd "$(dirname "$0")" && pwd)
cd $script_dir

wikiName="$CF_MW_DIRNAME"
wikiPath="${script_dir}/${wikiName}"


# ####################################
# 처리 부분


# 1. 미디어위키 코어 git cloning
cmd_clone_core="git clone https://gerrit.wikimedia.org/r/mediawiki/core.git --branch ${CF_MW_BRANCH} --depth=1 $wikiName"

# composer 셋팅, images 폴더 퍼미션 등
cmd_clone_core_step2="cd ${wikiPath} && composer update --no-dev && chown -R apache:apache images/"

# 명령어 실행부
eval "${cmd_clone_core} && ${cmd_clone_core_step2}"
echo "step 1/3 미디어위키 코어 복사 완료."
sleep 0.5


# 바로 submodule 로 처리하고 싶을 때.
# git submodule update --init --recursive


# 스킨 git cloning
cmd_clone_skins="cd ${wikiPath}/skins && git clone https://gerrit.wikimedia.org/r/mediawiki/skins/Vector --branch ${CF_MW_BRANCH} --depth=1 Vector"
eval $cmd_clone_skins
echo "step 2/3 미디어위키 스킨 복사 완료."
sleep 0.5


# 확장 기능들
for extension_name in "${CF_MW_EXTENSIONS[@]}"; do
# command="git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/${extension_name}.git && cd ${extension_name} && git checkout ${CF_MW_BRANCH}"
	cmd_clone_extensions="cd ${wikiPath}/extensions && git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/${extension_name}.git --branch ${CF_MW_BRANCH} --depth=1 ${extension_name}"
	echo $cmd_clone_extensions
	eval $cmd_clone_extensions
	sleep 0.5
done

# 3.2 download and clone other extensions
# cd $wikiPath"/extensions"
# git clone https://github.com/HydraWiki/mediawiki-embedvideo.git EmbedVideo
# git clone https://github.com/wikimedia/mediawiki-extensions-Kartographer.git Kartographer
# git clone https://gerrit.wikimedia.org/g/mediawiki/extensions/Kartographer Kartographer

# 4. fin
cd $wikiPath
echo ''
echo 'MediaWiki installation has been completed.'

exit 0