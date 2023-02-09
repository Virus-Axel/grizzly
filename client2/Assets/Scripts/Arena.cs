using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Arena : MonoBehaviour
{
    int turn = 0;

    public Bear blueBear = null;
    public Bear redBear = null;

    // Start is called before the first frame update
    void Start()
    {
        testBears();
    }

    void testBears()
    {
        blueBear.UpgradeAbility(Bear.ABILITY.PUNCH);
        blueBear.EquipAbility(Bear.ABILITY.PUNCH);
        blueBear.UpgradeAbility(Bear.ABILITY.TEST1);
        blueBear.EquipAbility(Bear.ABILITY.TEST1);

        redBear.UpgradeAbility(Bear.ABILITY.PUNCH);
        redBear.EquipAbility(Bear.ABILITY.PUNCH);
        redBear.UpgradeAbility(Bear.ABILITY.TEST1);
        redBear.EquipAbility(Bear.ABILITY.TEST1);
    }

    // Update is called once per frame
    void Update()
    {
        if(blueBear.state == Bear.BEAR_STATE.WALKING && redBear.currentAction == Bear.ABILITY.NONE && blueBear.currentAction == Bear.ABILITY.NONE && turn % 2 == 0)
        {
            blueBear.Act();
            turn += 1;
        }
        else if(redBear.state == Bear.BEAR_STATE.WALKING && redBear.currentAction == Bear.ABILITY.NONE && blueBear.currentAction == Bear.ABILITY.NONE && turn % 2 == 1)
        {
            redBear.Act();
            turn += 1;
        }
        
    }
}
