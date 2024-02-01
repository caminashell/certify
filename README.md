# Certify

Certify is a simple utility to create self-signed certificates for SSL/TLS to work on networks that do not have a public domain, like an HTTP server on a private network or your computer (localhost).

- Written in shell script and compiled with [SHC](https://github.com/neurobin/shc) (Shell Script Compiler) for distribution.
- This has been repurposed mainly for Linux, but feel free to adjust it for MacOS.
- It will not work on WindowsPC unless you use the Windows Subsystem for Linux (WSL).

## Requirements

- `openssl` - To generate RSA keys for the certificates.[^1]
- `tar` - For packing the certificates into an archive file.[^2]
- `make` - To easily run execution scripts on the project.[^3]
- `shc` - For compiling the script for use and/or distribution.[^4]

### Installation

After cloning this repository to your workspace, first build the program:

```sh
make
make install
```

Optionally, to relax security. Make a redistributable binary (anyone can use it):

```sh
make dist
make install
```

Installing will require elevated permission (and may prompt you to authorise the action).

All installation does is create a symlink within `/usr/local/bin` to the project directory `bin` location, so that you can use the command `certify` globally, at any location.

### Running Certify

Simply running this on its own will present the user with an introduction to usage:

```sh
certify
```

For the moment, the arguments cannot contain spaces. An example would be:

```sh
certify home.local GB England London Acme.org
```

A version check for `openssl` and `tar` will take place on execution.

### Uninstallation

To uninstall the utility, type:

```sh
make uninstall
```

## Known issues to improve on

- Arguments string cannot contain spaces.
- Organisation Unit parameter[^5] fails. Has been omitted until the above issue works.
- Opens output folder with `dolphin` *(as I currently use Debian)*. Expand to detect GUI
- Improve help functionality.
- The user cannot choose output directory for the archive.
- Could "zip" be a better archiver for accessibility?

## Background

> *I originally wrote this utility to help toward resolving web browser HTTPS warnings when building web applications, via [NGINX](https://github.com/nginx).*
>
> *When people noticed this difference, and asked for a copy of the tool, to I passed it through a compiler to protect the source code and prevent other employees messing with it, or worse, claiming credit for coming up with it. Yes, it was that kind of place.*
>
> *Now, I am happy to freely share this code for people to comment, learn, or improve upon.*

[^1]: [OpenSSL Cryptography and SSL/TLS Toolkit - https://www.openssl.org](https://www.openssl.org)
[^2]: [Tar - GNU Project - Free Software Foundation - https://www.gnu.org/software/tar/](https://www.gnu.org/software/tar/)
[^3]: [Make - GNU Project - Free Software Foundation- https://www.gnu.org/software/make/](https://www.gnu.org/software/make/)
[^4]: [Shell script compiler (shc) - https://neurobin.org/projects/softwares/unix/shc/](https://neurobin.org/projects/softwares/unix/shc/)
[^5]: [RFC 1779:  A String Representation of Distinguished Names - https://www.rfc-editor.org/rfc/rfc1779#section-2.2](https://www.rfc-editor.org/rfc/rfc1779#section-2.2)
