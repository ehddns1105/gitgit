
git 작업 전 확인 내용
==========

```
git version     버전 확인

git config --global user.name "dongwoon"    /     "사이에 유저 명
git config --global user.email "ehddns1105@naver.com"       /   "" 사이에 이메일

git config --list       / 유저 및 이메일 확인



git init        /레포지토리 초기화
git add gittest.html    파일 업로드
git commit -m "1st"     / 업로드 한 내용 메모



git remote add <name> <url>
git remote add origin https://github.com/ehddns1105/gitgit.git   / 원격 저장소 추가


git remote -v / 원격 저장소 확인
git remote remove origin   / 원격 저장소 삭제
```


에러 사항
========

```
PS C:\Users\dongwoon.choi.HWK\Desktop\vscodetest> git push -u origin main
To https://github.com/ehddns1105/gittest1.git
 ! [rejected]        main -> main (non-fast-forward)
error: failed to push some refs to 'https://github.com/ehddns1105/gittest1.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.

-> push 할때 해당 에러 발생 시 pull(아래 명령어) 로 프로젝트를 먼저 병합을 해주어야 함

git pull origin (branchname/main) --allow-unrelated-histories



git push -u origin main     / git push (업로드)


```


파일 업로드 시
---
```
git add (파일 명)           / 파일 추가
git commit -m "3stst"       / commit 으로 메모
git push -u origin main     / origin 으로 main branch 에 push(업로드)
```

<<<<<<< HEAD:git.md


clone (원격 저장소 복제 하기)
---

```
git clone <repository> <directory>

git clone https://github.com/ehddns1105/gitgit.git clonetest        / 
repository 는 원격 저장소의 url
directory 는 복제대상의 폴더명
```




Git Login Token 발급 방법
===

우상단 Account - Settings - Developer settings - Personal access tokens
=======


Git Branch
===
```
* merge : 변경 내용의 이력이 모두 그대로 남아 있기 때문에 이력이 복잡해짐
* rebase : 이력은 단순해지지만, 원래의 커밋 이력이 변경됨. 정확한 이력을 남겨야 할 필요가 있을 경우에는 사용 X
```

branch 사용법
---
```
git branch <branchname>     : branch 생성
ex) git branch branchtest

git branch                  : branch 확인

git checkout <branchname>   : 사용 할 branch 변경

git merge <branchname>      : 브랜치 병합하기
git branch -d <branchname>  : 브랜치 삭제 (-d 옵션)

```


```
Note
checkout 명령에 -b 옵션을 넣으면 브랜치 작성과 체크아웃을 한꺼번에 실행할 수 있습니다.
$ git checkout -b <branch>
```


bbbbbbbb