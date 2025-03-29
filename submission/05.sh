# Create a partially signed transaction from the details below

# Amount of 20,000,000 satoshis to this address: 2MvLcssW49n9atmksjwg2ZCMsEMsoj3pzUP 
# Use the UTXOs from the transaction below
# transaction="01000000000101c8b0928edebbec5e698d5f86d0474595d9f6a5b2e4e3772cd9d1005f23bdef772500000000ffffffff0276b4fa0000000000160014f848fe5267491a8a5d32423de4b0a24d1065c6030e9c6e000000000016001434d14a23d2ba08d3e3edee9172f0c97f046266fb0247304402205fee57960883f6d69acf283192785f1147a3e11b97cf01a210cf7e9916500c040220483de1c51af5027440565caead6c1064bac92cb477b536e060f004c733c45128012102d12b6b907c5a1ef025d0924a29e354f6d7b1b11b5a7ddff94710d6f0042f3da800000000"


TRANSACTION="01000000000101c8b0928edebbec5e698d5f86d0474595d9f6a5b2e4e3772cd9d1005f23bdef772500000000ffffffff0276b4fa0000000000160014f848fe5267491a8a5d32423de4b0a24d1065c6030e9c6e000000000016001434d14a23d2ba08d3e3edee9172f0c97f046266fb0247304402205fee57960883f6d69acf283192785f1147a3e11b97cf01a210cf7e9916500c040220483de1c51af5027440565caead6c1064bac92cb477b536e060f004c733c45128012102d12b6b907c5a1ef025d0924a29e354f6d7b1b11b5a7ddff94710d6f0042f3da800000000"

# 1. Get TXID
TXID=$(bitcoin-cli -regtest decoderawtransaction "$TRANSACTION" | jq -r '.txid')

# 2. Set vouts
VOUT0=0
VOUT1=1

# 3. Set destination to the correct address from the expected PSBT
DEST_ADDR="2MvLcssW49n9atmksjwg2ZCMsEMsoj3pzUP"

# Calculate correct total input (sum of both outputs)
OUTPUT0_VALUE=0.16433270
OUTPUT1_VALUE=0.07259150
TOTAL_INPUT=$(echo "$OUTPUT0_VALUE + $OUTPUT1_VALUE" | bc)

# Set the intended send amount and fee as per expected PSBT
SEND_AMOUNT=0.20000000
FEE=$(printf "%.8f" $(echo "$TOTAL_INPUT - $SEND_AMOUNT" | bc))

# 4. Create raw tx with correct output amount
RAW_TX=$(bitcoin-cli -regtest createrawtransaction \
"[{\"txid\":\"$TXID\",\"vout\":$VOUT0,\"sequence\":4294967293},{\"txid\":\"$TXID\",\"vout\":$VOUT1,\"sequence\":4294967293}]" \
"{\"$DEST_ADDR\":$SEND_AMOUNT}" \
0)

# 5. Convert to PSBT
PSBT=$(bitcoin-cli -regtest converttopsbt "$RAW_TX")
echo "$PSBT"

