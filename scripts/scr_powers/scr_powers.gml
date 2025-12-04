/// @description Powers database for godly powers tech tree

/// TIER 1 STARTER POWERS

function power_generous_faithful() {
    return {
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
    };
}

function power_harvest_lord() {
    return {
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
    };
}

function power_master_trader() {
    return {
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
    };
}

function power_faithful_devotion() {
    return {
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
    };
}

/// TIER 2 MID-TIER POWERS

function power_divine_presence() {
    return {
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
    };
}

function power_bountiful_stores() {
    return {
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
    };
}

function power_wise_ruler() {
    return {
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
    };
}

function power_volatile_deity() {
    return {
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
    };
}

/// TIER 3 ADVANCED POWERS

function power_transcendent_one() {
    return {
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
    };
}

/// UTILITY FUNCTIONS

// Global power map cache (initialized once)
global.power_map = undefined;

/// @function init_power_map()
/// @description Initialize the global power map for fast lookups
/// @return {struct} Map of power_id -> power struct
function init_power_map() {
    if (global.power_map != undefined) {
        return global.power_map;
    }

    var power_map = {};

    // Tier 1
    var p = power_generous_faithful();
    power_map[$ p.id] = p;

    p = power_harvest_lord();
    power_map[$ p.id] = p;

    p = power_master_trader();
    power_map[$ p.id] = p;

    p = power_faithful_devotion();
    power_map[$ p.id] = p;

    // Tier 2
    p = power_divine_presence();
    power_map[$ p.id] = p;

    p = power_bountiful_stores();
    power_map[$ p.id] = p;

    p = power_wise_ruler();
    power_map[$ p.id] = p;

    p = power_volatile_deity();
    power_map[$ p.id] = p;

    // Tier 3
    p = power_transcendent_one();
    power_map[$ p.id] = p;

    global.power_map = power_map;
    return power_map;
}

/// @function get_all_powers()
/// @description Get array of all power structs
/// @return {array} Array of all power definitions
function get_all_powers() {
    // Ensure map is initialized
    var power_map = init_power_map();

    // Convert map to array
    var power_ids = variable_struct_get_names(power_map);
    var powers = [];

    for (var i = 0; i < array_length(power_ids); i++) {
        array_push(powers, power_map[$ power_ids[i]]);
    }

    return powers;
}

/// @function get_power_by_id(power_id)
/// @description Look up a power struct by its ID (O(1) map lookup)
/// @param {string} power_id The ID of the power to find
/// @return {struct} The power struct, or undefined if not found
function get_power_by_id(power_id) {
    // Ensure map is initialized
    var power_map = init_power_map();

    // O(1) lookup
    if (variable_struct_exists(power_map, power_id)) {
        return power_map[$ power_id];
    }

    return undefined;
}

/// @function can_purchase_power(power, player_state)
/// @description Check if a power can be purchased based on prerequisites and forbidden powers
/// @param {struct} power The power struct to check
/// @param {instance} player_state The obj_player_state instance
/// @return {bool} True if power can be purchased
function can_purchase_power(power, player_state) {
    // Check if already owned
    if (player_state.has_power(power.id)) {
        return false;
    }

    // Check if player has enough favor
    if (player_state.favor < power.cost) {
        return false;
    }

    // Check forbidden powers (must NOT own any of these)
    if (variable_struct_exists(power, "forbidden_powers")) {
        for (var i = 0; i < array_length(power.forbidden_powers); i++) {
            if (player_state.has_power(power.forbidden_powers[i])) {
                return false; // Player owns a forbidden power
            }
        }
    }

    // Check prerequisites (must own ALL of these)
    if (variable_struct_exists(power, "prerequisites") && array_length(power.prerequisites) > 0) {
        for (var i = 0; i < array_length(power.prerequisites); i++) {
            if (!player_state.has_power(power.prerequisites[i])) {
                return false; // Missing a required prerequisite
            }
        }
    }

    // Check any_prerequisites (must own AT LEAST ONE of these)
    if (variable_struct_exists(power, "any_prerequisites") && array_length(power.any_prerequisites) > 0) {
        var has_any = false;
        for (var i = 0; i < array_length(power.any_prerequisites); i++) {
            if (player_state.has_power(power.any_prerequisites[i])) {
                has_any = true;
                break;
            }
        }
        if (!has_any) {
            return false; // Don't have any of the required prerequisites
        }
    }

    return true;
}
