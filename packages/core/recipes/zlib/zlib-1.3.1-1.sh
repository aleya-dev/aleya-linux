# Maintainer: Robin 'Ruadeil' Degen <mail@ruadeil.lgbt>

url="https://www.zlib.net/"
licenses=('zlib')
dependencies=()
build_dependencies=()
sources=("https://zlib.net/fossils/zlib-${package_version}.tar.gz")
sha256sums=('9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23')
package_options=()

handle_build() {
    export CFLAGS+=" ${c_flags}"

    cd $build_directory
    $source_directory/zlib-${package_version}/configure \
        --prefix=/usr

    make ${make_flags}
}

handle_check() {
    cd $build_directory
    make ${make_flags} check
}

handle_package() {
    cd $build_directory
    make DESTDIR=$package_directory install

    rm -f $package_directory/usr/lib/libz.a
}
