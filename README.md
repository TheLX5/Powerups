THIS IS NO LONGER BEING SUPPORTED.

# Description
The Custom Powerups patch is a package of a bunch of ASM hacks mainly created by MarioE and LX5 with the main goal of adding new powerups for Super Mario World with ease and give a bunch of tools for programmers to create their own powerups for the game.

# Features
## For regular users
- Several new powerups from various Mario (and other) games
- 32x32 player tilemap
- Dynamic powerup items and projectiles
- Easy and powerful customization options in the main patch and each powerup
- Enhanced vanilla blocks and powerup items to make them more interesting
- Better Powerdown patch native integration

## For programmers
- A nice ecosystem with RAM defines ready to use in every major tool (PIXI, GPS and UberASM Tool)
- Frees up ~22000 bytes of RAM at $7E2000
- Can insert up to 256 different powerups
- Several RAM addresses to alter the behavior of the patch's core engines
- Easy to use "add-on" engine to include specific ASM hacks for your powerups
- Total control of player's interaction field with ground and sprites
- A bunch of pointers to routines and tables ready to use at $02800C about various things of the patch
- Let's you install external ASM hacks that need to run during NMI at $00A304

# Installation
Follow the guide over [here](https://github.com/TheLX5/Powerups/wiki/2.-Installation)
