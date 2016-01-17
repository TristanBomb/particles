# Particles
Particle System - The physics kind!

## Planned Mechanics
* Add particles
* Render particles (scale of mass 1 is 64, increased with square root)
* Simulate:
  * Charge
  * Velocity
  * Collision (collision range is half the sprite size)
  * Radioactivity (λ = 10/radioactivity)

## Controls
* Plus/Minus: Edit charge
* Brackets: Edit mass
* Semicolon/Quote: Edit radioactivity
* Backslash: Randomize color
* Left click: Create particle
* Left click, drag, release: Launch particle
* Comma/period: Cycle through saved particles
* Space: Pause
* Backspace: Clear simulation

## Particles:
Note: particles are not accurate to reality.
* Proton: Mass 1, charge +1, radioactivity 0, #FF4444
* Neutron: Mass 1, charge 0, radioactivity 1, #44FF44
* Electron: Mass 0.1, charge -1, radioactivity 0, #44A2FF
* Muon: Mass 0.4, charge -1, radioactivity 2, #A244FF
* Tauon: Mass 1.6, charge -1, radioactivity 4, #FFA244
