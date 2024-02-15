fish_add_path -P /opt/homebrew/bin ~/.cargo/bin ~/.local/bin /bin /usr/bin
set -gx GPG_TTY (tty)
set -l uname "(uname)"
set -gx RUSTFLAGS "-Ctarget-cpu=native"

set -U FZF_COMPLETE 2
set -U FZF_PREVIEW_FILE_CMD "bat --color=always"

if status --is-interactive
  source (starship init fish --print-full-init | psub)

  if which lvim
      set -gx EDITOR lvim
      set -gx VISUAL lvim
  else if which nvim
      set -gx EDITOR nvim
      set -gx VISUAL nvim
  end

  if which bat
    abbr --add --global cat bat
  end

  if which rg
    abbr --add --global grep rg
  end

  if which exa
    abbr --add --global ls   exa
  end

  if which sccache
    set -gx RUSTC_WRAPPER sccache
  end

  if which zoxide
    zoxide init --cmd=cd fish | source
  end

  abbr --add --global j    journalctl --no-hostname -oshort-iso-precise --follow
  abbr --add --global g    git
  abbr --add --global ga   git add
  abbr --add --global gcp  git cherry-pick
  abbr --add --global gcpa git cherry-pick --abort
  abbr --add --global gcpc git cherry-pick --continue
  abbr --add --global gl   git log
  abbr --add --global glp  git log --patch
  abbr --add --global gmt  git mergetool
  abbr --add --global gpf  git push --force-with-lease
  abbr --add --global gp   git push
  abbr --add --global gpd  'git push --delete origin (git rev-parse --abbrev-ref HEAD)'
  abbr --add --global gpm  git push origin HEAD:master
  abbr --add --global gra  git rebase --abort
  abbr --add --global gras git rebase --interactive --autosquash --keep-base origin/HEAD
  abbr --add --global grc  git rebase --continue
  abbr --add --global grhh git reset --hard HEAD
  abbr --add --global grhu 'git reset --hard \'@{upstream}\''
  abbr --add --global gr   git rebase
  abbr --add --global gri  git rebase --interactive
  abbr --add --global r    rsync --verbose --progress --recursive -z -z
  abbr --add --global s    sudo
  abbr --add --global se   sudoedit
  abbr --add --global syu  'sudo pacman -Syyuu --noconfirm; sudo pacman -Sc --noconfirm'

  fortune | ponysay --wrap i
  thefuck --alias | source

  if ! set -q SSH_CONNECTION
    echo "starting gpg"
    set -e SSH_AUTH_SOCK; set -U -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    gpg-connect-agent updatestartuptty /bye >/dev/null
  end

  fish_vi_key_bindings

  tmux attach; or tmux
end
