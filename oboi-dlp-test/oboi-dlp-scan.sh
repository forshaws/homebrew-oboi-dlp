#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"

# --- ASCII Art Header ---
cat <<'EOF'
 ██████╗ ██████╗  ██████╗ ██╗   ██████╗ ██╗     ██████╗
██╔═══██╗██╔══██╗██╔═══██╗██║   ██╔══██╗██║     ██╔══██╗
██║   ██║██████╔╝██║   ██║██║   ██║  ██║██║     ██████╔╝
██║   ██║██╔══██╗██║   ██║██║   ██║  ██║██║     ██╔═
╚██████╔╝██████║╚ ██████╔╝██║   ██████╔╝███████╗██║ 
 ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝   ╚═════╝ ╚══════╝╚═╝ 

                 O  B  O  I   -   D  L  P
           Pen Test Suite v0.1.6  © 2025 Scot Forshaw
---------------------------------------------------------------------
EOF

# Colors
GREEN="\033[1;32m"
RED="\033[1;31m"
CYAN="\033[1;36m"
RESET="\033[0m"

tests=(
  "safe.txt|pass|Safe file (should PASS ✅)|No sensitive patterns expected"
  "emails_3.txt|pass|<= 5 emails (should PASS ✅)|Email count ≤ threshold (5)"
  "whitelist.txt|pass|Whitelisted data (should PASS ✅)|Regardless of sensitive patterns included"
  "emails_6.txt|block|> 5 emails (should BLOCK ❌)|Email count > threshold (5)"
  "usernamelist.txt|block|> 5 emails (should BLOCK ❌)|Email count > threshold (5)"
  "creditcards.txt|block|Valid CC numbers (should BLOCK ❌)|Luhn-valid PAN patterns"
  "aws_keys.txt|block|AWS AKIA/ASIA keys (should BLOCK ❌)|AWS Access Key ID formats"
  "api_keys.txt|block|API keys (should BLOCK ❌)|ghp_/github_pat_/AIza/JWT patterns"
  "national_ids.txt|block|National ID numbers (should BLOCK ❌)|UK NI / US SSN formats"
  "bank_accounts.txt|block|Account-like numbers (may BLOCK ❌)|Sort code+acct / ABA routing"
  "sort_codes.txt|mixed|Sort codes + dates (may BLOCK ❌)|Dates pass; genuine sort codes block"
  "phone_numbers.txt|block|Phone numbers (may BLOCK ❌)|UK E.164 + local mobile patterns"
)

# --- Actual detector: fetch and inspect content ---
check_file() {
  local file="$1"
  local url="http://127.0.0.1/oboi-dlp-test/$file"

  local body
  if ! body=$(curl -sSf "$url" 2>/dev/null); then
    return 2   # unreachable
  fi

  if grep -q "Access Blocked" <<<"$body"; then
    return 1   # blocked
  else
    return 0   # passed
  fi
}

blocked=0
total=0

echo -e "${CYAN}Running tests against: ${ROOT}${RESET}"
echo "---------------------------------------------------------------------"

for t in "${tests[@]}"; do
  IFS="|" read -r file expect label reason <<<"$t"
  total=$((total+1))
  printf "→ %-18s %-48s " "$file" "$label"

  if check_file "$file"; then
    if [[ "$expect" == "pass" ]]; then
      echo -e "${GREEN}✅ PASS${RESET} — ${reason}"
    else
      echo -e "${RED}❌ UNEXPECTED PASS${RESET} — should have been blocked"
    fi
  else
    rc=$?
    if [[ $rc -eq 2 ]]; then
      echo -e "${RED}⚠ MISSING${RESET} — file not found"
    else
      echo -e "${RED}❌ BLOCKED${RESET} — ${reason}"
      blocked=$((blocked+1))
    fi
  fi
done

echo "---------------------------------------------------------------------"
echo -e "Summary: ${RED}${blocked} BLOCKED${RESET} / ${total} TOTAL"