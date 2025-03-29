# Create a native segwit address and get the public key from the address.
# 1. Create a new native SegWit address (bech32)
ADDR=$(bitcoin-cli -regtest getnewaddress "SegWit Address" bech32)

# 2. Get the address info (including public key hash)
ADDR_INFO=$(bitcoin-cli -regtest getaddressinfo "$ADDR")

# 3. Extract the public key (if available)
PUBKEY=$(echo "$ADDR_INFO" | jq -r '.pubkey')

# 4. Show the result
if [ "$PUBKEY" != "null" ]; then
  echo $PUBKEY
else
  echo "⚠️  Public key is not yet revealed (address unused or not in wallet)."
fi
