# Maintainer: Robin 'Ruadeil' Degen <mail@ruadeil.lgbt>

url="https://www.zlib.net/"
licenses=('bzip2')
dependencies=()
build_dependencies=()
sources=(
    "https://www.sourceware.org/pub/bzip2/bzip2-${package_version}.tar.gz"
    "bzip2-1.0.8-install_docs-1.patch"
)
sha256sums=(
    'ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269'
    'ff7fcefa9c6250eb2219dd6a8ed3505ae7ac9cb60a9577c33a29509d769955a9'
)
package_options=()

handle_sources() {
    cd bzip2-${package_version}
    patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch

    sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
    sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
}

handle_build() {
    export CFLAGS+=" ${c_flags}"

    cd $source_directory/bzip2-${package_version}

    make -f Makefile-libbz2_so
    make clean

    make ${make_flags}
}

handle_package() {
    cd ${source_directory}/bzip2-${package_version}
    make PREFIX=${package_directory}/usr install

    cp -av libbz2.so.* ${package_directory}/usr/lib
    ln -sv libbz2.so.1.0.8 ${package_directory}/usr/lib/libbz2.so

    cp -v bzip2-shared ${package_directory}/usr/bin/bzip2
    for i in ${package_directory}/usr/bin/{bzcat,bunzip2}; do
        ln -sfv bzip2 $i
    done

    rm -fv ${package_directory}/usr/lib/libbz2.a
}
