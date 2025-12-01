#!/usr/bin/env python3
from kittens.tui.handler import result_handler

@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    tab = boss.active_tab
    if tab is not None and len(tab.windows) > 1:
        tab.goto_layout('stack' if tab.current_layout.name != 'stack' else 'splits')
