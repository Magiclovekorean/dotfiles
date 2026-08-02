#!/usr/bin/env bash

rfkill list wifi | grep -q "Soft blocked: yes" && sudo rfkill unblock all || sudo rfkill block all
