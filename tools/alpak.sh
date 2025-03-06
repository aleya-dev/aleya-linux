#!/bin/bash

if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
    echo "Error: Bash version 4.0 or higher is required." >&2
    exit 1
fi

_script_path=$(dirname $(realpath -s $0))
_package_sources="${_script_path}/../packages"
_package_cache="${_script_path}/../cache"

# Raise an error and close with an exit code.
# Usage: _raise_error "Error message"
_raise_error() {
    if [ -n "$1" ]; then
        echo "Error: $1" >&2
    else
        echo "An unknown error occurred." >&2
    fi

    exit 1
}

# Parse the given parameters and check if they are valid.
# Usage: _parse_parameters $@
_parse_parameters() {
    if [ "$#" -ne 2 ]; then
        _raise_error "Illegal number of parameters"
    fi

    _mode=$1
    _package_atom=$2

    # Check if the parameter is valid (must be install or remove)
    if [ "$_mode" != "install" ] && [ "$_mode" != "remove" ]; then
        _raise_error "Invalid parameter given"
    fi
}

# Parse the given package atom and check if it is valid.
# Usage:
#     _parse_atom "channel/name" $_package_info
#     _parse_atom "channel/name@version" $_package_info
#     _parse_atom $atom_parameter $_package_info
_parse_atom() {
    local -n _pkg_info=$2

    local _atom_parts=""
    IFS='@' read -r -a _atom_parts <<<"$1"

    if [ "${#_atom_parts[@]}" -eq 2 ]; then
        _pkg_info["version"]=${_atom_parts[1]}
    elif [ "${#_atom_parts[@]}" -eq 1 ]; then
        _pkg_info["version"]="latest"
    else
        _raise_error "Invalid package atom given. Must be either channel/name or channel/name@version."
    fi

    local _package_name_parts=""
    IFS='/' read -r -a _package_name_parts <<<"${_atom_parts[0]}"

    if [ "${#_package_name_parts[@]}" -ne 2 ]; then
        _raise_error "Invalid package name given"
    fi

    _pkg_info["channel"]=${_package_name_parts[0]}
    _pkg_info["name"]=${_package_name_parts[1]}
}

# Get the path of the package.
# Usage: path=$(_get_package_path $channel $name $version)
_get_full_package_path() {
    local -n _get_full_path_pkg_info=$1
    echo "$_package_sources/${_get_full_path_pkg_info['channel']}/recipes/${_get_full_path_pkg_info['name']}/${_get_full_path_pkg_info['name']}-${_get_full_path_pkg_info['version']}.sh"
}

# Check if the package exists in the given channel.
# Usage: _check_package $package_info
_check_package() {
    local -n _check_package_pkg_info=$1
    local _full_package_path=$(_get_full_package_path _check_package_pkg_info)

    echo $_full_package_path

    if [ ! -f "$_full_package_path" ]; then
        _raise_error "Package ${_check_package_pkg_info["name"]} (${_check_package_pkg_info["version"]}) not found in channel ${_check_package_pkg_info["channel"]}"
    fi
}

_create_temp_directories() {
    _temp_dir=$(mktemp -d)
    _temp_pkg_dir=$_temp_dir/packages
    _temp_pkg_info=$_temp_dir/package_info
}

_handle_install() {
    local -n _install_pkg_info=$1
    local _full_package_path=$(_get_full_package_path _install_pkg_info)

    echo "Installing package ${_install_pkg_info["name"]}..."
    source $_full_package_path


}

_handle_uninstall() {
    echo "Uninstalling package $_package_name"
    _raise_error "Currently unsupported."
}

blah() {
    # split by /
    IFS='/' read -r -a package_name_parts <<<"$package_name"

    # Check if the package name is valid
    if [ "${#package_name_parts[@]}" -ne 2 ]; then
        _raise_error "Invalid package name given"
    fi

    # Get the package type
    package_type=${package_name_parts[0]}
    package_name=${package_name_parts[1]}

    echo "Package type: $package_type"
    echo "Package name: $package_name"

    # Get current script path

    # get first parameter
    # $1

    source ./packages/core/recipes/binutils/binutils-2.44-1.sh

    # count: ${#pkgname[@]}
    # all elements: ${pkgname[@]}

    # iterate over all entries in pkgname
    for i in "${!pkgname[@]}"; do
        echo "Index: $i"
        echo "Value: ${pkgname[$i]}"
    done
}

# Call the function with all given parameters
_parse_parameters $@

declare -A _package_info
_parse_atom $_package_atom _package_info
_check_package _package_info

if [ "$_mode" == "install" ]; then
    _handle_install _package_info
else
    _handle_uninstall
fi
