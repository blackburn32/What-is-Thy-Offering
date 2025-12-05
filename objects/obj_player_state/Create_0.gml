/// @description Initialize player state for a game run

faith = 100;          // Starts at 100, game over if reaches 0
food = 100;           // Starts at 100, game over if reaches 0
relics = 50;            // Starts at 50, no penalty for depletion
favor = 0;            // Starts at 0, used to buy powers

owned_powers = [];

// === GLOBAL POWER MODIFIERS ===
// Power modifiers that apply to ALL events (not event-specific)
// These are registered when certain powers are acquired
global_delta_modifiers = {};     // Apply to all decision/boon/disaster deltas
global_exchange_modifiers = {};  // Apply to all exchange receives
global_offering_modifiers = {};  // Apply to all offering calculations

// === FLAGS ===
// Array of flag strings set by decision outcomes and events
// Used for conditional event triggering
flags = [];

// === EVENT TRACKING ===
// Map of event_id -> occurrence_count for max_times_event_can_occur
event_occurrence_count = {};

// Array of event IDs in the order they were encountered
// Useful for reviewing run history and debugging
event_history = [];

// === DECISION TRACKING ===
// Number of decisions made since last offering event
decisions_since_offering = 0;

// === SELECTED GOD ===
// God chosen in GameSetup (from global.selected_god)
selected_god = undefined;

// === DISCOVERED POWERS ===
// Array of all power IDs the player has ever discovered across all runs
// Persists between runs for the Powers room tech tree reveal
// TODO: Load from persistent storage
discovered_powers = [];

/// @function has_power(power_id)
/// @description Check if player owns a specific power
/// @param {string} power_id The ID of the power to check
function has_power(power_id) {
    for (var i = 0; i < array_length(owned_powers); i++) {
        if (owned_powers[i] == power_id) {
            return true;
        }
    }
    return false;
}

/// @function has_flag(flag_id)
/// @description Check if player has a specific flag
/// @param {string} flag_id The ID of the flag to check
function has_flag(flag_id) {
    for (var i = 0; i < array_length(flags); i++) {
        if (flags[i] == flag_id) {
            return true;
        }
    }
    return false;
}

/// @function add_power(power_id, global_modifiers)
/// @description Add a power to the player's owned powers
/// @param {string} power_id The ID of the power to add
/// @param {struct} global_modifiers Optional struct with delta/exchange/offering modifiers
function add_power(power_id, global_modifiers = undefined) {
    if (!has_power(power_id)) {
        array_push(owned_powers, power_id);

        // Register global modifiers if provided
        if (global_modifiers != undefined) {
            if (variable_struct_exists(global_modifiers, "delta")) {
                global_delta_modifiers[$ power_id] = global_modifiers.delta;
            }
            if (variable_struct_exists(global_modifiers, "exchange")) {
                global_exchange_modifiers[$ power_id] = global_modifiers.exchange;
            }
            if (variable_struct_exists(global_modifiers, "offering")) {
                global_offering_modifiers[$ power_id] = global_modifiers.offering;
            }
        }

        // Track as discovered
        if (!array_contains(discovered_powers, power_id)) {
            array_push(discovered_powers, power_id);
            // TODO: Save discovered_powers to persistent storage
        }
    }
}

/// @function add_flag(flag_id)
/// @description Add a flag to the player's flags
/// @param {string} flag_id The ID of the flag to add
function add_flag(flag_id) {
    if (!has_flag(flag_id)) {
        array_push(flags, flag_id);
    }
}

/// @function increment_event_count(event_id)
/// @description Increment the occurrence count for an event
/// @param {string} event_id The ID of the event
function increment_event_count(event_id) {
    if (variable_struct_exists(event_occurrence_count, event_id)) {
        event_occurrence_count[$ event_id]++;
    } else {
        event_occurrence_count[$ event_id] = 1;
    }
}

/// @function get_event_count(event_id)
/// @description Get the number of times an event has occurred
/// @param {string} event_id The ID of the event
/// @return {real} The number of occurrences
function get_event_count(event_id) {
    if (variable_struct_exists(event_occurrence_count, event_id)) {
        return event_occurrence_count[$ event_id];
    }
    return 0;
}

/// @function add_event_to_history(event_id)
/// @description Add an event to the chronological history
/// @param {string} event_id The ID of the event
function add_event_to_history(event_id) {
    array_push(event_history, event_id);
}

/// @function apply_resource_delta(delta)
/// @description Apply resource changes to current resources
/// @param {struct} delta Struct with faith, food, relics, favor changes
function apply_resource_delta(delta) {
    faith += delta.faith;
    food += delta.food;
    relics += delta.relics;
    favor += delta.favor;

    // Clamp resources to reasonable bounds
    faith = max(0, faith);
    food = max(0, food);
    relics = max(0, relics);
    favor = max(0, favor);
}

/// @function record_event_encountered(event_id)
/// @description Record that an event was encountered (adds to history and increments count)
/// @param {string} event_id The ID of the event
function record_event_encountered(event_id) {
    add_event_to_history(event_id);
    increment_event_count(event_id);
}

/// @function apply_power_modifiers_to_delta(delta, power_modifiers)
/// @description Apply owned power modifiers to a resource delta struct
/// @param {struct} delta The base delta with faith, food, relics, favor
/// @param {struct} power_modifiers Power modifier definitions (or undefined)
/// @return {struct} Modified delta with power bonuses applied
function apply_power_modifiers_to_delta(delta, power_modifiers) {
    // Start with base delta values
    var modified_delta = {
        faith: delta.faith,
        food: delta.food,
        relics: delta.relics,
        favor: delta.favor
    };

    // Calculate multipliers for each resource (multiplicative stacking)
    var faith_mult = 1.0;
    var food_mult = 1.0;
    var relics_mult = 1.0;
    var favor_mult = 1.0;

    // Apply event-specific power modifiers
    if (power_modifiers != undefined) {
        // Iterate over player's owned powers
        for (var i = 0; i < array_length(owned_powers); i++) {
            var power_id = owned_powers[i];

            // Check if this power has a modifier for this event
            if (variable_struct_exists(power_modifiers, power_id)) {
                var modifier = power_modifiers[$ power_id];

                // Apply modifiers for each resource this power affects
                if (variable_struct_exists(modifier, "faith")) {
                    faith_mult *= modifier.faith;
                }
                if (variable_struct_exists(modifier, "food")) {
                    food_mult *= modifier.food;
                }
                if (variable_struct_exists(modifier, "relics")) {
                    relics_mult *= modifier.relics;
                }
                if (variable_struct_exists(modifier, "favor")) {
                    favor_mult *= modifier.favor;
                }
            }
        }
    }

    // Apply global delta modifiers (apply to ALL events)
    var global_power_names = variable_struct_get_names(global_delta_modifiers);
    for (var i = 0; i < array_length(global_power_names); i++) {
        var power_id = global_power_names[i];
        var modifier = global_delta_modifiers[$ power_id];

        // Apply modifiers for each resource this power affects
        if (variable_struct_exists(modifier, "faith")) {
            faith_mult *= modifier.faith;
        }
        if (variable_struct_exists(modifier, "food")) {
            food_mult *= modifier.food;
        }
        if (variable_struct_exists(modifier, "relics")) {
            relics_mult *= modifier.relics;
        }
        if (variable_struct_exists(modifier, "favor")) {
            favor_mult *= modifier.favor;
        }
    }

    // Apply multipliers and round to integers
    modified_delta.faith = round(delta.faith * faith_mult);
    modified_delta.food = round(delta.food * food_mult);
    modified_delta.relics = round(delta.relics * relics_mult);
    modified_delta.favor = round(delta.favor * favor_mult);

    return modified_delta;
}

/// @function apply_outcome(outcome)
/// @description Apply an outcome from a decision option or boon/disaster event
/// @param {struct} outcome The outcome struct (has delta, set_flags, grant_powers, etc.)
function apply_outcome(outcome) {
    // Apply resource changes with power modifiers
    var power_mods = variable_struct_exists(outcome, "power_modifiers") ? outcome.power_modifiers : undefined;
    var modified_delta = apply_power_modifiers_to_delta(outcome.delta, power_mods);
    apply_resource_delta(modified_delta);

    // Set flags
    if (variable_struct_exists(outcome, "set_flags") && outcome.set_flags != undefined) {
        for (var i = 0; i < array_length(outcome.set_flags); i++) {
            add_flag(outcome.set_flags[i]);
        }
    }

    // Grant powers
    if (variable_struct_exists(outcome, "grant_powers") && outcome.grant_powers != undefined) {
        for (var i = 0; i < array_length(outcome.grant_powers); i++) {
            add_power(outcome.grant_powers[i]);
        }
    }

    // Note: unlock_events and lock_events are handled by the game controller
    // as they affect the global event pool, not player state
}

/// @function apply_exchange(exchange)
/// @description Apply an exchange trade (subtract give, add receive with power modifiers)
/// @param {struct} exchange The exchange struct (has give, receive, power_modifiers)
function apply_exchange(exchange) {
    // Subtract what we give
    var give_delta = {
        faith: -exchange.give.faith,
        food: -exchange.give.food,
        relics: -exchange.give.relics,
        favor: -exchange.give.favor
    };
    apply_resource_delta(give_delta);

    // Calculate what we receive with power modifiers
    var receive_mult = 1.0;

    // Apply event-specific exchange modifiers
    if (variable_struct_exists(exchange, "power_modifiers") && exchange.power_modifiers != undefined) {
        // Iterate over player's owned powers
        for (var i = 0; i < array_length(owned_powers); i++) {
            var power_id = owned_powers[i];

            // Check if this power has a modifier for this exchange
            if (variable_struct_exists(exchange.power_modifiers, power_id)) {
                receive_mult *= exchange.power_modifiers[$ power_id];
            }
        }
    }

    // Apply global exchange modifiers (apply to ALL exchanges)
    var global_power_names = variable_struct_get_names(global_exchange_modifiers);
    for (var i = 0; i < array_length(global_power_names); i++) {
        var power_id = global_power_names[i];
        receive_mult *= global_exchange_modifiers[$ power_id];
    }

    // Add what we receive (with multipliers applied)
    var receive_delta = {
        faith: round(exchange.receive.faith * receive_mult),
        food: round(exchange.receive.food * receive_mult),
        relics: round(exchange.receive.relics * receive_mult),
        favor: round(exchange.receive.favor * receive_mult)
    };
    apply_resource_delta(receive_delta);
}

/// @function calculate_offering_favor(offering_formula)
/// @description Calculate favor gained from an offering event
/// @param {struct} offering_formula The offering formula struct
/// @return {real} The amount of favor to grant (rounded to integer)
function calculate_offering_favor(offering_formula) {
    var total_favor = 0.0;

    // Calculate multipliers for each component (multiplicative stacking)
    var base_favor_mult = 1.0;
    var faith_factor_mult = 1.0;
    var food_factor_mult = 1.0;
    var relics_factor_mult = 1.0;
    var decision_bonus_mult = 1.0;

    // Apply event-specific offering modifiers
    if (variable_struct_exists(offering_formula, "power_modifiers") && offering_formula.power_modifiers != undefined) {
        // Iterate over player's owned powers
        for (var i = 0; i < array_length(owned_powers); i++) {
            var power_id = owned_powers[i];

            // Check if this power has a modifier for this offering
            if (variable_struct_exists(offering_formula.power_modifiers, power_id)) {
                var modifier = offering_formula.power_modifiers[$ power_id];

                // Apply modifiers for each component this power affects
                if (variable_struct_exists(modifier, "base_favor")) {
                    base_favor_mult *= modifier.base_favor;
                }
                if (variable_struct_exists(modifier, "faith_factor")) {
                    faith_factor_mult *= modifier.faith_factor;
                }
                if (variable_struct_exists(modifier, "food_factor")) {
                    food_factor_mult *= modifier.food_factor;
                }
                if (variable_struct_exists(modifier, "relics_factor")) {
                    relics_factor_mult *= modifier.relics_factor;
                }
                if (variable_struct_exists(modifier, "decision_bonus")) {
                    decision_bonus_mult *= modifier.decision_bonus;
                }
            }
        }
    }

    // Apply global offering modifiers (apply to ALL offerings)
    var global_power_names = variable_struct_get_names(global_offering_modifiers);
    for (var i = 0; i < array_length(global_power_names); i++) {
        var power_id = global_power_names[i];
        var modifier = global_offering_modifiers[$ power_id];

        // Apply modifiers for each component this power affects
        if (variable_struct_exists(modifier, "base_favor")) {
            base_favor_mult *= modifier.base_favor;
        }
        if (variable_struct_exists(modifier, "faith_factor")) {
            faith_factor_mult *= modifier.faith_factor;
        }
        if (variable_struct_exists(modifier, "food_factor")) {
            food_factor_mult *= modifier.food_factor;
        }
        if (variable_struct_exists(modifier, "relics_factor")) {
            relics_factor_mult *= modifier.relics_factor;
        }
        if (variable_struct_exists(modifier, "decision_bonus")) {
            decision_bonus_mult *= modifier.decision_bonus;
        }
    }

    // Calculate each component with multipliers
    total_favor += offering_formula.base_favor * base_favor_mult;
    total_favor += faith * offering_formula.faith_factor * faith_factor_mult;
    total_favor += food * offering_formula.food_factor * food_factor_mult;
    total_favor += relics * offering_formula.relics_factor * relics_factor_mult;
    total_favor += decisions_since_offering * offering_formula.decision_bonus * decision_bonus_mult;

    // Reset decision counter
    decisions_since_offering = 0;

    // Round to integer and return
    return round(total_favor);
}

/// @function is_game_over()
/// @description Check if game over conditions are met
/// @return {bool} True if faith or food reached 0
function is_game_over() {
    return faith <= 0 || food <= 0 || array_length(event_history) >= 30;
}

/// @function reset_for_new_run()
/// @description Reset state for a new game run
function reset_for_new_run() {
    faith = 100;
    food = 10;
    relics = 50;
    favor = 0;
    owned_powers = [];
    global_delta_modifiers = {};
    global_exchange_modifiers = {};
    global_offering_modifiers = {};
    flags = [];
    event_occurrence_count = {};
    event_history = [];
    decisions_since_offering = 0;
    selected_god = undefined;
    // Note: discovered_powers persists across runs
}
