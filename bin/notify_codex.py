#!/usr/bin/env python3

import json
import os
import re
import subprocess
import sys
from enum import Enum
from typing import Optional


class TmuxStatus(Enum):
    RUNNING = "● "
    WAITING = "🛑 "
    COMPLETED = "✓ "
    FAILED = "✗ "


TMUX_PREFIX_PATTERN = re.compile(
    rf"^(?:{'|'.join(re.escape(status.value.strip()) for status in TmuxStatus)})\s*"
)


def main() -> int:
    if len(sys.argv) != 2:
        print("Usage: notify_codex.py <NOTIFICATION_JSON>")
        return 1

    try:
        notification = json.loads(sys.argv[1])
    except json.JSONDecodeError:
        return 1

    update_tmux_labels(notification)
    send_desktop_notification(notification)
    return 0


def send_desktop_notification(notification: dict) -> None:
    if notification.get("type") != "agent-turn-complete":
        return

    assistant_message = notification.get("last-assistant-message")
    if assistant_message:
        title = f"Codex: {assistant_message}"
    else:
        title = "Codex: Turn Complete!"

    input_messages = notification.get("input_messages", [])
    message = " ".join(input_messages)
    title += message

    try:
        subprocess.check_output(
            [
                "terminal-notifier",
                "-title",
                title,
                "-message",
                message,
                "-group",
                "codex",
                "-ignoreDnD",
                "-activate",
                "com.googlecode.iterm2",
                "-sound",
                "Boop",
            ]
        )
    except (FileNotFoundError, subprocess.CalledProcessError):
        pass


def update_tmux_labels(notification: dict) -> None:
    pane_id = os.environ.get("TMUX_PANE")
    if not pane_id:
        return

    status = classify_tmux_status(notification)
    if status is None:
        return

    try:
        window_id = tmux_display(pane_id, "#{window_id}")
        window_name = strip_tmux_prefix(tmux_display(pane_id, "#{window_name}"))
        pane_label = strip_tmux_prefix(tmux_display(pane_id, "#{@codex_pane_label}"))
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
            ["tmux", "set-option", "-p", "-t", pane_id, "@codex_pane_label", f"{status.value}{pane_label}"],
            check=True,
            capture_output=True,
            text=True,
        )
    except (FileNotFoundError, subprocess.CalledProcessError):
        pass


def classify_tmux_status(notification: dict) -> Optional[TmuxStatus]:
    notification_type = str(notification.get("type", ""))
    lowered_type = notification_type.lower()
    lowered_payload = json.dumps(notification, ensure_ascii=False).lower()

    if notification_type == "agent-turn-complete":
        return TmuxStatus.COMPLETED
    if "approval" in lowered_type or "permission" in lowered_type:
        return TmuxStatus.WAITING
    if "approval" in lowered_payload or "permission" in lowered_payload:
        return TmuxStatus.WAITING
    if "fail" in lowered_type or "error" in lowered_type or "abort" in lowered_type:
        return TmuxStatus.FAILED
    if "turn" in lowered_type or "agent" in lowered_type:
        return TmuxStatus.RUNNING
    return None


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
