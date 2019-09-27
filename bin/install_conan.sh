#!/usr/bin/env bash
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

# shellcheck source=utils.sh
. "$SCRIPT_DIR/utils.sh"

getosver

if [[ "$(uname -s)" == "Linux" ]]; then
    if ! which conan &> /dev/null; then
        if pip install conan; then
            echo "Conan installed."
        else
            echo "Unable to install conan."
            exit 1
        fi
    fi
    # We need to build from scratch on Alpine, so we
    # don't end up linking GCC _chk symbols.
    conan install . -s compiler.libcxx=libstdc++11 --build boost --build bzip2 --build zlib --build OpenSSL
else
    if ! which conan &> /dev/null; then
        if brew install conan; then
            brew link conan
            echo "Conan installed."
            conan install .
        else
            exit 1
        fi
    fi
    conan install .
fi
