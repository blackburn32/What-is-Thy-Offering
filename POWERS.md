# Powers System Data Structure

This document defines the data structure for godly powers in the game.

## Design Principles

1. **Global modifiers only** - Power structs contain global modifiers that auto-apply to ALL events
2. **Event-specific modifiers** - Stay in event definitions, not in power definitions
3. **Tech tree structure** - Prerequisites create natural progression paths
4. **Category organization** - Powers grouped by playstyle (faith, economy, offering, survival, risk)
5. **Cost scaling** - Tier 1: 3-4 favor, Tier 2: 7-9 favor, Tier 3: 15+ favor
6. **Multiplicative stacking** - Multiple global modifiers multiply together

## Power Struct Definition

```gml
{
    id: "power_id",                    // Unique identifier
    name: "Display Name",              // Shown to player
    description: "Full description of what this power does and any trade-offs",

    // Acquisition
    cost: 5,                           // Divine favor cost
    tier: 1,                           // 1=starter, 2=mid, 3=advanced

    // Prerequisites (empty arrays if none)
    prerequisites: [],                 // Array of power IDs - player needs ALL (AND logic)
    any_prerequisites: [],             // Array of power IDs - player needs AT LEAST ONE (OR logic)
    forbidden_powers: [],              // Array of power IDs - player must NOT own any of these

    // Optional category for organization
    category: "economy",               // "faith", "economy", "offering", "survival", "risk"

    // Global modifiers (applied to ALL events when owned)
    // Structure matches add_power(power_id, global_modifiers) parameter
    global_modifiers: {
        delta: {
            faith: 1.1,                // 10% more faith from all decisions/boons/disasters
            food: 1.2                  // 20% more food from all decisions/boons/disasters
        },
        exchange: 1.15,                // 15% better on all exchanges (simple multiplier)
        offering: {
            base_favor: 1.5,           // 50% more base favor from all offerings
            faith_factor: 1.3          // 30% more favor from faith in all offerings
        }
    }
}
```

## Categories

- **faith**: Broad faith-focused bonuses, general divine presence
- **economy**: Resource generation, trading, material prosperity
- **offering**: Divine favor optimization, prayer effectiveness
- **survival**: Risk mitigation, disaster protection
- **risk**: High risk, high reward powers that amplify everything

## Global Modifiers Structure

### Delta Modifiers
Apply to all decision options and boon/disaster outcomes:
```gml
delta: {
    faith: 1.2,   // Affects all faith gains/losses
    food: 1.3,    // Affects all food gains/losses
    gold: 1.1,    // Affects all gold gains/losses
    favor: 1.15   // Affects all favor gains/losses
}
```

### Exchange Modifiers
Apply to all exchange receives (simple multiplier):
```gml
exchange: 1.2  // 20% more resources received from all trades
```

### Offering Modifiers
Apply to specific components of all offerings:
```gml
offering: {
    base_favor: 1.5,        // Affects base favor amount
    faith_factor: 1.3,      // Affects favor from faith
    food_factor: 1.2,       // Affects favor from food
    gold_factor: 1.4,       // Affects favor from gold
    decision_bonus: 2.0     // Affects favor from decisions
}
```

## Example Powers

### Tier 1 Starter Powers

```gml
// Broad 10% bonus to all resources
{
    id: "generous_faithful",
    name: "Generous Faithful",
    description: "Your followers' devotion amplifies all aspects of your divine influence. All resource gains and losses increased by 10%.",
    cost: 3,
    tier: 1,
    prerequisites: [],
    any_prerequisites: [],
    forbidden_powers: [],
    category: "faith",
    global_modifiers: {
        delta: {
            faith: 1.1,
            food: 1.1,
            gold: 1.1,
            favor: 1.1
        }
    }
}

// Food specialist with trade-off
{
    id: "harvest_lord",
    name: "Harvest Lord",
    description: "You are the god of bountiful harvests. All food gains and losses increased by 30%. WARNING: This amplifies food loss from disasters!",
    cost: 3,
    tier: 1,
    prerequisites: [],
    any_prerequisites: [],
    forbidden_powers: [],
    category: "economy",
    global_modifiers: {
        delta: {
            food: 1.3
        }
    }
}

// Exchange specialist
{
    id: "master_trader",
    name: "Master Trader",
    description: "Your divine insight into commerce makes all trades more favorable. Receive 20% more from all exchanges.",
    cost: 4,
    tier: 1,
    prerequisites: [],
    any_prerequisites: [],
    forbidden_powers: [],
    category: "economy",
    global_modifiers: {
        exchange: 1.2
    }
}

// Offering specialist
{
    id: "faithful_devotion",
    name: "Faithful Devotion",
    description: "Your followers' deep faith makes their offerings more powerful. Faith contributes 50% more to all offerings.",
    cost: 4,
    tier: 1,
    prerequisites: [],
    any_prerequisites: [],
    forbidden_powers: [],
    category: "offering",
    global_modifiers: {
        offering: {
            faith_factor: 1.5
        }
    }
}
```

### Tier 2 Mid-Tier Powers

```gml
// Offering enhancer
{
    id: "divine_presence",
    name: "Divine Presence",
    description: "Your very presence magnifies the power of offerings. Base favor from all offerings is doubled.",
    cost: 7,
    tier: 2,
    prerequisites: ["faithful_devotion"],
    any_prerequisites: [],
    forbidden_powers: [],
    category: "offering",
    global_modifiers: {
        offering: {
            base_favor: 2.0
        }
    }
}

// Combined economy boost (requires BOTH harvest_lord AND master_trader)
{
    id: "bountiful_stores",
    name: "Bountiful Stores",
    description: "Mastery of harvests and trade fills your followers' granaries. All food gains increased by 20%, all exchanges improved by 15%.",
    cost: 9,
    tier: 2,
    prerequisites: ["harvest_lord", "master_trader"],
    any_prerequisites: [],
    forbidden_powers: [],
    category: "economy",
    global_modifiers: {
        delta: {
            food: 1.2
        },
        exchange: 1.15
    }
}

// Decision value maximizer
{
    id: "wise_ruler",
    name: "Wise Ruler",
    description: "Your followers value your divine guidance above all else. Favor per decision increased by 100%.",
    cost: 8,
    tier: 2,
    prerequisites: ["faithful_devotion"],
    any_prerequisites: [],
    forbidden_powers: [],
    category: "offering",
    global_modifiers: {
        offering: {
            decision_bonus: 2.0
        }
    }
}

// High risk/reward
{
    id: "volatile_deity",
    name: "Volatile Deity",
    description: "Your divine power amplifies all outcomes dramatically. ALL resource changes are DOUBLED - both gains AND losses!",
    cost: 6,
    tier: 2,
    prerequisites: ["generous_faithful"],
    any_prerequisites: [],
    forbidden_powers: [],
    category: "risk",
    global_modifiers: {
        delta: {
            faith: 2.0,
            food: 2.0,
            gold: 2.0,
            favor: 2.0
        }
    }
}
```

### Tier 3 Advanced Powers

```gml
// Ultimate endgame power (requires BOTH divine_presence AND bountiful_stores)
{
    id: "transcendent_one",
    name: "Transcendent One",
    description: "You have achieved true divinity. All resources increased by 25%, all offering components improved by 50%.",
    cost: 15,
    tier: 3,
    prerequisites: ["divine_presence", "bountiful_stores"],
    any_prerequisites: [],
    forbidden_powers: [],
    category: "faith",
    global_modifiers: {
        delta: {
            faith: 1.25,
            food: 1.25,
            gold: 1.25,
            favor: 1.25
        },
        offering: {
            base_favor: 1.5,
            faith_factor: 1.5,
            food_factor: 1.5,
            gold_factor: 1.5,
            decision_bonus: 1.5
        }
    }
}
```

## Notes

- **Multiplicative Stacking**: Multiple global modifiers multiply together
  - Example: Generous Faithful (1.1x food) + Harvest Lord (1.3x food) = 1.43x total food
- **Prerequisites System**:
  - **prerequisites** (AND logic): Player must own ALL powers in this array
    - Example: Transcendent One requires both "divine_presence" AND "bountiful_stores"
  - **any_prerequisites** (OR logic): Player must own AT LEAST ONE power in this array
    - Example: A power could require "harvest_lord" OR "master_trader" OR "faithful_devotion"
  - **Combined logic**: A power can use both fields for complex requirements
    - Example: prerequisites: ["generous_faithful"], any_prerequisites: ["harvest_lord", "master_trader"]
    - This means: Must have "generous_faithful" AND (must have "harvest_lord" OR "master_trader")
- **Forbidden Powers**: Powers can block other powers from being purchased
  - If player owns any power in the forbidden_powers array, this power cannot be purchased
  - Useful for conflicting builds or mutually exclusive playstyles
  - Example: A "pacifist_deity" power could forbid ["war_god", "blood_sacrifice"]
- **Global vs Event-Specific**: Powers requiring conditional logic (e.g., "only negative changes") work better as event-specific modifiers
- **No Power Removal**: Once acquired, powers persist for the entire run
- **Discovery Persistence**: Discovered powers persist across runs for tech tree reveal
- **Tech Tree Paths**: Prerequisites create natural progression (e.g., Faithful Devotion → Divine Presence → Transcendent One)
