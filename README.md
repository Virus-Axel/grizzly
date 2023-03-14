# Summary
This is an arena blockchain game for grizzlython. The game is executed on the Solana blockchain and can be played on Android platform. The game is a strategy game, where you can spend and earn Solana or the bear currency token of the game. The arena battles are automatically played. Fighting makes your bear stronger. Beat more bears to increase your rank.

# Game

You won't be able to play until a grizzly bear NFT has been obtained. You will be presented with a grizzly selection page. The first step however is to connect your phantom wallet:

<p align="center">
<img src="https://github.com/Virus-Axel/grizzly/blob/master/screenshots/start.png"  width="25%" height="25%">
</p>

When phantom is connected your owned bear NFTs will be listed. You can purchase a new bear, or select any of your existing bears.

<p align="center">
<img src="https://github.com/Virus-Axel/grizzly/blob/master/screenshots/loading_bears.png"  width="25%" height="25%">
<img src="https://github.com/Virus-Axel/grizzly/blob/master/screenshots/bear_select.png"  width="25%" height="25%">
</p>

Pick your favorite bear and you will be placed inside of your bear's cabin. It is not much but it is something. Here you can view your bear's level and rank. You can also access the store, where you can trade new abilities and upgrades for your bear.

<p align="center">
<img src="https://github.com/Virus-Axel/grizzly/blob/master/screenshots/lobby.png"  width="50%" height="50%">
</p>
<p align="center">
<img src="https://github.com/Virus-Axel/grizzly/blob/master/screenshots/shop.png"  width="50%" height="50%">
</p>

Send your bear to fight! Send your bear to the forest arena. When an opponent is ready, a three step process is initiated to achive randomness on-chain. The process is based on diffie-hellman shared secret key exchange to get an unpredicted randomness. Any player failing to commit to the battle will be punnished. Before sending the bear to the arena, you can pick 5 abilities to utilize in the fight.

<p align="center">
<img src="https://github.com/Virus-Axel/grizzly/blob/master/screenshots/move_select.png"  width="50%" height="50%">
</p>

Algorithms behind the scenes and you will be redirected to the forest arena. Watch the crazy bears fighting and getting stronger. The winner might even get a prize. Yes you can earn up to 33 different tokens.

<p align="center">
<img src="https://github.com/Virus-Axel/grizzly/blob/master/screenshots/arena.png"  width="25%" height="25%">
</p>

# Building the Smart Contract
The smart contract is deployed on the testnet with program ID Gb8JJHRC7jrhnBQHJYxabPnKgKjj1RU1A7SB4iwchkeQ. Building the smart contract is straight forward. To build and deploy run:
```
cargo update
cargo build-sbf
solana program deploy target/deploy/grizzly_arena.so
```

# Building Android App
Building the android app requires export templates for the Godot 4 game engine. These export templates are modified to include Web3 support. The export templates exceed github's 100 MB size limit. Prebuild export templates and the prebuild android app might be hosted online in the future. For now they can be transmitted by request.

# Grizzlython
This is my submission for the Solana grizzlython 2023. Due to very complex build instructions for the app, and exceeding data limits, a prebuild android app should be transmitted in order to test the fighting system. Note that the game is a prototype and has some issues before going live on the Solana mainnet.

# Future Work
The known issues before deploying to mainnet is:
- NFT Metadata hosting, metadata is currently disabled
- Code coverage, Code has zero percentage test coverage.
- Automatic staking, the program assumes that NFT sales income is staked and returns are manually pushed back into the game.
