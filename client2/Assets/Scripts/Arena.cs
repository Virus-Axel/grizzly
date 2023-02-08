using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Arena : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {

        GameObject bearObject = GameObject.Find("Bear");
        GameObject opponentObject = GameObject.Find("Opponent");
        Bear bear = (Bear) bearObject.GetComponent(typeof(Bear));
        Bear opponent = (Bear) opponentObject.GetComponent(typeof(Bear));
        bear.target = opponentObject;
        opponent.target = bearObject;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
