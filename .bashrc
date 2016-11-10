#
# ~/.bashrc
#

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# Every machine
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.keychain/$HOSTNAME-sh ]; then # Fix gpg issue regardless of host
	. ~/.keychain/$HOSTNAME-sh
fi

# vim, like a man
if which vim &>/dev/null; then
	export EDITOR=vim
	export VISUAL=vim
else
	export EDITOR=vi
	export VISUAL=vi
fi

auto_ssh_key() {
	for key in $(command ls -1 ~/.ssh | grep -E 'rsa[^\.]*$'); do
		keychain -q --nogui ~/.ssh/$key
	done
}

# Color-and-giterize PS1
export TZ=America/Los_Angeles
function color_my_prompt {
    local __date="\[\033[33m\]\D{%T}"
    local __user_and_host="\[\033[32m\]\u@\h"
    local __cur_location="\[\033[01;34m\]\w"
    local __git_branch_color="\[\033[30m\]"
    local __git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/[\\\\\1]\ /`'
    local __prompt_tail="\[\033[30m\]$"
    local __last_color="\[\033[00m\]"
    export PS1="$__date $__user_and_host $__cur_location $__git_branch_color$__git_branch\n $__prompt_tail$__last_color "
}
color_my_prompt

# Bash aliases
alias elinks='elinks google.com'
alias ll="ls -lashp --color"
alias ls="ls --color"
alias shell="ssh johnsma8@shell.onid.oregonstate.edu"
alias flip="ssh johnsma8@flip.engr.oregonstate.edu"
alias g="git"

# exports
export PATH=$PATH:.
export PATH=$PATH:/usr/local/musl/bin/
export PATH=$PATH:/home/mrsj/osu/fall2016/softwareEngineeringII-cs362/assignments-matthewrsj/bin/apache-maven-3.3.9/bin
export JAVA_HOME=/usr/lib/jvm/java-8-jdk
export GOPATH=/home/mrsj/go
export clear_root=/home/mrsj/clear

# Miscellaneous
test -f ~/.git-completion.bash && . $_
shopt -s checkwinsize
shopt -s autocd

# Functions
function qe()
{
    qemu-system-x86_64 -enable-kvm -m 1024 -cpu host -smp cpus=2 -bios \
            $clear_root/projects/common/image-creator/OVMF.fd \
            -net nic,model=virtio -net user -vnc 0.0.0.0:0 \
            -drive if=virtio,aio=threads,format=raw,file=$1
}

function qet()
{
    qemu-system-x86_64 -enable-kvm -m 1024 -cpu host -smp cpus=2 \
            -bios $clear_root/projects/common/image-creator/OVMF.fd \
            -nographic -vga none -net nic,model=virtio -net user \
            -drive if=virtio,aio=threads,format=raw,file=$1
}

function mkimg()
{
        echo sudo python3 ister.py -t $1 
        sudo python3 ister.py -t $1 
}
function mkimgstaging()
{
       echo sudo python3 ister.py -t $1 -f staging -u http://clearlinux-sandbox.jf.intel.com/update/
       sudo python3 ister.py -t $1 -f staging -u http://clearlinux-sandbox.jf.intel.com/update/
}

function runlive()
{
        echo sudo qemu-system-x86_64 -enable-kvm -m 1024 -vnc 0.0.0.0:0 -cpu host -drive file=$1,if=virtio,aio=threads -net nic,model=virtio -net user,hostfwd=tcp::2233-:22 -smp 2 -bios $clear_root/projects/common/image-creator/OVMF.fd
        sudo qemu-system-x86_64 -enable-kvm -m 1024 -vnc 0.0.0.0:0 -cpu host -drive file=$1,if=virtio,aio=threads -net nic,model=virtio -net user,hostfwd=tcp::2233-:22 -smp 2 -bios $clear_root/projects/common/image-creator/OVMF.fd
}

function runinst()
{
        echo sudo qemu-system-x86_64 -enable-kvm -m 1024 -vnc 0.0.0.0:0 -cpu host -drive file=installer-target.img,if=virtio,aio=threads -drive file=$1,if=virtio,aio=threads -net nic,model=virtio -drive file=installer-target.img,if=virtio,aio=threads -net user,hostfwd=tcp::2233-:22 -smp 2 -bios $clear_root/projects/common/image-creator/OVMF.fd
        # sudo qemu-system-x86_64 -enable-kvm -m 1024 -vnc 0.0.0.0:0 -cpu host -drive file=installer.img,if=virtio,aio=threads -net nic,model=virtio -drive file=installer-target.img,if=virtio,aio=threads -net user,hostfwd=tcp::2233-:22 -smp 2 -bios $clear_root/projects/common/image-creator/OVMF.fd
        sudo qemu-system-x86_64 -enable-kvm -m 1024 -vnc 0.0.0.0:0 -cpu host -drive file=installer-target.img,if=virtio,aio=threads -drive file=$1,if=virtio,aio=threads -net nic,model=virtio -drive file=installer-target.img,if=virtio,aio=threads -net user,hostfwd=tcp::2233-:22 -smp 2 -bios $clear_root/projects/common/image-creator/OVMF.fd
}

function runvminst()
{
        echo sudo qemu-system-x86_64 -enable-kvm -m 1024 -vnc 0.0.0.0:0 -cpu host -drive file=installer-target.img,if=virtio,aio=threads -drive file=installer.img,if=virtio,aio=threads -net nic,model=virtio -net user,hostfwd=tcp::2233-:22 -smp 2 -bios $clear_root/projects/common/image-creator/OVMF.fd
        sudo qemu-system-x86_64 -enable-kvm -m 1024 -vnc 0.0.0.0:0 -cpu host -drive file=installer-target.img,if=virtio,aio=threads -drive file=installer.img,if=virtio,aio=threads -net nic,model=virtio -net user,hostfwd=tcp::2233-:22 -smp 2 -bios $clear_root/projects/common/image-creator/OVMF.fd
}

function newtarget()
{
        echo '>' rm installer-target.img
        rm installer-target.img
        echo '>' qemu-img create installer-target.img 10G
        qemu-img create installer-target.img 10G
}

