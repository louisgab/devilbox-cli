## Functions used to manipulate a x.x.x version number

is_semver() {
    local version=$1
    [[ $version =~ ^[:digit:]+\.[:digit:]+\.[:digit:]\+$ ]]
}

get_major(){
    local version=$1
    local major
    is_semver "$version" || return "$KO_CODE"
    major=$(echo ${version//./ } | awk '{print $1}')
    was_success && printf "%s" "$major"
}

get_minor(){
    local version=$1
    local minor
    is_semver "$version" || return "$KO_CODE"
    minor=$(echo ${version//./ } | awk '{print $2}')
    was_success && printf "%s" "$minor"
}

get_patch(){
    local version=$1
    local patch
    is_semver "$version" || return "$KO_CODE"
    patch=$(echo ${version//./ } | awk '{print $3}')
    was_success && printf "%s" "$patch"
}

has_newer_major(){
    local version1=$1
    local version2=$2
    local major1
    local major2
    major1="$(get_major "$version1")"
    was_success || return "$KO_CODE"
    major2="$(get_major "$version2")"
    was_success || return "$KO_CODE"
    [[ $major1 -gt $major2 ]]
}

has_newer_minor(){
    local version1=$1
    local version2=$2
    local minor1
    local minor2
    minor1="$(get_minor "$version1")"
    was_success || return "$KO_CODE"
    minor2="$(get_minor "$version2")"
    was_success || return "$KO_CODE"
    [[ $minor1 -gt $minor2 ]]
}

has_newer_patch(){
    local version1=$1
    local version2=$2
    local patch1
    local patch2
    patch1="$(get_patch "$version1")"
    was_success || return "$KO_CODE"
    patch2="$(get_patch "$version2")"
    was_success || return "$KO_CODE"
    [[ $patch1 -gt $patch2 ]]
}

is_version_newer() {
    local version1=$1
    local version2=$2
    has_newer_major "$version1" "$version2" && return "$OK_CODE"
    has_newer_minor "$version1" "$version2" && return "$OK_CODE"
    has_newer_patch "$version1" "$version2" && return "$OK_CODE"
    return "$KO_CODE"
}
