# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -v

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install

urlencode() {
  python3 -c "import urllib.parse; print(urllib.parse.quote('$1', safe=''))"
  # python3 -c "import urllib.parse; print(urllib.parse.quote('$1'))"
}
# urlencode() {
#   curl -s -o /dev/null -w "%{url_effective}" --get --data-urlencode "$1" "" | cut -c 3-
# }

op_lazy_var() {
  local var_name="$1"
  local item_name="$2"
  local field_name="${3:-password}"
  
  # Crea una función con el nombre de la variable
  eval "$var_name() {
    local value=\$(op item get \"$item_name\" --reveal --fields \"$field_name\")
    echo \"\$value\"
  }"
}
get_op_password() {
  op item get "$1" --reveal --fields password
}

export FPATH="$HOME/.zfunc:$FPATH"
fpath=( ~/.zfunc "${fpath[@]}" )
# fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)

autoload -U $fpath[1]/*(.:t)

# export ASDF_DATA_DIR="$HOME/.asdf"
export PATH="$PATH:/Users/ralbertomerinocolipe/Library/Application Support/Coursier/bin"
export PATH="$PATH:/Users/ralbertomerinocolipe/.gem/ruby/3.3.0/bin"
export PATH="/usr/local/bin:$PATH"
export PATH=~/.local/bin/:$PATH
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/libxslt/bin:$PATH"
export PATH="/usr/local/opt/wxwidgets/bin:$PATH"
export PKG_CONFIG_PATH="/usr/local/opt/libxslt/lib/pkgconfig"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
# export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export PATH="/usr/local/opt/mysql-client@8.4/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"
export PATH="$HOME/Programs/elixir_ls:$PATH"
export PATH="$HOME/workspaces/tutoriales/kafka/bin:$PATH"
 
# export LDFLAGS="-L/usr/local/opt/libxslt/lib"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# export CPPFLAGS="-I/usr/local/opt/libxslt/include"
export LDFLAGS="-L/usr/local/opt/wxwidgets/lib"
export CPPFLAGS="-I/usr/local/opt/wxwidgets/include"
export pkg_config_path="/usr/local/opt/wxwidgets/lib/pkgconfig"


export CLOUDSMITH_USERNAME=rodrigo-alberto-merino-colipe
export CLOUDSMITH_API_KEY=$(security find-generic-password -a "sustainability" -s "CLOUDSMITH_API_KEY" -w)


export NPM_TOKEN=4f8441a17e4dc506bc2b291b332581e74336a78d

export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
export TERM=xterm-256color

export LES_DB_STG_8_PWD=$(security find-generic-password -a "$USER" -s "LES_BD_STG_8_PSW" -w)
export LES_DB_LT_8_PWD=$(security find-generic-password -a "$USER" -s "LES_BD_LT_PSW" -w)
export LES_DB_LT_7_PWD=$(security find-generic-password -a "$USER" -s "LES_BD_LT_7_PSW" -w)
export LES_DB_EUPROD_7_PWD=$(security find-generic-password -a "$USER" -s "LES_BD_EUPROD_7_PSW" -w)
export LES_DB_EUPROD_7_W_PWD=$(security find-generic-password -a "$USER" -s "LES_BD_EUPROD_7_W_PSW" -w)
export LES_DB_PROD_7_PWD=$(security find-generic-password -a "$USER" -s "LES_BD_PROD_7_PSW" -w)
export LES_DB_EUPROD_8_PWD=$(security find-generic-password -a "$USER" -s "LES_BD_EUPROD_8_PSW" -w)


export ANSIBLE_BECOME_PASS=$(security find-generic-password -a "Infrastructure" -s "Infrastructure" -w)
export DD_API_KEY=$(security find-generic-password -a "sustainability" -s "DD_API_KEY" -w)
export HOMEBREW_GITHUB_API_TOKEN=$(security find-generic-password -a "sustainability" -s "HOMEBREW_GITHUB_API_TOKEN" -w)

# Export secrets

export LES_LT_DB_8_URL="mysql://root:${LES_DB_LT_8_PWD}@127.0.0.1:50001/les"
export LES_LT_DB_7_URL="mysql://root:${LES_DB_LT_7_PWD}@127.0.0.1:50002/les"
export LES_EUPROD_DB_7_URL="mysql://human:${LES_DB_EUPROD_7_PWD}@127.0.0.1:50003/les"
export LES_EUPROD_DB_7_W_URL="mysql://les_creator:${LES_DB_EUPROD_7_W_PWD}@127.0.0.1:50003/les"
export LES_EUPROD_DB_8_URL="mysql://root:${LES_DB_EUPROD_8_PWD}@127.0.0.1:50004/les"

export LES_STG_DB_8_URL="mysql://les_creator:${LES_DB_STG_8_PWD}@127.0.0.1:50006/les"

export LES_PROD_DB_7_URL="mysql://root:${LES_DB_PROD_7_PWD}@127.0.0.1:50005/les"




alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias ec='nvim $HOME/.zshrc'
alias sc='source $HOME/.zshrc'
alias n='nvim'

alias aws_euprod_log='saml2aws login --profile=pd-kubectx --role=arn:aws:iam::564378396095:role/terraform/sustainability-engineer --force --skip-prompt --duo-mfa-option=Passcode --quiet'



alias -g tunnel_stg_les_db_8="ssh -v -N stg-les-db-mysql8"

alias -g tunnel_stg_les_db_8="ssh -v -N stg-les-db-mysql8"
alias -g tunnel_lt_les_db_7="ssh -v -N lt-les-db-mysql7"
alias -g tunnel_lt_les_db_8="ssh -v -N lt-les-db-mysql8"
alias -g tunnel_euprod_les_db_7="ssh -v -N euprod-les-db-mysql7"
alias -g tunnel_euprod_les_db_8="ssh -v -N euprod-les-db-mysql8"

alias -g tunnel_lt_fos_db="ssh -v -N lt-fos-db"

alias ezsh="nvim $HOME/.zshrc"
alias rzsh="source $HOME/.zshrc"
alias envim="cd $HOME/.config/nvim && nvim"

# Setup bindings for both smkx and rmkx key variants
# Home
bindkey '\e[H'  beginning-of-line
bindkey '\eOH'  beginning-of-line
# End
bindkey '\e[F'  end-of-line
bindkey '\eOF'  end-of-line

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8


load_fos_lt() {
  tunnel_lt_fos_db
  op_lazy_var FLEX_SERVICE_LT_PWD "LT Flex Human WR"
  export FLEX_OBJ_SERV_LT_DB_URL="mysql://flex_human_wr:$(urlencode $(FLEX_SERVICE_LT_PWD))@127.0.0.1:50010/objects_services_app"
}

. $(brew --prefix asdf)/libexec/asdf.sh
# eval "$(starship init zsh)"

# . /usr/local/opt/asdf/libexec/asdf.sh
eval "$(rbenv init -)"

