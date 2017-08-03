# Description
Makes possible to have custom powerups on Super Mario World.

# Features
- Insert powerups on 256 different slots.
- Make different palettes for every powerup.
- 32x32 Player GFX (WIP)
- Every powerup can have its own item image and can give Mario different graphics.
- Modify the behavior (or at least most of it) of the original powerups.
- Change and create your own player tilemap tables.
- Add custom code for custom player poses.
- Custom layout for the player graphics files.
- Frees up 22000 bytes of RAM in $7E2000.
- Total control of Item Box with Item Box Special 1.2 patch.
- Create custom player hitboxes with any kind of sprites.
- Create custom player interaction points with Layer 1 and 2.
- Use extended sprites for those powerups that shoots projectiles.
- Dynamically uploading GFX tiles of projectiles on screen.
- Add custom code (add-ons) from other people.
- Easy to update and edit the engine files.
- Easier way to add powerups.

# Planned features
- 32x32 Player GFX
- Easier addition of multiple players
- Make usage of the cape tilemap as a 5th tile.

# Deprecated features
**- Be able to use compressed Player graphics (this would leave used $7E2000 again).** There are no 32KB blocks of free RAM for this.
 
# 32x32 GFX
I tried to merge the 32x32 player patch inside this one, it is supposed to read 32x32 tilemap code, but for some reason it just crashes, so I gave up. If anyone is interested on get this to work, go for it. My progress is on '32' folder.

# Dynamic Z notes
Mario ExGFX, Custom player palettes and Mario 8x8 tiles DMAer features won't be available when using Dynamic Z, you will need to read Dynamic Z manual in order to have Custom player palettes and Mario ExGFX, however, Mario 8x8 tiles DMAer isn't integrated into Dynamic Z so you will have to ask anonimzwx for that feature if he hasn't added it yet.

# Lastest beta release
Doesn't contain any code from here and has some missing features from the list.
http://bin.smwcentral.net/u/12344/powerup_pack.zip
