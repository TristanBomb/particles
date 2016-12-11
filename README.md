# Particles
Particle System - The physics kind!

This is a small little toy to simulate particles; currently, electromagnetism,
gravity, and collision are implemented. In the future, radioactivity and
possibly chromodynamics will be added as well. The forces are fairly accurate
to reality, but the constants are different, as are particle masses.

## Installation
This application requires Ruby, RubyGems, and the Gosu gem.

On Linux:

* Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) from
your distribution's package manager, or from source. On Debian and Ubuntu, this
will be `sudo apt-get install ruby`; for other distros, this will be different.
* In most Ruby packages, RubyGems will be already included. If not, either get
it from your package manager or (compile it)[https://rubygems.org/pages/download].
* Run `sudo gem install gosu` to - you guessed it - install Gosu.
* Download the source from GitHub and run `main.rb`.

On Windows:

* Install Ruby (v2.0.0+) from [RubyInstaller](http://rubyinstaller.org/downloads/).
* On the same page, download and install the DevKit that matches the version
of Ruby you just installed.
* Run `gem install gosu`. If this fails, see [here](http://stackoverflow.com/questions/18908708/installing-ruby-gem-in-windows).
* Finally, run `main.rb`.
*Note that I have not tested this application on Windows, so no promises!*

I am not familiar with OSX, so unfortunately I cannot help you there.

## Controls
* Left click and drag: Create particle with velocity
* Middle click: Create still particle
* Right click: Delete particle
* Escape: Clear the screen
* Space: Pause the simulation
* WASD: Pan the view
* Numbers 1-9: Load presets
* Backspace: Pick random color
* Plus/minus: Increase/decrease charge
* Brackets: Increase/decrease mass
* Backslash: Invert mass

## Particle Presets
Note: particle masses are not accurate to reality.

1. Neutron: Mass 1, charge 0, #FFFFFF
2. Proton: Mass 1, charge +1, #33CCFF
3. Antiproton: Mass 1, charge -1, #FFCC33
4. Electron: Mass 0.25, charge -1, #CCFF33
5. Positron: Mass 0.25, charge +1, #CC33FF
6. Neutrino: Mass 0.25, charge +1, #66FFCC
7. Exotic (0): Mass -1, charge 0, #33FF66
8. Exotic (+): Mass -1, charge +1, #FF6633
9. Exotic (-): Mass -1, charge -1, #6633FF
] from your distribution's package manager, or from source.
On Debian and Ubuntu, this will be `sudo apt-get install ruby`; for other distros,
this will be different.
* In most Ruby packages, RubyGems will be already included. If not, either get
it from your package manager or (compile it)[https://rubygems.org/pages/download].
*

## Controls
* Left click and drag: Create particle with velocity
* Middle click: Create still particle
* Right click: Delete particle
* Escape: Clear the screen
* Space: Pause the simulation
* WASD: Pan the view
* Numbers 1-9: Load presets
* Backspace: Pick random color
* Plus/minus: Increase/decrease charge
* Brackets: Increase/decrease mass
* Backslash: Invert mass

## Particle Presets
Note: particle masses are not accurate to reality.

1. Neutron: Mass 1, charge 0, #FFFFFF
2. Proton: Mass 1, charge +1, #33CCFF
3. Antiproton: Mass 1, charge -1, #FFCC33
4. Electron: Mass 0.25, charge -1, #CCFF33
5. Positron: Mass 0.25, charge +1, #CC33FF
6. Neutrino: Mass 0.25, charge +1, #66FFCC
7. Exotic (0): Mass -1, charge 0, #33FF66
8. Exotic (+): Mass -1, charge +1, #FF6633
9. Exotic (-): Mass -1, charge -1, #6633FF
