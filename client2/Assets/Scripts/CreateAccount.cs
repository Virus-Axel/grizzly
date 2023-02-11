using UnityEngine;
using UnityEngine.UIElements;

using Solana.Unity.Programs;
using Solana.Unity.Rpc;
using Solana.Unity.Rpc.Models;
using Solana.Unity.Rpc.Builders;
using Solana.Unity.Wallet;
public class CreateAccount : MonoBehaviour
{

    void CreateMapAccount(Account payer)
    {
        print("Creating client");
        IRpcClient rpcClient = ClientFactory.GetClient(Cluster.TestNet);
        print("client created");

        var leastLamports = rpcClient.GetMinimumBalanceForRentExemption((long) SmartContract.MAP_ACCOUNT_DATA_LENGTH);
        print("minimum balance calculated");

        return;

        var recentHash = rpcClient.GetRecentBlockHash();
        print("blockhash fetched");

        Account newAccount = new Account();
        TransactionInstruction instruction = SystemProgram.CreateAccount(payer, newAccount.PublicKey, leastLamports.Result, SmartContract.MAP_ACCOUNT_DATA_LENGTH, SmartContract.ID);
        print("Instruction created");

        var transaction = new TransactionBuilder().SetRecentBlockHash(recentHash.Result.Value.Blockhash).SetFeePayer(payer.PublicKey).AddInstruction(instruction).Build(payer);

        print("Transaction built");
        rpcClient.SendTransaction(transaction);
        print("Sent transaction");
    }

    // Start is called before the first frame update
    void Start()
    {
        VisualElement root = GetComponent<UIDocument>().rootVisualElement;
        Button mapButton = root.Q<Button>("MapButton");
        Button bearButton = root.Q<Button>("BearButton");
        Button unassigned = root.Q<Button>("Unassigned");

        Account payer = new Account();

        mapButton.clicked += () => CreateMapAccount(payer);
        bearButton.clicked += () => CreateMapAccount(payer);
        unassigned.clicked += () => CreateMapAccount(payer);
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
