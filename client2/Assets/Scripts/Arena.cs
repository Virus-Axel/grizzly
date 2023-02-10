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
        blueBear.UpgradeAbility(AbilityList.abilities[1]);
        blueBear.EquipAbility(AbilityList.abilities[1]);
        blueBear.UpgradeAbility(AbilityList.abilities[2]);
        blueBear.EquipAbility(AbilityList.abilities[2]);

        redBear.UpgradeAbility(AbilityList.abilities[1]);
        redBear.EquipAbility(AbilityList.abilities[1]);
        redBear.UpgradeAbility(AbilityList.abilities[2]);
        redBear.EquipAbility(AbilityList.abilities[2]);
    }

    // Update is called once per frame
    void Update()
    {
        if(blueBear.state == Bear.BEAR_STATE.WALKING && redBear.currentAction.index == 0 && blueBear.currentAction.index == 0 && turn % 2 == 0)
        {
            blueBear.Act();
            turn += 1;
        }
        else if(redBear.state == Bear.BEAR_STATE.WALKING && redBear.currentAction.index == 0 && blueBear.currentAction.index == 0 && turn % 2 == 1)
        {
            redBear.Act();
            turn += 1;
        }

    }
}
