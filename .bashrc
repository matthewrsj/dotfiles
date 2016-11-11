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

################################################################################
# Functions
################################################################################

# Automatically add completion for all aliases to commands having completion functions
# credit to http://superuser.com/a/437508
function alias_completion {
    local namespace="alias_completion"

    # parse function based completion definitions, where capture group 2 => function and 3 => trigger
    local compl_regex='complete( +[^ ]+)* -F ([^ ]+) ("[^"]+"|[^ ]+)'
    # parse alias definitions, where capture group 1 => trigger, 2 => command, 3 => command arguments
    local alias_regex="alias ([^=]+)='(\"[^\"]+\"|[^ ]+)(( +[^ ]+)*)'"

    # create array of function completion triggers, keeping multi-word triggers together
    eval "local completions=($(complete -p | sed -Ene "/$compl_regex/s//'\3'/p"))"
    (( ${#completions[@]} == 0 )) && return 0

    # create temporary file for wrapper functions and completions
    rm -f "/tmp/${namespace}-*.tmp" # preliminary cleanup
    local tmp_file; tmp_file="$(mktemp "/tmp/${namespace}-${RANDOM}XXX.tmp")" || return 1

    local completion_loader; completion_loader="$(complete -p -D 2>/dev/null | sed -Ene 's/.* -F ([^ ]*).*/\1/p')"

    # read in "<alias> '<aliased command>' '<command args>'" lines from defined aliases
    local line; while read line; do
        eval "local alias_tokens; alias_tokens=($line)" 2>/dev/null || continue # some alias arg patterns cause an eval parse error
        local alias_name="${alias_tokens[0]}" alias_cmd="${alias_tokens[1]}" alias_args="${alias_tokens[2]# }"

        # skip aliases to pipes, boolean control structures and other command lists
        # (leveraging that eval errs out if $alias_args contains unquoted shell metacharacters)
        eval "local alias_arg_words; alias_arg_words=($alias_args)" 2>/dev/null || continue
        # avoid expanding wildcards
        read -a alias_arg_words <<< "$alias_args"

        # skip alias if there is no completion function triggered by the aliased command
        if [[ ! " ${completions[*]} " =~ " $alias_cmd " ]]; then
            if [[ -n "$completion_loader" ]]; then
                # force loading of completions for the aliased command
                eval "$completion_loader $alias_cmd"
                # 124 means completion loader was successful
                [[ $? -eq 124 ]] || continue
                completions+=($alias_cmd)
            else
                continue
            fi
        fi
        local new_completion="$(complete -p "$alias_cmd")"

        # create a wrapper inserting the alias arguments if any
        if [[ -n $alias_args ]]; then
            local compl_func="${new_completion/#* -F /}"; compl_func="${compl_func%% *}"
            # avoid recursive call loops by ignoring our own functions
            if [[ "${compl_func#_$namespace::}" == $compl_func ]]; then
                local compl_wrapper="_${namespace}::${alias_name}"
                    echo "function $compl_wrapper {
                        (( COMP_CWORD += ${#alias_arg_words[@]} ))
                        COMP_WORDS=($alias_cmd $alias_args \${COMP_WORDS[@]:1})
                        (( COMP_POINT -= \${#COMP_LINE} ))
                        COMP_LINE=\${COMP_LINE/$alias_name/$alias_cmd $alias_args}
                        (( COMP_POINT += \${#COMP_LINE} ))
                        $compl_func
                    }" >> "$tmp_file"
                    new_completion="${new_completion/ -F $compl_func / -F $compl_wrapper }"
            fi
        fi

        # replace completion trigger by alias
        new_completion="${new_completion% *} $alias_name"
        echo "$new_completion" >> "$tmp_file"
    done < <(alias -p | sed -Ene "s/$alias_regex/\1 '\2' '\3'/p")
    source "$tmp_file" && rm -f "$tmp_file"
}; alias_completion

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

