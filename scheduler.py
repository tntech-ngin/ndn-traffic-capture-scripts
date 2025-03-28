import argparse
from datetime import datetime, timezone
import logging
import os
import random
import schedule
import signal
import subprocess
import sys
import time

# Constants
OUTPUT_DIR = "/root/dump"

# Set up logging
LOGGER = logging.getLogger("ANALYSER")
LOGGER.setLevel(logging.DEBUG)
_console_handler = logging.StreamHandler(sys.stdout)
_console_handler.setFormatter(
    logging.Formatter(
        "%(asctime)s %(levelname)s %(message)s", datefmt="%Y-%m-%d %H:%M:%S"
    )
)
LOGGER.addHandler(_console_handler)

# Target ndntdump process
ndntdump_proc = None


def run_command(cmd, child=False):
    if child:
        return subprocess.Popen(
            cmd, stdout=subprocess.PIPE, shell=True, preexec_fn=os.setsid
        )
    return subprocess.check_output(cmd, shell=True).decode().strip()


def stop_ndntdump():
    global ndntdump_proc
    if ndntdump_proc:
        try:
            os.killpg(os.getpgid(ndntdump_proc.pid), signal.SIGTERM)
            ndntdump_proc.wait(timeout=10)
            LOGGER.info(f"[trace-collector] Stopped ndntdump: {ndntdump_proc.pid}")
        except subprocess.TimeoutExpired:
            LOGGER.error(f"[trace-collector] Error stopping ndntdump: {e}. Killing...")
            os.killpg(os.getpgid(ndntdump_proc.pid), signal.SIGKILL)
            ndntdump_proc.wait(timeout=10)
        except Exception as e:
            LOGGER.error(f"[trace-collector] Error stopping ndntdump: {e}")
        finally:
            ndntdump_proc = None


def start_ndntdump(node):
    global ndntdump_proc
    # Stop any existing ndntdump process
    stop_ndntdump()

    # Start new ndntdump process
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    date = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    try:
        cmd = f'ndntdump --ifname "*" -w {OUTPUT_DIR}/{node}-{date}.pcapng.zst'
        ndntdump_proc = run_command(cmd, child=True)
        LOGGER.info(f"[trace-collector] Started ndntdump process: {ndntdump_proc.pid}")
    except Exception as e:
        LOGGER.error(f"[trace-collector] Error starting ndntdump: {e}")


def scp_dump():
    try:
        cmd = f'scp -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -oPasswordAuthentication=no -oProxyCommand="ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -oPasswordAuthentication=no -W %h:%p ndntraces@orion.ngin.tntech.edu" {OUTPUT_DIR}/*.zst ndntraces@10.20.10.30:/raid/tracedata/'
        run_command(cmd)
        # Scp successful, remove local files
        run_command(f"rm -rf {OUTPUT_DIR}/*.zst")
        LOGGER.info("[trace-collector] Successfully copied trace files")
    except Exception as e:
        LOGGER.error(f"[trace-collector] Error copying ndntdump files: {e}")


def schedule_tasks(node):
    schedule.every().day.at("17:00", "UTC").do(
        start_ndntdump, node
    )  # Start ndntdump at 5 PM UTC
    LOGGER.info(f"[trace-collector] Scheduled ndntdump start at 5 PM UTC")

    schedule.every().day.at("20:00", "UTC").do(
        stop_ndntdump
    )  # Stop ndntdump at 8 PM UTC
    LOGGER.info(f"[trace-collector] Scheduled ndntdump stop at 8 PM UTC")

    # Randomly schedule SCP between 20:15 and 20:59 (8:15 PM to 8:59 PM UTC)
    random_minute = random.randint(15, 59)
    scp_time = f"20:{random_minute:02d}"
    schedule.every().day.at(scp_time, "UTC").do(scp_dump)
    LOGGER.info(f"[trace-collector] Scheduled SCP at {scp_time} UTC")

    while True:
        schedule.run_pending()
        time.sleep(10)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--site", help="Site name", required=True)
    args = parser.parse_args()
    LOGGER.info(f"[trace-collector] Starting scheduler for site: {args.site}")
    schedule_tasks(args.site)
