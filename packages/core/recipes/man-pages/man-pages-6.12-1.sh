# Maintainer: Robin 'Ruadeil' Degen <mail@ruadeil.lgbt>

url="https://www.kernel.org/"
licenses=('man-pages-custom')
dependencies=()
build_dependencies=()
sources=("https://www.kernel.org/pub/linux/docs/man-pages/man-pages-${package_version}.tar.xz")
sha256sums=('b6cb5d67e0bb00a3b3f3d1bcb3fe06c26b045ba63923ed7ae79412350c5e1cb5')
package_options=()

handle_package() {
    cd $source_directory/man-pages-${package_version}
    make -R GIT=false prefix=$package_directory install
}
