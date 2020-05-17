# ~/.bashrc: executed by bash(1) for non-login shells.

# Setup a red color for STDERR
exec 9>&2
exec 8> >(
    while IFS='' read -r line || [ -n "$line" ]; do
       echo -e "\033[31m${line}\033[0m"
    done
)
function undirect(){ exec 2>&9; }
function redirect(){ exec 2>&8; }
trap "redirect;" DEBUG
PROMPT_COMMAND='undirect;'

# Setup a red prompt for root and a green one for users.
NORMAL="\[\e[0m\]"
ROOT_COLOR="\[\e[1;31m\]" # RED
USER_COLOR="\[\e[1;32m\]" # GREEN
if [ "$USER" = root ]; then
        PS1="$ROOT_COLOR\h [$NORMAL\w$ROOT_COLOR]# $NORMAL"
else
        PS1="$USER_COLOR\h [$NORMAL\w$USER_COLOR]\$ $NORMAL"
fi


println() {
  # Reset
  Color_Off='\033[0m'       # Text Reset

  # Regular Colors
  Black='\033[0;30m'        # Black
  Red='\033[0;31m'          # Red
  Green='\033[0;32m'        # Green
  Yellow='\033[0;33m'       # Yellow
  Blue='\033[0;34m'         # Blue
  Purple='\033[0;35m'       # Purple
  Cyan='\033[0;36m'         # Cyan
  White='\033[0;37m'        # White

  # Bold
  BBlack='\033[1;30m'       # Black
  BRed='\033[1;31m'         # Red
  BGreen='\033[1;32m'       # Green
  BYellow='\033[1;33m'      # Yellow
  BBlue='\033[1;34m'        # Blue
  BPurple='\033[1;35m'      # Purple
  BCyan='\033[1;36m'        # Cyan
  BWhite='\033[1;37m'       # White

  # Underline
  UBlack='\033[4;30m'       # Black
  URed='\033[4;31m'         # Red
  UGreen='\033[4;32m'       # Green
  UYellow='\033[4;33m'      # Yellow
  UBlue='\033[4;34m'        # Blue
  UPurple='\033[4;35m'      # Purple
  UCyan='\033[4;36m'        # Cyan
  UWhite='\033[4;37m'       # White

  # Background
  On_Black='\033[40m'       # Black
  On_Red='\033[41m'         # Red
  On_Green='\033[42m'       # Green
  On_Yellow='\033[43m'      # Yellow
  On_Blue='\033[44m'        # Blue
  On_Purple='\033[45m'      # Purple
  On_Cyan='\033[46m'        # Cyan
  On_White='\033[47m'       # White

  # High Intensity
  IBlack='\033[0;90m'       # Black
  IRed='\033[0;91m'         # Red
  IGreen='\033[0;92m'       # Green
  IYellow='\033[0;93m'      # Yellow
  IBlue='\033[0;94m'        # Blue
  IPurple='\033[0;95m'      # Purple
  ICyan='\033[0;96m'        # Cyan
  IWhite='\033[0;97m'       # White

  # Bold High Intensity
  BIBlack='\033[1;90m'      # Black
  BIRed='\033[1;91m'        # Red
  BIGreen='\033[1;92m'      # Green
  BIYellow='\033[1;93m'     # Yellow
  BIBlue='\033[1;94m'       # Blue
  BIPurple='\033[1;95m'     # Purple
  BICyan='\033[1;96m'       # Cyan
  BIWhite='\033[1;97m'      # White

  local code="\033["
  case "$1" in
    black   | bk) color="${Black}";;
    red     |  r) color="${Red}";;
    green   |  g) color="${Green}";;
    yellow  |  y) color="${Yellow}";;
    blue    |  b) color="${Blue}";;
    purple  |  p) color="${Purple}";;
    cyan    |  c) color="${Cyan}";;
    white   | wh) color="${White}";;
    info    |  i) color="${Blue}";;
    warn    |  w) color="${Yellow}";;
    error   |  e) color="${Red}";;
    sucsess | ok) color="${Green}";;
    *) local text="$1"
  esac
  [ -z "$text" ] && local text="$color$2${code}0m"
  echo -e "$text"
}

alias print=println