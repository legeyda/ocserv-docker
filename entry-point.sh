#!/usr/bin/env shelduck_run
set -eu

shelduck import https://raw.githubusercontent.com/legeyda/bobshell/refs/heads/unstable/install.sh
shelduck import https://raw.githubusercontent.com/legeyda/bobshell/refs/heads/unstable/scope.sh
shelduck import https://raw.githubusercontent.com/legeyda/bobshell/refs/heads/unstable/util.sh
shelduck import https://raw.githubusercontent.com/legeyda/bobshell/refs/heads/unstable/git.sh

main() {
	: "${OCSERV_CONF_FILE:=/etc/ocserv/ocserv.conf}"
	# 
	if [ ! -r "$OCSERV_CONF_FILE" ]; then
		main_ocserv_conf_dir=$(dirname "$OCSERV_CONF_FILE")
		mkdir -p "$main_ocserv_conf_dir"
	fi

	"$@"
}


shelduck import https://raw.githubusercontent.com/legeyda/bobshell/refs/heads/unstable/entry_point.sh