using System.Diagnostics;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bear : MonoBehaviour
{
    const int NUMBER_OF_EQUIPPED_ABILITIES = 3;
    const float RUN_DISTANCE = 5.0F;
    const float WALK_DISTANCE = 2.0F;
    const float ATTACK_RANGE = 2.5F;

    const float STAGGERED_TIME = 1.0F;
    const float KNOCKOUT_TIME = 3.0F;

    const float RUN_SPEED = 0.2F;
    const float WALK_SPEED = 0.1F;

    const float STAMINA_PENALITY = 0.05F;
    const float STAMINA_RECOVERY = 0.01F;

    float brainSize = 1.0F;
    float lowerArmSize = 1.0F;
    float upperArmSize = 1.0F;
    float heartSize = 1.0F;
    float lowerLegSize = 1.0F;
    float upperLegSize = 1.0F;
    float upperBodySize = 1.0F;
    float lowerBodySize = 1.0F;
    float stamina = 0.5F;
    float health = 1.0F;
    public bool dead = false;

    float timer = 0.0F;

    float attackTime = 1.0F;

    public enum ABILITY
    {
        NONE,
        PUNCH,
        KICK,
        TEST1,
        TEST2,
        TEST3,
        NO_ABILITIES,
    };

    public enum BEAR_STATE
    {
        WALKING,
        ATTACKING,
        STAGGERED,
        KNOCKOUT,
    }

    public BEAR_STATE state = BEAR_STATE.WALKING;
    public ABILITY currentAction = ABILITY.NONE;

    int[] abilityLevels = new int[(int)ABILITY.NO_ABILITIES - 1]{0, 0, 0, 0, 0};

    List<ABILITY> equippedAbilities = new List<ABILITY>{};

    public Bear target = null;

    public void Act()
    {
        currentAction = ChoseAction();
        UnityEngine.Debug.Log(currentAction);
        if (currentAction != ABILITY.NONE)
        {
            this.GetComponent<Renderer>().material.color = Color.green;
        }
    }

    public void EquipAbility(ABILITY ability, int index = -1)
    {
        int levelIndex = (int) ability - 1;
        if (levelIndex >= abilityLevels.Length || levelIndex < 0)
        {
            return;
        }
        if (abilityLevels[levelIndex] <= 0)
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

    public void UpgradeAbility(ABILITY ability)
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
            stamina += STAMINA_RECOVERY;
            return ABILITY.NONE;
        }

        int randomIndex = Random.Range(0, equippedAbilities.Count);

        return equippedAbilities[randomIndex];
    }

    public void SetTarget(Bear newTarget)
    {
        target = newTarget;
    }

    public void HitBear(float damage, bool heavy=false)
    {
        health -= damage;
        if (health <= 0.0F)
        {
            dead = true;
        }
        if(heavy)
        {
            SetState(BEAR_STATE.KNOCKOUT);
        }
        else
        {
            SetState(BEAR_STATE.STAGGERED);
        }
    }

    // Start is called before the first frame update
    void Start()
    {
    }

    void SetState(BEAR_STATE newState)
    {
        state = newState;
        if(state == BEAR_STATE.KNOCKOUT)
        {
            this.GetComponent<Renderer>().material.color = Color.black;
        }
        else if(state == BEAR_STATE.WALKING)
        {
            this.GetComponent<Renderer>().material.color = Color.white;
        }
        else if(state == BEAR_STATE.ATTACKING)
        {
            
        }
        else if (state == BEAR_STATE.STAGGERED)
        {
            this.GetComponent<Renderer>().material.color = Color.magenta;
        }
        else if (state == BEAR_STATE.KNOCKOUT)
        {
            this.GetComponent<Renderer>().material.color = Color.red;
        }
    }

    void TryAttack()
    {
        if(currentAction == ABILITY.NONE)
        {
            return;
        }
        float distance = Vector3.Distance(transform.position, target.transform.position);
        if(distance < ATTACK_RANGE && target.state != BEAR_STATE.KNOCKOUT)
        {
            SetState(BEAR_STATE.ATTACKING);
            this.GetComponent<Renderer>().material.color = Color.yellow;
            stamina -= STAMINA_PENALITY;
        }
    }

    void WalkStrategically()
    {
        float distance = Vector3.Distance(transform.position, target.transform.position);
        if(distance > RUN_DISTANCE)
        {
            transform.position = Vector3.MoveTowards(transform.position, target.transform.position, RUN_SPEED * Time.deltaTime);
        }
        else if (distance > WALK_DISTANCE)
        {
            transform.position = Vector3.MoveTowards(transform.position, target.transform.position, WALK_SPEED * Time.deltaTime);
        }
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
                TryAttack();
                break;
            case BEAR_STATE.ATTACKING:
                timer += Time.deltaTime;
                if(timer >= attackTime)
                {
                    timer = 0.0F;
                    SetState(BEAR_STATE.WALKING);
                    target.HitBear(0.2F);
                    currentAction = ABILITY.NONE;
                }
                break;
            case BEAR_STATE.STAGGERED:
                timer += Time.deltaTime;
                if(timer >= STAGGERED_TIME)
                {
                    timer = 0.0F;
                    SetState(BEAR_STATE.WALKING);
                }
                break;
            case BEAR_STATE.KNOCKOUT:
                timer += Time.deltaTime;
                if(timer >= KNOCKOUT_TIME)
                {
                    timer = 0.0F;
                    SetState(BEAR_STATE.WALKING);
                }
                break;
        }
        
    }
}
