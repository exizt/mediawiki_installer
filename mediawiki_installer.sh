#! /bin/bash
# #######################
# Mediawiki 1.29 installer script (using git)
# Version : 1.0.180212
# 
# 미디어위키를 Git 으로 설치하는 스크립트 입니다. 스크립트를 동작시키는 폴더 하위에 생성합니다.
# #######################
cd "$(dirname "$0")"


# 1. git clone
# 폴더를 생성하면서 git clone 을 해준다.
# 작업이 완료된후에, 원하는 버전으로 checkout 도 해둔다.
git clone https://gerrit.wikimedia.org/r/p/mediawiki/core.git wiki_1_29
cd wiki_1_29
git checkout -b REL1_29 origin/REL1_29
git branch -l

# 2. composer update
# composer update. 받은 것은 core 뿐이기 때문에, 관련된 라이브러리 들을 받아준다. 
# 작업이 완료되면 vendor 폴더가 생성이 된다.
composer update


# 3. skins 및 extensions 하위 생성
# skins 와 extensions 폴더 하위 내용 생성
# 작업이 완료되면, skins 와 extensions 폴더 내의 파일들이 생성된다.
git submodule update --init --recursive

echo ''
echo 'Mediawiki 1.29 installation has been completed.'

exit 0