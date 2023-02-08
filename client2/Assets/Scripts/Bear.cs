using System.Diagnostics;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bear : MonoBehaviour
{
    const int NUMBER_OF_EQUIPPED_ABILITIES = 3;

    float brainSize = 1.0F;
    float lowerArmSize = 1.0F;
    float upperArmSize = 1.0F;
    float heartSize = 1.0F;
    float lowerLegSize = 1.0F;
    float upperLegSize = 1.0F;
    float upperBodySize = 1.0F;
    float lowerBodySize = 1.0F;
    float stamina = 0.5F;

    enum ABILITY
    {
        NONE,
        PUNCH,
        KICK,
        TEST1,
        TEST2,
        TEST3,
        NO_ABILITIES,
    };

    enum BEAR_STATE
    {
        WALKING,
        ATTACKING,
        STAGGERED,
    }

    BEAR_STATE state = BEAR_STATE.WALKING;
    ABILITY currentAction = ABILITY.NONE;

    int[] abilityLevels = new int[(int)ABILITY.NO_ABILITIES - 1]{0, 0, 0, 0, 0};

    List<ABILITY> equippedAbilities;

    public GameObject target;

    void EquipAbility(ABILITY ability, int index = -1)
    {
        if ((int)ability > abilityLevels.Length)
        {
            return;
        }
        if (abilityLevels[(int) ability] <= 0)
        {
            return;
        }
        if (index < 0 && equippedAbilities.Count < NUMBER_OF_EQUIPPED_ABILITIES)
        {
            equippedAbilities.Add(ability);
        }
        else if (index < equippedAbilities.Count && index >= 0)
        {
            equippedAbilities[index] = ability;
        }
        else
        {
            return;
        }
    }

    void UpgradeAbility(ABILITY ability)
    {
        if (ability == ABILITY.NONE || ability == ABILITY.NO_ABILITIES){
            return;
        }
        abilityLevels[(int) ability - 1] += 1;
    }

    ABILITY ChoseAction()
    {
        float randomVal = Random.Range(0.0F, 1.0F);
        if (randomVal > stamina || equippedAbilities.Count <= 0)
        {
            stamina += 0.1F;
            return ABILITY.NONE;
        }

        int randomIndex = Random.Range(0, equippedAbilities.Count);

        return equippedAbilities[randomIndex];
    }

    public void SetTarget(GameObject newTarget)
    {
        target = newTarget;
    }

    // Start is called before the first frame update
    void Start()
    {
        target = null;
        equippedAbilities = new List<ABILITY>{};
    }

    void WalkStrategically()
    {
        float distance = Vector3.Distance(transform.position, target.transform.position);
        transform.position = Vector3.MoveTowards(transform.position, target.transform.position, 1.0F);
        UnityEngine.Debug.Log("Why");
    }

    // Update is called once per frame
    void Update()
    {
        if (target == null)
        {
            UnityEngine.Debug.Log("nil");
            return;
        }
        WalkStrategically();
        switch(state)
        {
            case BEAR_STATE.WALKING:
                WalkStrategically();
                break;
            
        }
        
    }
}
