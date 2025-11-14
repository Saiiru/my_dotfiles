#!/usr/bin/env bash
set -euo pipefail

TODAY=$(date +%Y-%m-%d)
TOMORROW=$(date -d "$TODAY +1 day" +%Y-%m-%d)
NEXT_MON=$(date -d "next monday" +%Y-%m-%d)
NEXT_TUE=$(date -d "next tuesday" +%Y-%m-%d)
NEXT_WED=$(date -d "next wednesday" +%Y-%m-%d)
NEXT_THU=$(date -d "next thursday" +%Y-%m-%d)
NEXT_FRI=$(date -d "next friday" +%Y-%m-%d)
NEXT_SAT=$(date -d "next saturday" +%Y-%m-%d)
NEXT_SUN=$(date -d "next sunday" +%Y-%m-%d)

# Daily blocks
task add "PVA 5' corda + mobilidade [XP:4]" project:training +treino recur:daily due:$TOMORROW xp:4
task add "Bloco Estudo 1 (25/5) [XP:6]" project:study +estudo recur:daily due:$TOMORROW xp:6
task add "Bloco Estudo 2 (25/5) [XP:6]" project:study +estudo recur:daily due:$TOMORROW xp:6

# Weekly training
task add "Superior A calistenia [XP:20]" project:training +treino recur:weekly due:$NEXT_MON xp:20
task add "Inferiores/Core [XP:18]" project:training +treino recur:weekly due:$NEXT_TUE xp:18
task add "Técnica (Arco + mobilidade) [XP:15]" project:training +treino recur:weekly due:$NEXT_WED xp:15
task add "Superior B calistenia [XP:20]" project:training +treino recur:weekly due:$NEXT_THU xp:20
task add "Inferiores B + cardio [XP:18]" project:training +treino recur:weekly due:$NEXT_FRI xp:18

# Weekly study focus
task add "ESP32 — blink→botão→estado [XP:10]" project:study +estudo +esp32 recur:weekly due:$NEXT_MON xp:10
task add "Linux/Neovim — fluxo foco [XP:8]" project:study +estudo +linux recur:weekly due:$NEXT_TUE xp:8
task add "Backend — REST/SQL [XP:10]" project:study +estudo +backend recur:weekly due:$NEXT_WED xp:10
task add "Cloud/DevOps — fundamentos [XP:8]" project:study +estudo +cloud recur:weekly due:$NEXT_THU xp:8
task add "Go — estrutura projeto [XP:8]" project:study +estudo +go recur:weekly due:$NEXT_FRI xp:8

# 21-day goals
GOAL_DUE=$(date -d "$TODAY +21 days" +%Y-%m-%d)
task add "Meta: handstand 30s parede [XP:50]" project:training +meta due:$GOAL_DUE xp:50
task add "Meta: ESP32 mini-HUD [XP:50]" project:study +meta due:$GOAL_DUE xp:50
