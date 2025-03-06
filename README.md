# Aleya Linux

Welcome to the home of the Aleya Linux Distribution. This is currently work in progress

## What is it?

Aleya Linux is a new linux distribution that is being created from scratch. It is not intended to
be a replacement for any existing linux distro. It also does not claim to be better than any
of them. In fact, it likely isn't.

## Then why? What is it?

The author's idea behind Aleya Linux is mainly to "see if I can do it". The secondairy idea is
to provide a straightforward and simple example of how a distribution could be created by anyone.

Choises in any code are often made for simplicity over performance, security or any other requirement.

## Getting started

You can experiment with the current state of the package manager (alpaca) in the tools directory.

You can try the following command:

    ./alpaca.py install binutils

You can also specify a version:

    ./alpaca.py install binutils/2.44-1
    ./alpaca.py install binutils/lastest

Don't worry, this will not install anything to your regular system (yet).
You do **not** need to run this command as root.

## Warning!

Do **not** use this distribution as your main desktop or any production environment.
Packages will **not** contain required security updates, and the package manager itself is guaranteed to contain security flaws.

**Only use for educational purposes.**

## License

This project is released under the GPLv3.
