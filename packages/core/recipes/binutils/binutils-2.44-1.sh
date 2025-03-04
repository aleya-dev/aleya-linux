# Maintainer: Robin 'Ruadeil' Degen <mail@ruadeil.lgbt>

url="https://www.gnu.org/software/binutils/"
licenses=('GPLv3')
dependencies=()
build_dependencies=()
sources=("https://ftp.gnu.org/gnu/binutils/binutils-${package_version}.tar.xz")
sha256sums=('ce2017e059d63e67ddb9240e9d4ec49c2893605035cd60e92ad53177f4377237')
package_options=('testoption')

handle_build() {
    export CFLAGS+=" ${c_flags}"

    cd $build_directory
    $source_directory/binutils-${package_version}/configure --prefix=/usr \
        --target=${target_architecture}-${target_platform} \
        --disable-nls \
        --enable-gprofng=no \
        --disable-werror \
        --enable-new-dtags \
        --enable-default-hash-style=gnu

    make ${make_flags}
}

handle_package() {
    cd $build_directory
    make DESTDIR=$package_directory install
}
