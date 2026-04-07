#!/bin/bash
input=$(cat)

five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

now=$(date +%s)
out=""

if [ -n "$five_pct" ]; then
  out="5h: $(printf '%.0f' "$five_pct")%"
  if [ -n "$five_reset" ]; then
    mins=$(( (five_reset - now) / 60 ))
    if [ "$mins" -gt 0 ]; then
      hrs=$((mins / 60))
      rem=$((mins % 60))
      if [ "$hrs" -gt 0 ]; then
        out="$out (${hrs}h${rem}m)"
      else
        out="$out (${mins}m)"
      fi
    fi
  fi
fi

if [ -n "$week_pct" ]; then
  [ -n "$out" ] && out="$out  "
  out="${out}7d: $(printf '%.0f' "$week_pct")%"
  if [ -n "$week_reset" ]; then
    mins=$(( (week_reset - now) / 60 ))
    if [ "$mins" -gt 0 ]; then
      hrs=$((mins / 60))
      days=$((hrs / 24))
      rem_hrs=$((hrs % 24))
      if [ "$days" -gt 0 ]; then
        out="$out (${days}d${rem_hrs}h)"
      elif [ "$hrs" -gt 0 ]; then
        rem=$((mins % 60))
        out="$out (${hrs}h${rem}m)"
      else
        out="$out (${mins}m)"
      fi
    fi
  fi
fi

echo "$out"
