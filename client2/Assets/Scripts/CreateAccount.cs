using System.Security.Cryptography.X509Certificates;
using System.Xml.Serialization;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;

using Solana.Unity.Programs;
using Solana.Unity.Rpc;
using Solana.Unity.Rpc.Models;
using Solana.Unity.Wallet;
public class CreateAccount : MonoBehaviour
{

    void CreateMapAccount(PublicKey payer)
    {
        IRpcClient rpcClient = ClientFactory.GetClient(Cluster.TestNet);
        var recentHash = rpcClient.GetRecentBlockHash();

        ulong leastLamports = rpcClient.GetMinimumBalanceForRent(SmartContract.MAP_ACCOUNT_DATA_LENGTH);
        Account newAccount = new Account();

        TransactionInstruction instruction = SystemProgram.CreateAccount(payer, newAccount.PublicKey, leastLamports, SmartContract.MAP_ACCOUNT_DATA_LENGTH);
    }

    // Start is called before the first frame update
    void Start()
    {
        VisualElement root = GetComponent<UIDocument>().rootVisualElement;
        Button mapButton = root.Q<Button>("MapButton");
        Button bearButton = root.Q<Button>("BearButton");
        Button unassigned = root.Q<Button>("Unassigned");

        mapButton.clicked += () => CreateMapAccount();
        bearButton.clicked += () => CreateMapAccount();
        unassigned.clicked += () => CreateMapAccount();
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
