# Event System Data Structure

This document defines the data structure for all event types in the game.


## Design Principles

1. **Single unified structure** - All event types use same base struct, with type-specific fields only present when relevant
2. **Extensive use of `undefined`** - Optional fields use undefined rather than null/empty
3. **Flat resource objects** - Resources always stored as `{faith, food, relics, favor}` for consistency
4. **Separation of costs and deltas** - Decision options show cost separately from outcome changes
5. **Flexible power requirements** - Supports "all required" (AND), "any required" (OR), and forbidden (NOT)
6. **Flag system** - Simple string-based flags track decision history
7. **Event graph** - unlock_events/lock_events allow building conditional event chains
8. **Multiplicative power modifiers** - All event types support granular power_modifiers with multiplicative stacking
   - Exchange: Powers apply to the entire received amount
   - Offering: Powers target specific components (base_favor, faith_factor, food_factor, relics_factor, decision_bonus)
   - Decision options: Powers target specific resource deltas (faith, food, relics, favor)
   - Boon/Disaster outcomes: Powers target specific resource deltas (faith, food, relics, favor)

## Event Struct Definition

All events use a unified struct with type-specific fields:

```gml
{
    id: "unique_event_id",
    type: "decision", // "decision", "boon", "disaster", "exchange", "offering", "store"

    // This is what's shown on the first screen
    descriptionLines: ["Event description text shown on first screen", "Put separate paragraphs in seaparte list items"],

    // optional - use undefined if not needed
    conditions: {
        // Power requirements
        required_powers: ["power_id_1"],  // Must own ALL these powers
        any_required_powers: ["power_a", "power_b"], // Must own AT LEAST ONE
        forbidden_powers: ["power_id_2"], // Must NOT own these powers

        // Flags may have been set from previous decisions/events
        required_flags: ["flag_helped_travelers"],
        forbidden_flags: ["flag_rejected_travelers"],

        // Resource gates
        min_faith: 10,
        max_faith: undefined,
        min_food: undefined,
        max_food: undefined,
        min_relics: undefined,
        max_relics: undefined,
        min_favor: undefined,
        max_favor: undefined,

        max_times_event_can_occur: undefined, // undefined = unlimited, number = max occurrences

        // Selection weighting
        event_selection_weight: 1.0  // Relative probability when multiple events eligible, 1 is the standard weighting
    },

    // === DECISION EVENTS: Array of options ===
    options: [
        {
            text: "Option text with [PowerName] prefix if locked",

            // Option-specific availability
            required_power: undefined,
            required_flags: undefined,

            // Costs shown (in parentheses) to player
            cost: {
                faith: 0,
                food: 5,
                relics: 10,
                favor: 0
            },

            outcome_text: "Result of choosing this option",

            // Actual resource changes applied (should include cost)
            delta: {
                faith: 10,
                food: -5,
                relics: -10,
                favor: 2
            },

            // Power multipliers (multiplicative stacking)
            // Each power specifies which resource deltas it affects
            power_modifiers: {
                "merciful_one": {
                    faith: 1.5     // Merciful choices give 50% more faith
                },
                "harvest_lord": {
                    food: 1.3      // Food gains/losses 30% larger
                },
                "generous_god": {
                    faith: 1.2,
                    food: 1.2,
                    relics: 1.2,
                    favor: 1.2     // All resources 20% larger
                }
            },

            // State changes
            set_flags: ["flag_name"],
            unlock_events: ["event_id"],
            lock_events: ["other_event_id"],
            grant_powers: undefined
        }
    ],

    // === BOON/DISASTER EVENTS: Single outcome ===
    outcome: {
        text: "Outcome text for second screen",
        delta: {
            faith: 10,
            food: 5,
            relics: 3,
            favor: 1
        },

        // Power multipliers (multiplicative stacking)
        // Each power specifies which resource deltas it affects
        power_modifiers: {
            "generous_god": {
                faith: 1.5,    // 50% more faith gained/lost
                food: 1.5,     // 50% more food gained/lost
                relics: 1.5,     // 50% more relics gained/lost
                favor: 1.5     // 50% more favor gained/lost
            },
            "harvest_lord": {
                food: 1.8      // Only affects food (80% more)
            },
            "ancient_sage": {
                faith: 0.5,    // Reduces faith impact by 50% (good for disasters)
                food: 0.5,     // Reduces food impact by 50%
                relics: 0.5      // Reduces relics impact by 50%
            }
        },

        set_flags: ["boon_occurred"],
        unlock_events: ["unlocked_event"],
        lock_events: ["locked_event"],
        grant_powers: ["rare_power_id"]
    },

    // === EXCHANGE EVENTS: Resource trading ===
    exchanges: [
        {
            text: "Trade 10 Food for relics",
            give: {
                faith: 0,
                food: 10,
                relics: 0,
                favor: 0
            },
            receive: {
                faith: 0,
                food: 0,
                relics: 4,
                favor: 0
            },
            // Power multipliers applied to receive amount (multiplicative stacking)
            // If player owns multiple, they multiply together: 1.5 * 1.25 = 1.875x
            power_modifiers: {
                "trickster": 1.5,      // 50% improvement: 4 relics → 6 relics
                "merchant_god": 1.25,  // 25% improvement: 4 relics → 5 relics
                "cursed": 0.75         // 25% penalty: 4 relics → 3 relics
            }
        }
    ],

    // === OFFERING EVENTS: Calculated divine favor ===
    offering_formula: {
        base_favor: 1,                // Flat favor amount always received
        faith_factor: 0.01,           // % of current faith converted to favor
        food_factor: 0.005,           // % of current food converted to favor
        relics_factor: 0.01,            // % of current relics converted to favor
        decision_bonus: 0.5,          // Favor per decision since last offering

        // Power multipliers (multiplicative stacking)
        // Each power specifies which components it affects
        power_modifiers: {
            "generous_faithful": {
                base_favor: 2.0,      // Doubles base favor
                faith_factor: 1.5,    // 50% more favor from faith
                food_factor: 1.5,     // 50% more favor from food
                relics_factor: 1.5,     // 50% more favor from relics
                decision_bonus: 1.5   // 50% more favor per decision
            },
            "devoted_flock": {
                faith_factor: 1.8     // Only affects faith (80% improvement)
            },
            "harvest_lord": {
                food_factor: 1.5      // Only affects food (50% improvement)
            },
            "wise_ruler": {
                decision_bonus: 2.0   // Only affects decision bonus (100% improvement)
            }
        }
    }

    // Note: STORE events don't need event-specific data -
    // they're handled by the store system reading the power tech tree
}
```

## Example Events

### Decision Event

```gml
var event_traveler = {
    id: "decision_traveler_01",
    type: "decision",
    description: "Weary travelers seek shelter at your temple.",
    conditions: {
        weight: 1.0
    },
    options: [
        {
            text: "Welcome them warmly",
            cost: {
                faith: 0,
                food: 5,
                relics: 0,
                favor: 0
            },
            outcome_text: "The travelers spread word of your kindness.",
            delta: {
                faith: 10,
                food: 0,
                relics: 0,
                favor: 0
            },
            set_flags: ["helped_travelers"]
        },
        {
            text: "[Merciful One] Bless their journey",
            required_power: "merciful_one",
            cost: {
                faith: 5,
                food: 5,
                relics: 0,
                favor: 0
            },
            outcome_text: "Your blessing fills them with hope.",
            delta: {
                faith: 20,
                food: 0,
                relics: 0,
                favor: 1
            },
            set_flags: ["blessed_travelers"]
        },
        {
            text: "Turn them away",
            cost: {
                faith: 0,
                food: 0,
                relics: 0,
                favor: 0
            },
            outcome_text: "The travelers leave, disappointed.",
            delta: {
                faith: -5,
                food: 0,
                relics: 0,
                favor: 0
            },
            set_flags: ["rejected_travelers"]
        }
    ]
};
```

### Boon Event

```gml
var event_great_harvest = {
    id: "boon_harvest_01",
    type: "boon",
    description: "The harvest is exceptionally bountiful this season!",
    conditions: {
        required_powers: ["harvest_lord"],
        event_selection_weight: 0.3
    },
    outcome: {
        text: "Your followers celebrate the abundance and thank you for your blessing.",
        delta: {
            faith: 5,
            food: 30,
            relics: 0,
            favor: 0
        },
        power_modifiers: {
            "harvest_lord": {
                food: 1.5      // Harvest Lord makes bountiful harvests even better
            },
            "generous_god": {
                faith: 1.3,
                food: 1.2,
                favor: 1.3
            }
        },
        set_flags: ["great_harvest"]
    }
};
```

### Disaster Event

```gml
var event_drought = {
    id: "disaster_drought_01",
    type: "disaster",
    description: "A terrible drought has struck the land.",
    conditions: {
        event_selection_weight: 0.2,
        min_food: 10  // Only trigger if player has food to lose
    },
    outcome: {
        text: "Crops wither and your followers grow hungry and fearful.",
        delta: {
            faith: -10,
            food: -20,
            relics: 0,
            favor: 0
        },
        power_modifiers: {
            "ancient_sage": {
                faith: 0.5,    // Reduces faith loss by 50%
                food: 0.6      // Reduces food loss by 40%
            },
            "harvest_lord": {
                food: 1.3      // Makes food loss 30% worse (downside of harvest focus)
            }
        },
        set_flags: ["drought_occurred"]
    }
};
```

### Exchange Event

```gml
var event_merchant = {
    id: "exchange_merchant_01",
    type: "exchange",
    description: "A traveling merchant offers to trade goods.",
    conditions: {
        event_selection_weight: 0.8
    },
    exchanges: [
        {
            text: "Trade 10 Food for relics",
            give: {
                faith: 0,
                food: 10,
                relics: 0,
                favor: 0
            },
            receive: {
                faith: 0,
                food: 0,
                relics: 4,
                favor: 0
            },
            power_modifiers: {
                "trickster": 1.5,      // 4 relics → 6 relics
                "merchant_god": 1.25   // 4 relics → 5 relics (or 7.5 if both owned)
            }
        },
        {
            text: "Trade 10 Relics for food",
            give: {
                faith: 0,
                food: 0,
                relics: 10,
                favor: 0
            },
            receive: {
                faith: 0,
                food: 25,
                relics: 0,
                favor: 0
            },
            power_modifiers: {
                "trickster": 1.5,      // 25 food → 37 food
                "harvest_lord": 1.2    // 25 food → 30 food (or 45 if both owned)
            }
        },
        {
            text: "Decline the trade",
            give: {
                faith: 0,
                food: 0,
                relics: 0,
                favor: 0
            },
            receive: {
                faith: 0,
                food: 0,
                relics: 0,
                favor: 0
            }
        }
    ]
};
```

### Offering Event

```gml
var event_offering = {
    id: "offering_standard",
    type: "offering",
    description: "Your faithful gather to make an offering in your name.",
    conditions: {
        event_selection_weight: 1.0
    },
    offering_formula: {
        base_favor: 1,
        faith_factor: 0.01,      // 1% of faith
        food_factor: 0.005,      // 0.5% of food
        relics_factor: 0.01,       // 1% of relics
        decision_bonus: 0.5,     // 0.5 favor per decision since last offering

        power_modifiers: {
            "generous_faithful": {
                base_favor: 2.0,      // Doubles base favor (1 → 2)
                faith_factor: 1.5,    // 50% more from faith
                food_factor: 1.5,     // 50% more from food
                relics_factor: 1.5,     // 50% more from relics
                decision_bonus: 1.5   // 50% more per decision
            },
            "devoted_flock": {
                faith_factor: 1.8     // 80% more favor from faith only
            },
            "harvest_lord": {
                food_factor: 1.6      // 60% more favor from food only
            }
        }
    }
};
```

### Complex Decision with Multiple Conditions

```gml
var event_war = {
    id: "decision_war_01",
    type: "decision",
    description: "A neighboring tribe threatens your followers with war.",
    conditions: {
        required_flags: ["established_village"],
        forbidden_flags: ["war_resolved"],
        min_relics: 5,  // Need resources to have meaningful choices
        weight: 0.5
    },
    options: [
        {
            text: "Pay tribute to avoid conflict",
            cost: {
                faith: 0,
                food: 10,
                relics: 20,
                favor: 0
            },
            outcome_text: "Peace is maintained, though your followers question your strength.",
            delta: {
                faith: -5,
                food: 0,
                relics: 0,
                favor: 0
            },
            set_flags: ["war_resolved", "paid_tribute"]
        },
        {
            text: "[War Bringer] Lead them to victory",
            required_power: "war_bringer",
            cost: {
                faith: 10,
                food: 5,
                relics: 0,
                favor: 0
            },
            outcome_text: "Your divine might leads your followers to a glorious victory!",
            delta: {
                faith: 30,
                food: 0,
                relics: 15,
                favor: 3
            },
            set_flags: ["war_resolved", "war_won"],
            unlock_events: ["decision_expansion_01"]
        },
        {
            text: "Prepare defenses and wait",
            cost: {
                faith: 0,
                food: 0,
                relics: 10,
                favor: 0
            },
            outcome_text: "Your followers successfully defend their homes, but suffer losses.",
            delta: {
                faith: 5,
                food: -15,
                relics: 0,
                favor: 0
            },
            set_flags: ["war_resolved", "war_defended"]
        }
    ]
};
```

## Notes

- **Store events** are handled separately by the power tech tree system and don't use this structure
- All resource values should use integers (no decimals) for display simplicity
- Offering formula results should be rounded to nearest integer
- Event selection system should filter by conditions, then weight randomly among eligible events
- Flags persist for the entire run but reset between runs (stored in game controller)
- **Exchange power_modifiers**: Multipliers stack multiplicatively when player owns multiple relevant powers
  - Example: If player owns both "trickster" (1.5x) and "merchant_god" (1.25x), final multiplier is 1.5 * 1.25 = 1.875x
  - Multipliers < 1.0 represent penalties (e.g., "cursed": 0.75 reduces received resources by 25%)
  - Can use `undefined` for exchanges that aren't affected by any powers
  - Final received amount should be rounded to nearest integer after applying multipliers
- **Offering power_modifiers**: Each power can modify specific offering components independently
  - Powers specify which components they affect (base_favor, faith_factor, food_factor, relics_factor, decision_bonus)
  - Omitted components are not affected by that power (e.g., "devoted_flock" only affects faith_factor)
  - Multiple powers affecting the same component stack multiplicatively
  - Example: If player owns "generous_faithful" (faith_factor: 1.5x) and "devoted_flock" (faith_factor: 1.8x), final faith_factor multiplier is 1.5 * 1.8 = 2.7x
  - Calculation: For each component, multiply base value by all relevant power modifiers, then sum all components for total favor
  - All intermediate calculations should use floats, final result rounded to nearest integer
  - **Worked example**: Player has 200 faith, 100 food, 50 relics, 10 decisions since last offering, and owns "generous_faithful" and "devoted_flock"
    - Base favor: 1 * 2.0 (generous_faithful) = 2
    - Faith contribution: 200 * 0.01 * 1.5 (generous_faithful) * 1.8 (devoted_flock) = 200 * 0.01 * 2.7 = 5.4
    - Food contribution: 100 * 0.005 * 1.5 (generous_faithful) = 0.75
    - Relics contribution: 50 * 0.01 * 1.5 (generous_faithful) = 0.75
    - Decision contribution: 10 * 0.5 * 1.5 (generous_faithful) = 7.5
    - Total favor: 2 + 5.4 + 0.75 + 0.75 + 7.5 = 16.4 → rounds to 16
- **Decision option & Boon/Disaster outcome power_modifiers**: Each power can modify specific resource deltas independently
  - Powers specify which resource deltas they affect (faith, food, relics, favor)
  - Omitted resources are not affected by that power
  - Multiple powers affecting the same resource stack multiplicatively
  - **Important**: Modifiers affect both positive and negative deltas equally (amplify gains AND losses)
  - Multiplier > 1.0 amplifies the delta (bigger gains, bigger losses)
  - Multiplier < 1.0 reduces the delta (smaller gains, smaller losses)
  - Example for boon: "harvest_lord" (food: 1.5x) on +30 food gain → +45 food
  - Example for disaster: "ancient_sage" (food: 0.5x) on -20 food loss → -10 food (mitigates disaster)
  - Example for disaster downside: "harvest_lord" (food: 1.3x) on -20 food loss → -26 food (amplifies disaster)
  - Can use `undefined` for events that aren't affected by any powers
  - Final resource changes should be rounded to nearest integer after applying multipliers
