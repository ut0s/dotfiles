#!/usr/bin/env python3

import json
import os
import re
import subprocess
import sys
from datetime import datetime, timedelta
from enum import Enum
from typing import Optional
from urllib.request import Request, urlopen
from urllib.error import URLError

DISCORD_WEBHOOK_URL = ""
RARE_LIMIT_HOURS = 5


class TmuxStatus(Enum):
    RUNNING = "● "
    WAITING = "🛑 "
    COMPLETED = "✓ "


TMUX_PREFIX_PATTERN = re.compile(
    rf"^(?:{'|'.join(re.escape(status.value.strip()) for status in TmuxStatus)})\s*"
)
SOUND_EVENTS = {
    ("Notification", "permission_prompt"),
    ("Notification", "idle_prompt"),
    ("Stop", ""),
}


def main() -> int:
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError:
        return 1

    update_tmux_labels(input_data)
    play_sound_if_needed(input_data)
    handle_rare_limit(input_data)
    return 0


def update_tmux_labels(input_data: dict) -> None:
    pane_id = os.environ.get("TMUX_PANE")
    if not pane_id:
        return

    status = classify_tmux_status(input_data)
    if status is None:
        return

    try:
        window_id = tmux_display(pane_id, "#{window_id}")
        window_name = strip_tmux_prefix(tmux_display(pane_id, "#{window_name}"))
        pane_label = strip_tmux_prefix(tmux_display(pane_id, "#{@claude_pane_label}"))
        pane_title = strip_tmux_prefix(tmux_display(pane_id, "#{pane_title}"))
        pane_command = tmux_display(pane_id, "#{pane_current_command}")

        if not pane_label:
            pane_label = pane_title or pane_command or "shell"

        subprocess.run(
            ["tmux", "rename-window", "-t", window_id, f"{status.value}{window_name}"],
            check=True,
            capture_output=True,
            text=True,
        )
        subprocess.run(
            ["tmux", "set-option", "-p", "-t", pane_id, "@claude_pane_label", f"{status.value}{pane_label}"],
            check=True,
            capture_output=True,
            text=True,
        )
    except (FileNotFoundError, subprocess.CalledProcessError):
        pass


def classify_tmux_status(input_data: dict) -> Optional[TmuxStatus]:
    hook_event = str(input_data.get("hook_event_name", ""))
    notification_type = str(input_data.get("notification_type", ""))

    if hook_event in {"UserPromptSubmit", "PostToolUse"}:
        return TmuxStatus.RUNNING
    if hook_event == "Notification" and notification_type in {"permission_prompt", "idle_prompt"}:
        return TmuxStatus.WAITING
    if hook_event == "Stop":
        return TmuxStatus.COMPLETED
    return None


def play_sound_if_needed(input_data: dict) -> None:
    hook_event = str(input_data.get("hook_event_name", ""))
    notification_type = str(input_data.get("notification_type", ""))

    if (hook_event, notification_type) not in SOUND_EVENTS and (hook_event, "") not in SOUND_EVENTS:
        return

    try:
        subprocess.run(
            ["afplay", "/System/Library/Sounds/Glass.aiff"],
            check=True,
            capture_output=True,
            text=True,
        )
    except (FileNotFoundError, subprocess.CalledProcessError):
        pass


def handle_rare_limit(input_data: dict) -> None:
    hook_event = str(input_data.get("hook_event_name", ""))
    notification_type = str(input_data.get("notification_type", ""))

    if hook_event != "Notification" or notification_type != "rare-limit":
        return

    unlock_time = datetime.now() + timedelta(hours=RARE_LIMIT_HOURS)
    unlock_str = unlock_time.strftime("%H:%M")

    send_discord(f"⚠️ Claude rare-limit に達しました。解除予定: **{unlock_str}** ({RARE_LIMIT_HOURS}時間後)")

    delay_sec = RARE_LIMIT_HOURS * 3600
    script = (
        f"import time, urllib.request, json\n"
        f"time.sleep({delay_sec})\n"
        f"msg = json.dumps({{'content': '✅ Claude rare-limit が解除されました！({unlock_str} の制限が終わりました)'}}).encode()\n"
        f"req = urllib.request.Request(\n"
        f"    {repr(DISCORD_WEBHOOK_URL)},\n"
        f"    data=msg,\n"
        f"    headers={{'Content-Type': 'application/json'}},\n"
        f")\n"
        f"try:\n"
        f"    urllib.request.urlopen(req, timeout=10)\n"
        f"except Exception:\n"
        f"    pass\n"
    )
    subprocess.Popen(
        ["python3", "-c", script],
        start_new_session=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


def send_discord(message: str) -> None:
    payload = json.dumps({"content": message}).encode()
    req = Request(
        DISCORD_WEBHOOK_URL,
        data=payload,
        headers={"Content-Type": "application/json"},
    )
    try:
        urlopen(req, timeout=10)
    except (URLError, OSError):
        pass


def tmux_display(target: str, template: str) -> str:
    result = subprocess.run(
        ["tmux", "display-message", "-p", "-t", target, template],
        check=True,
        capture_output=True,
        text=True,
    )
    return result.stdout.strip()


def strip_tmux_prefix(name: str) -> str:
    return TMUX_PREFIX_PATTERN.sub("", name, count=1).strip()


if __name__ == "__main__":
    sys.exit(main())
