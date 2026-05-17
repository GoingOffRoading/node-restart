# node-restart

This repository contains a bash installer that schedules a Ubuntu 20.04 LTS node to reboot at midnight every day.

## Files

- `install-daily-node-restart.sh`: installs a cron job at `/etc/cron.d/node-daily-restart`

## What it does

The script creates this daily schedule:

```cron
0 0 * * * root /sbin/reboot
```

That means the machine will restart every day at `00:00`.

## Install

1. Copy this repository to the node.
2. Make the script executable.
3. Run it as `root` or with `sudo`.

```bash
chmod +x install-daily-node-restart.sh
sudo ./install-daily-node-restart.sh
```

## Verify

Check that the cron file was created:

```bash
sudo cat /etc/cron.d/node-daily-restart
```

Check that the cron service is running:

```bash
sudo systemctl status cron.service
```

## Remove

To remove the scheduled reboot:

```bash
sudo rm -f /etc/cron.d/node-daily-restart
```

## Kubernetes note

This script performs a direct OS reboot. It does not cordon or drain the Kubernetes node before restarting. If you need a safer rolling reboot process for a cluster, that should be added separately.
