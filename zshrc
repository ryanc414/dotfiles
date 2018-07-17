# Define __git_files to prevent really slow autocompletion on large repos
__git_files () {
  _files
}

[[ -n "$SSH_CLIENT" ]] || export DEFAULT_USER=$(whoami)

source ~/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle go
antigen bundle command-not-found
# antigen bundle tmuxinator
antigen bundle taskwarrior
antigen bundle colored-man-pages
antigen bundle sudo

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# z plugin for navigation
antigen bundle rupa/z

# k command for colourful ls
antigen bundle supercrabtree/k

# 'sensible' defaults
antigen bundle willghatch/zsh-saneopt

# Load the theme.
export ZSH_THEME="agnoster"
export BULLETTRAIN_PROMPT_SEPARATE_LINE=false
export BULLETTRAIN_PROMPT_ADD_NEWLINE=false
export BULLETTRAIN_EXEC_TIME_SHOW=true
export BULLETTRAIN_GIT_EXTENDED=false # Simple 'is workspace dirty' only to save time on large codebases
BULLETTRAIN_PROMPT_ORDER=(time status custom context dir perl ruby virtualenv aws go elixir git hg cmd_exec_time)
antigen theme https://github.com/caiogondim/bullet-train-oh-my-zsh-theme bullet-train

# Tell antigen that you're done.
antigen apply

# Needed for ctrl-x ctrl-e to work for some reason...
export EDITOR=vim

# Alias
alias gotest='go test -v . | sed ''/PASS/s//$(printf "\033[32;1mPASS\033[0m")/'' | sed ''/FAIL/s//$(printf "\033[31;1mFAIL\033[0m")/'' | sed ''/RUN/s//$(printf "\033[0;1mRUN\033[0m")/'''
## For tmux to work in 256 colour mode
alias tmux='TERM=xterm-256color tmux'
## Alias for next task
alias tn='tasknote'
alias ts='task summary'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ll -h'
alias cdb='cd $CB_ROOT'
alias cdd='cd /data'
alias grep='grep --color -I'
alias cddebug='cd $CB_ROOT/output/jobs/lnx64/fv/debug'
alias cdrelease='cd $CB_ROOT/output/jobs/lnx64/fv/release'
alias ls=exa
alias sub=sublime
alias fls='firefox ${CB_ROOT}/output/autogen/rdf/fls.html &'
alias gitlab='~/bin/gitlab'
alias spython='python3.7'
alias bob='cdb && bob'
alias scoop='cdb && scoop'
alias cds='cd ~/sprint/sprint_scripts'
alias cdpdk='cd ~/code/ms-dpdk'

# Path
export PATH=$PATH:~/path/

# FZF - needs installing so only source if installed.
if [ -f ~/.fzf.zsh ]
then
  source ~/.fzf.zsh
fi

# Don't share history
setopt no_share_history

# Terminal type
export TERM="xterm-256color"

# Colour scheme for tasknote
# Do `mdv -t all | less` to explore other options.
export AXC_THEME=884.0134

# Context-specifics
if [ -f ~/.zshrc_user ]
then
  source ~/.zshrc_user
fi

alias bob='cdb && bob'

# DCM directories
export DCMBASE="$HOME/code/dcm"
export DCMFV="$DCMBASE/lvs/craft/licservcraft/fv/"

# Used for perifv build
export BUILD_TYPE=debug
export DOCKER_SOCKET="/var/run/docker.sock"

# Shell functions
fvd()
{
  cddebug && fvrun "$@"
  cd - > /dev/null
}

fvr()
{
  cdrelease && fvrun "$@"
  cd - > /dev/null
}

fix_zsh()
{
  rm -f ~/.zcompdump*
  rm -f ~/.antigen/.zcompdump*
  exec zsh
}

make_undercloud()
{
  cd ~/sprint/undercloud && sudo mkisofs -o ~/sprint/rhel7.3-undercloud.iso -U -r -v -T -J -joliet-long -V "RHEL-7.3 Server.x86_64" -volset "RHEL-7.3 Server.x86_64" -A "RHEL-7.3 Server.x86_64" -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e images/efiboot.img -no-emul-boot .
}

package_sprint_scripts()
{
  cd ~/sprint/sprint_scripts
  tar -czvf config_scripts.tar.gz *
  mkisofs -o config_scripts.iso config_scripts.tar.gz
  rm -f config_scripts.tar.gz
}

# Compile and extract the DSP FVs onto periR730.
extract_dspdpfv()
{
  # Execute in a sub-shell so we can bail out on error.

  (
    set -e

    if [[ $# -lt 1 ]]
    then
      echo "Usage: $0 [version]"
      exit 1
    fi

    VERSION="$1"

    # Make octapi and the dsp FVs
    scoop make octapi TARGET=production_release
    scoop make dspdpfv_package TARGET=fv_debug

    # Copy files onto perir730
    scp ${CB_ROOT}/output/jobs/lnx64/production/release/liboctapi.so "root@perir730-a.aaa:/disk0.7/opt/MetaSwitch/Version/$1/lib/liboctapi.so"
    scp ${CB_ROOT}/output/jobs/lnx64/fv/debug/dspdpfv.tgz root@perir730-a.aaa:/disk0.7/dsp-dpfv/

    # Untar the DSP FVs
    ssh -t root@perir730-a.aaa "cd /disk0.7/dsp-dpfv/ && tar -xzvf dspdpfv.tgz && rm dspdpfv.tgz"
  )
}

docker_kill()
{
  docker rm $(docker ps --filter "status=exited" -q)
}

# Convenience function to wrap jenkins_upg_perimeta.py, setting up the
# PYTHONPATH as needed.
# Uses the SLOTH framework to automatically upgrade a perimeta.
upgrade_perimeta()
{
    # Execute in sub-shell so that PYTHONPATH changes are local.
    (
        PYTHONPATH="${CB_ROOT}/orlando/test/sloth2:${CB_ROOT}/orlando/python/legacy:${CB_ROOT}/orlando/python/packages:${CB_ROOT}/orlando/python/scripts"
        python "${CB_ROOT}/orlando/python/scripts/jenkins/jenkins_upg_perimeta.py" "$@"
    )
}

permoans()
{
  (cd ${CB_ROOT} && python ${CB_ROOT}/orlando/python/scripts/permoans.py)
}

# Output this week's time log from the base template.
calc_times()
{
  python "$HOME/times/times.py"
}

# Open the most recent ipstrc drw file. For simplicity assume extended names
# aren't in use.
ipstrc()
{
  sub "$CB_ROOT/output/jobs/lnx64/fv/debug/ipstrc.drw"
}

# Open the most recent inttrc file. For simplicity assume extended names aren't
# in use.
inttrc()
{
  sub "$CB_ROOT/output/jobs/lnx64/fv/debug/inttrc.log"
}

# ... and the same for PD trace
pdtrc()
{
  sub "$CB_ROOT/output/jobs/lnx64/fv/debug/pdtrc.log"
}

nbini()
{
  vim "$CB_ROOT/output/jobs/lnx64/fv/debug/nbase.ini"
}

errno()
{
  vim -p /usr/include/asm-generic/errno{,-base}.h
}

set_expected()
{
    \cp -f "$DCMFV/actual/$1/fv_out" "$DCMFV/expected/$1/fv_expected"
    \cp -f "$DCMFV/actual/$1/orch_out" "$DCMFV/expected/$1/orch_expected"
}

cddcm()
{
    cd "$DCMBASE"
}

cddcmfv()
{
    cd "$DCMFV"
}

sizes()
{
    du -h "$1" | sort -h | tail -n 30
}

start_fv_containers()
{
    sudo -E docker-compose pull && sudo -E docker-compose up -d --force-recreate
}

start_fv_instances()
{
    docker exec fv_ssc-a_1 /perifv/localscripts/start_vpcn.sh
    docker exec fv_ssc-b_1 /perifv/localscripts/start_vpcn.sh
}

stop_fv_instances()
{
    docker exec fv_ssc-a_1 /perifv/localscripts/stop_vpcn.sh
    docker exec fv_ssc-b_1 /perifv/localscripts/stop_vpcn.sh
}

docker_shell()
{
    (
        if [[ $# -lt 1 ]]; then
            echo "Specify image name"
            exit 1
        fi

        docker exec -it "$1" /bin/bash
    )
}

cdfv()
{
    cd "$CB_ROOT/orlando/test/fv"
}

fvr2()
{
    "$CB_ROOT/orlando/python/scripts/multifv/fvrun2.py" "$@"
}

