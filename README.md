# node-restart

I have a few older nodes in my home Kuberentes cluster that are pegged at 100% CPU utilization 24/7, and are starting to struggle a little bit.  Instead of digging through hardware logs to find out why the nodes occasionally crash, I took to easy way out and decided to just restart the nodes daily.  

## Files

- `install-daily-node-restart.sh`: installs a cron job at `/etc/cron.d/node-daily-restart`

## What it does

The script creates this daily schedule:

```cron
0 0 * * * root /sbin/reboot
```

That means the machine will restart every day at `00:00`.

## Install

1. Download the installer script to the node.
2. Make the script executable.
3. Run it as `root` or with `sudo`.

```bash
curl -fsSL https://raw.githubusercontent.com/GoingOffRoading/node-restart/refs/heads/main/install-daily-node-restart.sh -o install-daily-node-restart.sh
chmod +x install-daily-node-restart.sh
sudo ./install-daily-node-restart.sh
```

If `curl` is not installed, you can use `wget` instead:

```bash
wget -O install-daily-node-restart.sh https://raw.githubusercontent.com/GoingOffRoading/node-restart/refs/heads/main/install-daily-node-restart.sh
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
