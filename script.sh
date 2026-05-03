#!/usr/bin/env bash
set -e

BASE="http://localhost:8080"

echo "=== 1. Login ==="
LOGIN_RESPONSE=$(curl -s -X POST "$BASE/login")
echo "$LOGIN_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$LOGIN_RESPONSE"

TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  echo "ERROR: could not extract token"
  exit 1
fi

echo ""
echo "Token: $TOKEN"
echo ""

echo "=== 2. Protected endpoint ==="
curl -s -X GET "$BASE/protected" \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool 2>/dev/null
