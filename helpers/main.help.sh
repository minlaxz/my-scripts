cat <<EOF >&2
Usage: $0 [options]
    Options:
        -h, --help      show this help message and exit
        -i, --install   install {unit}
        -u, --uninstall uninstall {unit}
        -s, --setup     setup the your system
        -t, --template  get a {unit} template for your application containerization
        --test          test EUID.
        -X              Clean up everything about laxz
EOF