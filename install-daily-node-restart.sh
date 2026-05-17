#!/usr/bin/env bash
set -euo pipefail

CRON_FILE="/etc/cron.d/node-daily-restart"
CRON_SCHEDULE="0 0 * * *"
REBOOT_COMMAND="/sbin/reboot"

require_root() {
	if [[ "${EUID}" -ne 0 ]]; then
		echo "Run this script with sudo or as root." >&2
		exit 1
	fi
}

install_cron_job() {
	cat > "${CRON_FILE}" <<EOF
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Restart the node at midnight every day.
${CRON_SCHEDULE} root ${REBOOT_COMMAND}
EOF

	chmod 0644 "${CRON_FILE}"
}

ensure_cron_running() {
	if ! command -v systemctl >/dev/null 2>&1; then
		return 0
	fi

	if systemctl list-unit-files cron.service >/dev/null 2>&1; then
		systemctl enable --now cron.service >/dev/null 2>&1 || true
	fi
}

print_summary() {
	echo "Installed daily reboot schedule."
	echo "Cron file: ${CRON_FILE}"
	echo "Schedule: ${CRON_SCHEDULE}"
	echo "Command: ${REBOOT_COMMAND}"
	echo
	echo "Verify with:"
	echo "  sudo cat ${CRON_FILE}"
	echo "  sudo systemctl status cron.service"
}

require_root
install_cron_job
ensure_cron_running
print_summary
