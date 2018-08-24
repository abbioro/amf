# AMF

AMF is an Arma 3 mission framework for my Arma group. It's tailored specifically for my group and assumes the presence of a few mods so you'll unlikely be able to use it for your group as-is. However it might still be worth studying if you find anything worth adding to your own group. The framework relies almost entirely on [Event Scripts](https://community.bistudio.com/wiki/Event_Scripts) and the code is small, so it should be easy to understand.

## Notable Features

- [ACRE2](https://github.com/IDI-Systems/acre2) radio channels are restored on respawn
- Initial spawn loadouts are restored on respawn
- Real-time player icon on map to help with MOUT
- Incapacitated units are invulnerable (Arma 3 Revive system)
- Units spawning with medikits are given the medic trait
- Units with the medic trait are given the appropriate icon in [STHUD](https://gitlab.com/shacktac-public/general/wikis/home)
- Reduced AI skill settings
- (Limited) ACRE2 Zeus compatibility
