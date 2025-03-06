from alpaca.configuration import config
from alpaca.logging import logger, enable_debug_logging, enable_verbose_logging
from alpaca.package_manager import PackageManager

import argparse

import importlib.metadata
__version__ = importlib.metadata.version("alpaca")


def _create_arg_parser():
    parser = argparse.ArgumentParser(
        description=f"AlpaCA - The Aleya Package Configuration Assistant ({__version__})"
    )
    parser.add_argument(
        "--verbose", "-v", action="store_true", help="Enable verbose output"
    )
    parser.add_argument(
        "--debug", "-d", action="store_true", help="Enable debug output"
    )
    parser.add_argument(
        "--quiet",
        "-q",
        action="store_true",
        help="Limit build and copy output to errors only",
    )
    parser.add_argument(
        "--version",
        action="version",
        version=f"AlpaCA version: {__version__}",
    )

    subparsers = parser.add_subparsers(dest="command", help="Subcommand help")
    install_parser = subparsers.add_parser("install", help="Install a package")
    install_parser.add_argument(
        "package",
        type=str,
        help="Name of the package to install (e.g. binutils or binutils-2.44-1)",
    )
    install_parser.add_argument(
        "--build",
        "-b",
        action="store_true",
        help="Build the package from source, even if a prebuilt binary is available",
    )

    remove_parser = subparsers.add_parser("remove", help="Remove a package")
    remove_parser.add_argument(
        "package",
        type=str,
        help="Name of the package to remove (e.g. binutils or binutils-2.44-1)",
    )

    return parser


def _handle_install(package_atom: str, build_from_source: bool):
    package_manager = PackageManager()
    package = package_manager.find_package(package_atom)
    package.build(build_from_source)


def main():
    try:
        parser = _create_arg_parser()
        args = parser.parse_args()

        logger.debug("This software is provided under GNU GPL v3.0")
        logger.debug("This software comes with ABSOLUTELY NO WARRANTY")
        logger.debug(
            "This software is free software, and you are welcome to redistribute it under certain conditions"
        )
        logger.debug(
            "For more information, visit https://www.gnu.org/licenses/gpl-3.0.html"
        )

        if args.debug:
            config.debug = True

        if config.debug:
            enable_debug_logging()

        if args.verbose:
            config.verbose = True

        if config.verbose:
            enable_verbose_logging()
            logger.verbose("Verbose output enabled")

        if args.quiet:
            config.suppress_build_output = True

        if args.command == 'install':
            _handle_install(args.package, args.build)
        elif args.command == 'remove':
            pass
        else:
            parser.print_help()
    except Exception as e:
        logger.error(f"An error occurred: {e}")
        logger.verbose("Stack trace:", exc_info=True)
        exit(1)


if __name__ == "__main__":
    main()
