## Functions used for user choice

draw_menu() {
    local cursor=$1
    shift
    local menu=("$@")
    for item in "${menu[@]}"; do
        if [[ ${menu[$cursor]} == $item ]]; then
            printf "%s\n" "${FONT_BOLD} > $item${FONT_DEFAULT}"
        else
            printf "%s\n" "   $item"
        fi
    done
}

clear_menu()  {
    local menu=("$@")
    for i in "${menu[@]}"; do printf "${CURSOR_UP}"; done
    printf "${CLEAR_SCREEN}"
}

key_input() {
    local key=$1
    read -sN1 -t 0.0001 k1; read -sN1 -t 0.0001 k2; read -sN1 -t 0.0001 k3
    key+=${k1}${k2}${k3}
    case "$key" in
        $'\e[A'|$'\e0A'|$'\e[D'|$'\e0D') printf "%s" "up";;
        $'\e[B'|$'\e0B'|$'\e[C'|$'\e0C') printf "%s" "down";;
        $'\e[1~'|$'\e0H'|$'\e[H') printf "%s" "begin";;
        $'\e[4~'|$'\e0F'|$'\e[F') printf "%s" "end";;
        $'\e') printf "%s" "escape";;
        $'\x0a'|"") printf "%s" "enter";;
        " ") printf "%s" "space";;
        *) printf "%s" "$key";;
    esac
}

output_menu () {
    local cursor=0
    local menu=("$@")
    draw_menu "$cursor" "${menu[@]}"
    printf "${CURSOR_OFF}"
    while read -sN1 key; do
        case "$(key_input $key)" in
            up) [[ $cursor -eq 0 ]] && cursor=$(( ${#menu[@]} - 1 )) || cursor=$(( $cursor - 1 ));;
            down) [[ $cursor -eq $(( ${#menu[@]} - 1 )) ]] && cursor=0 || cursor=$(( $cursor + 1 ));;
            begin) cursor=0;;
            end) cursor=$(( ${#menu[@]} - 1 ));;
            escape|q) exit;;
            enter|space) break;;
            *);;
        esac
        clear_menu "${menu[@]}"
        draw_menu "$cursor" "${menu[@]}"
    done
    printf "${CURSOR_ON}"
    return $cursor
}

selector() {
    local choices=("$@")
    output_menu "${choices[@]}" 1>&2
    local result=$?
    [ ! -z "$result" ] && printf "%s" "$result"
}
