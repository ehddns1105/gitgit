# main 에서 ssh-key 생성
````
ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa        ##/root/.ssh/id_rsa 생성됨
ssh-copy-id root@210.122.45.144                 ## 해당 값을 다른 서버로 이동 , 여기서는 root 지만 별도 ansible 계정 생성 해서 진행 하는 것이 좋음


````

## ansible Help
````
$ ansible-doc -l
````


````

옵션	설명
-m	    모듈 선택
-i	    인벤토리 선택
-u	    유저명


## 특정 파일 복사 ##

-a /etc/ansible/hosts 에 있는 모든 서버에
src = ansible 서버에서 노드 서버로 복사 할 파일

[ansible@dw-main ~]$ ansible all -m copy -a "src=~/test.txt dest=~/test.txt"


## 모든 서버 연결 확인 ##
ansible all -m ping


````




## YAML 코드 작성 시
````
앤서블 블록 구별을 보통 "-"로 구별한다. 시작 블록은 보통 다음과 같은 형식으로 많이 사용한다. 
- name: <keyword>
 <module>


 그래서 YAML상단에는 다음과 같은 형태로 키워드 명령어를 사용한다.
- name:                 //작업 이름
  hosts: all            //대상 서버 이름
  become: true          // 앤서블 내장 키워드



서버 접근 시, 사용하는 hosts키워드는 다음과 같은 미리 예약된 옵션 혹은 값이 있다. 일반적으로 많이 사용하는 값 은 아래와 같다.
1. localhost: 127.0.0.1와 같은 자기 자신 루프 백(loopback)
2. all : 인벤토리에(inventory)등록된 모든 호스트
3. [group]: 특정 그룹에만 적용하는 명령어 키워드.그룹명은 반드시 중괄호{}와 같이 사용한다.
````


## 전역 키워드 선언

````
전역 키워드는 "hosts:", "tasks:" 사이에 작성한다. 일반적으로 많이 사용하는 명령어는 아래와 같다. 이 이외 키워
드 명령어는 보통 "ansible.cfg"이나 혹은 매뉴얼을 통해서 확인이 가능하다. 일반적으로 많이 사용하는 전역 키워
드는 아래와 같다.

- hosts:
  vars:
   - var1
   - var2
  become:
  remote_user:
  task

````


## tasks:
````
모든 작업이 시작되는 구간. tasks 구간에는 여러 모듈(module)이 모여서 하나의 작업 워크플로우(workflow)를
구성한다.

tasks:
 - name:
tasks:
 - name:

여러 개의 워크 플로우가 구성이 되면 이걸 플레이북 혹은 플레이북 작업(playbook tasking)이라고 부른다.
````


## -name
````
YAML에서 작업 및 혹은 플레이북 작성 시, 각각 모듈 혹은 플레이북에 "name:"키워드를 사용하여 작성 및 구성을
권장한다.

- name: this is the first module task
  ping:

위와 같은 방법으로 명시한 모듈이나 플레이북에 어떠한 목적으로 동작하는지 간단하게 적는다. 이전에는 CJK를 지
원하지 않았지만, 지금은 문제없이 지원하고 있다


````




<span style='background-color: #fff5b1'>노란형광펜</span>

