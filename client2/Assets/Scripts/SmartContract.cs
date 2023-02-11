using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using Solana.Unity.Rpc.Models;
using Solana.Unity.Rpc.Utilities;
using Solana.Unity.Wallet;
using Solana.Unity.Wallet.Utilities;

using System;

public class SmartContract : MonoBehaviour
{
    public const int MAP_ACCOUNT_DATA_LENGTH = 64;
    public static PublicKey ID = new PublicKey("11111111111111111111111111111111");

    public TransactionInstruction SignUpForFightInstruction(PublicKey payer)
    {
        List<AccountMeta> keys = new()
            {
                AccountMeta.ReadOnly(payer, true),
            };

            return new TransactionInstruction
            {
                ProgramId = ID.KeyBytes,
                Keys = keys,
                Data = Array.Empty<byte>()
            };
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
