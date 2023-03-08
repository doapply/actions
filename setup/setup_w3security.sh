#!/bin/bash
set -e

# This script takes two positional arguments. The first is the version of w3security to install.
# This can be a standard version (ie. v1.390.0) or it can be latest, in which case the
# latest released version will be used.
#
# The second argument is the platform, in the format used by the `runner.os` context variable
# in GitHub Actions. Note that this script does not currently support Windows based environments.
#
# As an example, the following would install the latest version of w3security for GitHub Actions for
# a Linux runner:
#
#     ./w3security-setup.sh latest Linux
#

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 2 ] || die "Setup w3security requires two argument, $# provided"

cd "$(mktemp -d)"

echo "Installing the $1 version of w3security on $2"

VERSION=$1
BASE_URL="https://static.w3security.io/cli"

case "$2" in
    Linux)
        PREFIX=linux
        ;;
    Windows)
        die "Windows runner not currently supported"
        ;;
    macOS)
        PREFIX=macos
        ;;
    *)
        die "Invalid running specified: $2"
esac

{
    echo "#!/bin/bash"
    echo export W3SECURITY_INTEGRATION_NAME="GITHUB_ACTIONS"
    echo export W3SECURITY_INTEGRATION_VERSION=\"setup \(${2}\)\"
    echo export FORCE_COLOR=2
    echo eval w3security-${PREFIX} \$@
} > w3security

chmod +x w3security
sudo mv w3security /usr/local/bin

wget --progress=bar:force:noscroll "$BASE_URL/$VERSION/w3security-${PREFIX}"
wget --progress=bar:force:noscroll "$BASE_URL/$VERSION/w3security-${PREFIX}.sha256"

sha256sum -c w3security-${PREFIX}.sha256
chmod +x w3security-${PREFIX}
sudo mv w3security-${PREFIX} /usr/local/bin
rm -rf w3security*
