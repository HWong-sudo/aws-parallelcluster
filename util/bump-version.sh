#!/bin/bash

set -ex

# On Mac OS, the default implementation of sed is BSD sed, but this script requires GNU sed.
if [ "$(uname)" == "Darwin" ]; then
  command -v gsed >/dev/null 2>&1 || { echo >&2 "[ERROR] Mac OS detected: please install GNU sed with 'brew install gnu-sed'"; exit 1; }
  PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
fi

_error_exit() {
   echo "$1"
   exit 1
}

_help() {
    local -- _cmd=$(basename "$0")

    cat <<EOF

  Usage: ${_cmd} [OPTION]...

  Bump ParallelCluster version.

  --version <version>                                               ParallelCluster version
  --plugin-interface-version <plugin-interface-version>             SchedulerPlugin interface version
  -h, --help                                                        Print this help message
EOF
}

main() {
    # parse input options
    while [ $# -gt 0 ] ; do
        case "$1" in
            --version)                            _version="$2"; shift;;
            --version=*)                          _version="${1#*=}";;
            --plugin-interface-version)           _plugin_interface_version="$2"; shift;;
            --plugin-interface-version=*)         _plugin_interface_version="${1#*=}";;
            -h|--help|help)                       _help; exit 0;;
            *)                                    _help; _error_exit "[error] Unrecognized option '$1'";;
        esac
        shift
    done

    # verify required parameters
    if [ -z "${_version}" ]; then
        _error_exit "--version parameter not specified"
        _help;
    else
        NEW_VERSION=$_version
        NEW_VERSION_SHORT=$(echo ${NEW_VERSION} | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+")
        CURRENT_VERSION=$(sed -ne "s/^VERSION = \"\(.*\)\"/\1/p" cli/setup.py)
        CURRENT_VERSION_SHORT=$(echo ${CURRENT_VERSION} | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+")
        sed -i "s/VERSION = \"$CURRENT_VERSION\"/VERSION = \"$NEW_VERSION\"/g" cli/setup.py

        sed -i "s/\"parallelcluster\": \"$CURRENT_VERSION\"/\"parallelcluster\": \"$NEW_VERSION\"/g" cli/src/pcluster/constants.py
        sed -i "s/aws-parallelcluster-cookbook-$CURRENT_VERSION/aws-parallelcluster-cookbook-$NEW_VERSION/g" cli/src/pcluster/constants.py

        sed -i "s|pcluster-api:$CURRENT_VERSION|pcluster-api:$NEW_VERSION|g" api/infrastructure/parallelcluster-api.yaml
        sed -i "s|parallelcluster/$CURRENT_VERSION|parallelcluster/$NEW_VERSION|g" api/infrastructure/parallelcluster-api.yaml
        sed -i "s| Version: $CURRENT_VERSION| Version: $NEW_VERSION|g" api/infrastructure/parallelcluster-api.yaml
        sed -i "s| ShortVersion: $CURRENT_VERSION_SHORT| ShortVersion: $NEW_VERSION_SHORT|g" api/infrastructure/parallelcluster-api.yaml
    fi

    if [ "${_plugin_interface_version}" ]; then
        NEW_VERSION=$_plugin_interface_version
        CURRENT_VERSION=$(sed -ne "s/^SCHEDULER_PLUGIN_INTERFACE_VERSION = \"\(.*\)\"/\1/p" tests/integration-tests/constants.py)
        sed -i "s/SCHEDULER_PLUGIN_INTERFACE_VERSION = packaging.version.Version(\"$CURRENT_VERSION\")/SCHEDULER_PLUGIN_INTERFACE_VERSION = packaging.version.Version(\"$NEW_VERSION\")/g" cli/src/pcluster/constants.py
        sed -i "s/SCHEDULER_PLUGIN_INTERFACE_VERSION = \"$CURRENT_VERSION\"/SCHEDULER_PLUGIN_INTERFACE_VERSION = \"$NEW_VERSION\"/g" tests/integration-tests/constants.py
    fi
}

main "$@"

# vim:syntax=sh
