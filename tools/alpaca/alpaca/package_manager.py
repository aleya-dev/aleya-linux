from alpaca.package import Package
from alpaca.package_description import Atom
from alpaca.configuration import config
from alpaca.logging import logger
import os


_LATEST_VERSION_IDENTIFIER = "latest"


class PackageManager:
    def __init__(self):
        self.packages: dict[str, Package] = {}

    def find_package(
        self, package_atom: str, throw_on_failure: bool = True
    ) -> Package | None:
        atom = self._resolve_package_atom_info(package_atom)

        if atom in self.packages:
            logger.verbose(f"Package {atom} loaded from cache")
            return self.packages[atom]

        for repo in config.repositories:
            logger.verbose(f"Searching for package {atom} in {repo}")

            for stream in config.package_streams:
                recipe_path = f"{repo}/{stream}/recipes/{atom.name}/{atom.name}-{atom.version}.sh"
                recipe_path2 = f"{repo}/{stream}/recipes/{atom.name}/{atom.name}-{atom.version}-{atom.release}.sh"

                if os.path.exists(recipe_path):
                    logger.verbose(f"Found package {atom} in {recipe_path}")

                    package = Package(atom, recipe_path)
                    self._add_package_to_cache(atom, package)
                    return package
                elif os.path.exists(recipe_path2):
                    logger.verbose(f"Found package {atom} in {recipe_path2}")

                    package = Package(atom, recipe_path2)
                    self._add_package_to_cache(atom, package)
                    return package

        if throw_on_failure:
            raise ValueError(f"Package {package_atom} not found in any repository")

        return None

    def _resolve_package_atom_info(self, atom_string: str) -> Atom:
        if "/" in atom_string:
            split_result = atom_string.split("/")

            if len(split_result) != 2:
                raise ValueError(f"Invalid package: {atom_string}")

            if split_result[0] == "" or split_result[1] == "":
                raise ValueError(f"Invalid package: {atom_string}")

            name = split_result[0]
            version = split_result[1]
        else:
            name = atom_string
            version = _LATEST_VERSION_IDENTIFIER

        if version == _LATEST_VERSION_IDENTIFIER:
            version = self._find_latest_package_version(name)

        (version, release) = self._parse_version_release_number(version)
        return Atom(name, version, release)

    def _parse_version_release_number(self, version: str) -> tuple[str, str]:
        version_split = version.split("-")

        if len(version_split) > 2:
            raise ValueError(f"Invalid version: {version}")

        if len(version_split) == 1:
            return version, "0"
        else:
            return version_split[0], version_split[1]

    def _add_package_to_cache(self, version: Atom, package: Package):
        self.packages[version] = package
        logger.verbose(f"Package {version} added to cache")

    def _find_latest_package_version(self, package_name: str) -> str:
        logger.info(f"Resolving latest version for package {package_name}")

        for repo in config.repositories:
            for stream in config.package_streams:
                latest_info_path = f"{repo}/{stream}/recipes/{package_name}/{_LATEST_VERSION_IDENTIFIER}"

                if os.path.exists(latest_info_path):
                    with open(latest_info_path, "r") as f:
                        result = f.read().strip()
                        logger.info(f"Latest version for package {package_name} is {result}")
                        return result

        raise ValueError(f"No package found for {package_name}")
