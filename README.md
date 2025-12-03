# What is Thy Offering?

"What is Thy Offering?" is a video game made in Game Maker Studio for B1T Jam 3.

The jam's theme is "Offering" and it requires a 1-bit art style.

## Gameplay

"What is Thy Offering?" is a resource management game simmilar to Reigns.
The player is in control of a god who will make decisions for their followers, and use their godly powers to influence the fate of their disciples.

During the game, the player will be presented with a series of events and choices.
Events come in 6 forms:
- Decisions
- Boons
- Disasters
- Resource Exchanges
- Offerings
- Store Visits

Events will impact the player's current resources, increasing or decreasing the player's stockpiles.

The player must manage 4 resources:
- Faith
- Food
- Gold
- Divine Favor

If the player ever runs out of Faith or Food, the game ends in a failure.

At the end of the game, the player's score will equal their final Faith amount.

In addition to the sequence of events, players will occasionally be able to purchase new godly powers using their Divine Favor.
Godly powers can unlock new options during descision events, improve boons, mitigate disasters, improve resource exchange rates, or increase offerings.

### Decisions

Decisions are the most common type of event.
The player is shown a description of the decision they must make, and a handful of options they can take to resolve the decision.

For example:

One of your priests has been has been caught spreading the gospel of a different god, how will you react?
- Smite him on the spot (costs 1 Divine Favor)
- \[Merciful\] Give him another chance
- Excommunicate him
- Have your disciples stone him to death

-- End of Example --

Once the player makes a selection from the available options, they will be shown the outcome of their choice.
The outcome will usually change the player's resources in some fashion.

For example, if the player chooses "Excommunicate him" then their resources would be updated as follows:

Your decision to excommunicate pleases your congregation. 
Unfortunately, the priest stole some of your food as he fled.

\+ 2 Faith 

\- 1 Food

-- End of Example --

Options for descisions are influenced by a few things:

1. The foremost example is when a player buys godly powers from the store.
Godly powers will apply to specific decision events, providing new and usually better options to select. When an option is added by a godly power, it will appear with the godly power's name first in square brackets, like "\[Merciful\]" in the example above.

2. Some options will require the expenditure of the player's resources. These options are frequently (but not always) more advantageous than the options which cost no resources, and do not come from a godly power. When an option costs resource, the cost will be spelled out in parenthesis like "(costs 1 Divine Favor)" in the example above.

3. Some options will be unlocked or locked based on the options the player has selected during previous descision events, or the boons or disasters that the player has encountered. These options are not identified in any special way to the player, they appear the same as other options and can even have costs or come from godly powers.

### Boons

Boons are reward events that enrich the player in various ways.
Rewards from boons come in the following forms:

1. Resources added to the player's current resource pools.
2. New godly powers
3. Unlocking positive options in future events.
4. Unlocking new, typically beneficial events that the player may encounter in the future.

Boons will appear as two separate screens.
The first screen shows a description of the boon.
The second screen shows the description of the spoils rewarded by the boon.

For example, the first screen may appear as:

Your disciples are blessed by a fertile crop. 
The farms are thick with ripe food to harvest.

-- End of Example --

And the second screen could appear as:

You gain a surplus of food!

\+ 5 Food

-- End of Example --

Boons are rare, but can be made more common by godly powers.

### Disasters

Disasters are the opposite of boon events, usually detracting from the player's resoruces.

Disasters can have the following consequences:
1. Removing resources from the player's current resource pools.
2. Removing options from the player's future events
3. Unlocking new, detrimental events that the player can encounter in the future.

Disasters will appear as two separate screens.
The first screen shows the description of the disaster.
The second screen shows the consequences of the disaster on the player's resources / future.

For example, the first screen may appear as:

Your flock is beset by plague! Sickness ferments across the land.

-- End of Example --

Then the second screen could appear as:

You lose faithful followers.
Also, new events have been unlocked.

- 3 Faith

-- End of Example --

Disasters are rare, but slightly more common than boons.
They can be made less common by godly powers.

### Resource Exchanges

Resource Exchange events are an opportunity for the player to exchange their resources for different resources.
Typically the exchange rates are unfavorable, however some godly powers can improve the rates of certain exchanges.

In general, resources are ranked as follows:

1. "Divine Favor" is the most valuable resource. It can be used to unlock new godly powers, and is used in the cost of some of the strongest descision options.
2. "Faith" is the second most valuable resource. Faith is used as the player's end game score and is the hardest resource to increase.
3. "Food" is next, as running out of food ends the player's game. Food changes frequently and acutely, it is the most changeable resource in the game.
4. "Gold" is the least valuable resource, it is used frequently in the cost of different descision options. There is no consequence for running out of gold.

Resource exchanges will appear as two separate screens.
The first screen shows the description of the exchange, and gives the player options about what exchange they'd like to perform.
The second screen shows the conclusion of the resource exchange.

For example, the first screen may appear as:

A caravan approaches your disciples, packed with wares and the whispers of trade.
Would you like to exchange any of your resources?
- Exchange 3 gold for 2 food
- Exchange 3 gold for 1 faith
- Exchange 3 food for 2 gold
- Exchange 3 faith for 2 food
- Exchange 3 faith for 2 gold
- Don't exchange any resources

-- End of Example --

Then, supposing the player selected "Exchange 3 gold for 2 food," the second screen could appear as:

The traders are happy to exchange your gold for some of their food.
Your food stores are replenished.

\+ 2 Food

\- 3 Gold

-- End of Example --

Resource exchange events are more common than boons or disasters, but less common than decisions.

### Offerings

Offering events are the final type of event, and are used to give the player Divine Favor.
Offerings are the only way for the player to gain Divine Favor.

The amount of Divine Favor rewarded by an offering event is based on:
1. The player's current resource pools
2. Decisions the player has made since the last offering event
3. Godly powers which improve offering events

Offerings can occasionally provide resources other than Divine Favor as well.

Offerings will appear as two separate screens.
The first screen shows a description of the disciples making their offering.
The second screen shows the divine favor or other resources that the player's disciples offered them.

For example, the first screen may appear as:

Your disciples have gathered at the temple with an offering.
Their strong faith and comfortable material circumstances have increased the size of their offering.

-- End of Example --

Then the second screen could appear as:

Your disciples' offering empowers your godly might!

\+ 5 Divine Favor

-- End of Example --

Offering events are rare, and are spaced out regularly, occuring once every ~5 events.
Immediately following an offering event, the player is provided an opportunity to "shop" for new godly powers using their accumulated Divine Favor.

### Store Visits

Store Visit events occur immediately after every Offering event. 
During Store Visit events the player will have an opportunity to exchange Divine Favor (and occasionally some other resources) for new godly powers which will impact future events.

Godly powers can impact a number of different things:
1. Some powers provide new options to select during decision events.
2. Some powers improve resource exchange rates during research exchange events.
3. Some powers lessen the impact of disasters, while others reduce the frequency of disaster events.
4. Some powers increase the benefits of boons, while others increase the frequency of boon events.
5. Some powers unlock new, and typically beneficial events.
6. Most powers unlock stronger godly powers which can be acquired during future store visits.
7. Some powers allow the player to purchase more than one godly power during each store visit, while others increase the number of available powers shown during each visit.

Choosing which powers to buy is the main strategic element of the game.
Players will be unable to unlock all of the godly powers during any single playthrough, so they must choose which they take wisely.

Additionally, the store will only have a limited number of powers available each time the player visits.
The available powers will be selected randomly, but will tend to include the more powerful versions of the powers the player chose during previous store visits

Store Visits will appear as two separate screens.
The first screen shows a description of the store and the available godly powers.
The second screen shows more details about the power(s) that the player purchased.

For example, the first screen may appear as:

You are blessed with an opportunity to increase your power.
Spend your divine favor to become stronger and to prepare for the challenges yet to come:
- \[Merciful\] Show mercy during decision events to strengthen your disciple's faith. (2 Divine Favor)
- \[Quick\] Use your quick fingers to steal more power for yourself during store visits. (3 Divine Favor)
- \[Brutal\] Inspire fear and obedience amongst your flock with brutality. (1 Divine Favor)
- \[Temporal\] Use your control of time to shorten the period between offering events (2 Divine Favor)
- Don't purchase any powers

-- End of Example --

Then, supposing the player selected "\[Merciful\]" as their purchase, the second screen could appear as:

Your disciples will thank you for your mercy in future events.
- Unlocked new events
- Unlocked new options for decision events

-- End of Example --

## Other Details

## Roguelite Mechanics

The game has some very basic roguelite elements:
1. A "High Scores" screen accessible from the main menu and after the game over screen which displays the player's highest scores. 
Player's scores come from the amount of faith the player has in their resource pools at the end of a successful run.
2. A "Godly Powers" screen for viewing the available godly powers that can be unlocked during gameplay.
The godly powers are arranged as a "tech tree" where some powers can only be unlocked after a previous power on the tree has been purchased during a store event.
The screen shows the entire tech tree, but the names + details of any godly powers that the player has not unlocked during one of their runs will be hidden. The player will be unable to acquire all powers during any single run, so this screen is intended to fill in with details as the player selects different godly powers across multiple runs.

### Organization

The game is organized across 8 rooms:
1. MainMenu is the landing room and allows the player to start new runs, access the high scores and godly powers screens, access the settings menu, and access an About page.
2. GameSetup describes the goals of the game to the player, and allows them to select a god to play as. Each god starts with a different godly power.
3. Game is where the main gameplay loop takes place. It will be used for all event types.
4. GameOver is used at the end of each run to show the player their results. It is used for both successful runs and failed runs.
5. HighScores is used to show the player the results of all of their runs as described above.
6. Powers is used to show the the godly power "tech tree" as described above.
7. Settings is used to configure the game's settings like volume level and fullscreen mode.
8. About is used to provide a brief synopsis of the game and the circumstances around its creation.

