# What is the receiver's address in this partially signed transaction?
# transaction=cHNidP8BAHsCAAAAAhuVpgVRdOxkuC7wW2rvw4800OVxl+QCgezYKHtCYN7GAQAAAAD/////HPTH9wFgyf4iQ2xw4DIDP8t9IjCePWDjhqgs8fXvSIcAAAAAAP////8BigIAAAAAAAAWABTHctb5VULhHvEejvx8emmDCtOKBQAAAAAAAAAA


#!/bin/bash

PSBT="cHNidP8BAHsCAAAAAhuVpgVRdOxkuC7wW2rvw4800OVxl+QCgezYKHtCYN7GAQAAAAD/////HPTH9wFgyf4iQ2xw4DIDP8t9IjCePWDjhqgs8fXvSIcAAAAAAP////8BigIAAAAAAAAWABTHctb5VULhHvEejvx8emmDCtOKBQAAAAAAAAAA"

# Step 1: Set your PSBT
PSBT="cHNidP8BAHsCAAAAAhuVpgVRdOxkuC7wW2rvw4800OVxl+QCgezYKHtCYN7GAQAAAAD/////HPTH9wFgyf4iQ2xw4DIDP8t9IjCePWDjhqgs8fXvSIcAAAAAAP////8BigIAAAAAAAAWABTHctb5VULhHvEejvx8emmDCtOKBQAAAAAAAAAA"

# Step 2: Decode the PSBT
DECODED=$(bitcoin-cli -regtest decodepsbt "$PSBT")

# Step 3: Extract the output scriptPubKey (first output)
SCRIPT_HEX=$(echo "$DECODED" | jq -r '.tx.vout[0].scriptPubKey.hex')

if [ "$SCRIPT_HEX" == "null" ] || [ -z "$SCRIPT_HEX" ]; then
  echo "❌ Could not extract scriptPubKey from PSBT."
  exit 1
fi

# echo "🔍 Extracted scriptPubKey: $SCRIPT_HEX"

# Step 4: Decode the script to get the address
SCRIPT_INFO=$(bitcoin-cli -regtest decodescript "$SCRIPT_HEX")
ADDRESS=$(echo "$SCRIPT_INFO" | jq -r '.address')

if [ "$ADDRESS" == "null" ] || [ -z "$ADDRESS" ]; then
  echo "❌ Failed to decode address from script."
  exit 1
fi

# ✅ Final Result
echo "✅ Receiver's Address: $ADDRESS"
