# Maintainer: Robin 'Ruadeil' Degen <mail@ruadeil.lgbt>

url="https://www.iana.org/protocols"
licenses=('MIT')
dependencies=()
build_dependencies=()
sources=("https://github.com/Mic92/iana-etc/releases/download/${package_version}/iana-etc-${package_version}.tar.gz")
sha256sums=('5a5958a39c1ea94080aa1d3983784b9fcaf81523c04b11e1459e26ad50a58292')
package_options=()

handle_package() {
    mkdir -p $package_directory/etc

    cd $source_directory/iana-etc-${package_version}/
    cp services protocols $package_directory/etc
}
