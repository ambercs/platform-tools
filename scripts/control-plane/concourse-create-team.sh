#!/bin/bash
printf "Enter concourse url: "
read -r CONCOURSE_URL
export CONCOURSE_URL=$CONCOURSE_URL
printf "Enter target for main fly team: "
read -r MAIN_TARGET
export MAIN_TARGET=$MAIN_TARGET
printf "Enter the team that you want to create in concourse: "
read -r NEW_TEAM_NAME
export NEW_TEAM_NAME=$NEW_TEAM_NAME
printf "Enter the target for the new team: "
read -r NEW_TARGET
export NEW_TARGET=$NEW_TARGET

fly -t "$MAIN_TARGET" login -c "$CONCOURSE_URL" -n main
fly -t "$MAIN_TARGET" set-team -n "$NEW_TEAM_NAME" --local-user=test
fly -t "$NEW_TARGET" login -c "$CONCOURSE_URL" -n "$NEW_TEAM_NAME"