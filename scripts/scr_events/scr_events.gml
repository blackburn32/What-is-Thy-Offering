/// @description Event database for game events
/// Returns an array of all events

function get_all_events() {
    return [
        // Decision events
        event_simple_decision(),

        // Boon events
        event_simple_boon(),

        // Disaster events
        event_simple_disaster(),

        // Exchange events
        event_simple_exchange(),

        // Offering events
        event_simple_offering()
    ];
}

/// @description Simple decision event - A stranger asks for help
function event_simple_decision() {
    return {
        id: "decision_stranger_help",
        type: "decision",
        descriptionLines: [
            "A stranger approaches your temple, weak and hungry.",
            "They beg for food and shelter."
        ],

        conditions: {
            event_selection_weight: 1.0
        },

        options: [
            {
                text: "Give them food and shelter",
                cost: {
                    faith: 0,
                    food: 10,
                    gold: 0,
                    favor: 0
                },
                outcome_text: "The stranger thanks you and spreads word of your kindness.",
                delta: {
                    faith: 15,
                    food: -10,
                    gold: 0,
                    favor: 0
                }
            },
            {
                text: "Give them food only",
                cost: {
                    faith: 0,
                    food: 5,
                    gold: 0,
                    favor: 0
                },
                outcome_text: "The stranger takes the food and leaves quietly.",
                delta: {
                    faith: 5,
                    food: -5,
                    gold: 0,
                    favor: 0
                }
            },
            {
                text: "Turn them away",
                cost: {
                    faith: 0,
                    food: 0,
                    gold: 0,
                    favor: 0
                },
                outcome_text: "The stranger leaves, disappointed in your lack of compassion.",
                delta: {
                    faith: -8,
                    food: 0,
                    gold: 0,
                    favor: 0
                }
            }
        ]
    };
}

/// @description Simple boon event - Good weather brings prosperity
function event_simple_boon() {
    return {
        id: "boon_good_weather",
        type: "boon",
        descriptionLines: [
            "The weather has been exceptionally favorable!",
            "Crops grow tall and the people are happy."
        ],

        conditions: {
            event_selection_weight: 0.5
        },

        outcome: {
            text: "Your followers thank you for the blessing of good fortune.",
            delta: {
                faith: 8,
                food: 20,
                gold: 5,
                favor: 0
            }
        }
    };
}

/// @description Simple disaster event - Storm damages crops
function event_simple_disaster() {
    return {
        id: "disaster_storm",
        type: "disaster",
        descriptionLines: [
            "A fierce storm sweeps through the land!",
            "Crops are damaged and supplies are lost."
        ],

        conditions: {
            event_selection_weight: 0.3,
            min_food: 5  // Only trigger if player has some food to lose
        },

        outcome: {
            text: "Your followers look to you for comfort in this difficult time.",
            delta: {
                faith: -5,
                food: -15,
                gold: -3,
                favor: 0
            }
        }
    };
}

/// @description Simple exchange event - Trader offers deals
function event_simple_exchange() {
    return {
        id: "exchange_trader",
        type: "exchange",
        descriptionLines: [
            "A traveling trader arrives at your temple.",
            "They offer to exchange goods."
        ],

        conditions: {
            event_selection_weight: 0.6
        },

        exchanges: [
            {
                text: "Trade 15 Food for 8 Gold",
                give: {
                    faith: 0,
                    food: 15,
                    gold: 0,
                    favor: 0
                },
                receive: {
                    faith: 0,
                    food: 0,
                    gold: 8,
                    favor: 0
                }
            },
            {
                text: "Trade 10 Gold for 20 Food",
                give: {
                    faith: 0,
                    food: 0,
                    gold: 10,
                    favor: 0
                },
                receive: {
                    faith: 0,
                    food: 20,
                    gold: 0,
                    favor: 0
                }
            },
            {
                text: "Thank them but decline",
                give: {
                    faith: 0,
                    food: 0,
                    gold: 0,
                    favor: 0
                },
                receive: {
                    faith: 0,
                    food: 0,
                    gold: 0,
                    favor: 0
                }
            }
        ]
    };
}

/// @description Simple offering event - Standard divine favor calculation
function event_simple_offering() {
    return {
        id: "offering_standard",
        type: "offering",
        descriptionLines: [
            "Your faithful gather to make an offering in your name.",
            "They present their gifts with devotion."
        ],

        conditions: {
            event_selection_weight: 1.0
        },

        offering_formula: {
            base_favor: 1,
            faith_factor: 0.01,      // 1% of current faith
            food_factor: 0.005,      // 0.5% of current food
            gold_factor: 0.01,       // 1% of current gold
            decision_bonus: 0.5      // 0.5 favor per decision since last offering
        }
    };
}
