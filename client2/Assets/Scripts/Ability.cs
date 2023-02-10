using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AbilityList
{
    public const int NO_ABILITIES = 4;
    public static List<Ability> abilities = new List<Ability>()
    {
        new Ability("None", 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0.0F, 0),
        new Ability("Punch", 0.1F, 0.05F, 0.5F, 0.0F, 0.0F, 0.01F, 0.02F, 0.002F, 0.0F, 0.0F, 0.005F, 1),
        new Ability("Jab", 0.5F, 0.05F, 0.1F, 0.0F, 0.0F, 0.0F, 0.01F, 0.0F, 0.0F, 0.0F, 0.0F, 2),
        new Ability("Haymaker", 0.3F, 0.1F, 2.0F, 0.0F, 0.0F, 0.01F, 0.02F, 0.002F, 0.001F, 0.04F, 0.005F, 3),
    };
}

public class Ability
{
    public string name;
    public int index;
    public float damage;
    public float staminaCost;
    public float performanceTime;

    public float gainBrain;
    public float gainHeart;
    public float gainLowerArm;
    public float gainUpperArm;
    public float gainLowerLeg;
    public float gainUpperLeg;
    public float gainLowerBody;
    public float gainUpperBody;

    public Ability(string name, float damage, float staminaCost, float performanceTime,
        float gainBrain,
        float gainHeart,
        float gainLowerArm,
        float gainUpperArm,
        float gainLowerLeg,
        float gainUpperLeg,
        float gainLowerBody,
        float gainUpperBody, int index)
    {
        this.gainBrain = gainBrain;
        this.gainHeart = gainHeart;
        this.gainLowerArm = gainLowerArm;
        this.gainUpperArm = gainUpperArm;
        this.gainLowerLeg = gainLowerLeg;
        this.gainUpperLeg = gainUpperLeg;
        this.gainLowerBody = gainLowerBody;
        this.gainUpperBody = gainUpperBody;
        this.performanceTime = performanceTime;
        this.staminaCost = staminaCost;
        this.index = index;
        this.name = name;
        this.damage = damage;
    }
}