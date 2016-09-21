require "gosu"
require_relative "particle"

K_E = -500 #Strength of the electromagnetic force
G = 5 #Strength of gravity
#DRAG = 1.0 #Strength of drag (currently disabled)
PAN = 15 #Speed of panning
$pause = false #Sim starts unpaused

$exo_72 = Gosu::Font.new(72, {:name => "assets/Exo2.ttf"}) #Font definitions
$exo_48 = Gosu::Font.new(48, {:name => "assets/Exo2.ttf"})
$exo_32 = Gosu::Font.new(32, {:name => "assets/Exo2.ttf"})
$exo_20 = Gosu::Font.new(20, {:name => "assets/Exo2.ttf"})

$colors = {"White" => 0xff_ffffff, "Orange" => 0xff_ffcc33, "Lime" => 0xff_ccff33, #Color definitions
        "Azure" => 0xff_33ccff, "Purple" => 0xff_cc33ff, "Mint" => 0xff_66ffcc,
        "Red" => 0xff_ff6633, "Green" => 0xff_33ff66, "Blue" => 0xff_6633ff}
$presets = {"Neutron"    => [1.0,0.0,nil,$colors["White"],[]], #Preset definitions
            "Proton"     => [1.0,1.0,nil,$colors["Azure"],[]],
            "Antiproton" => [1.0,-1.0,nil,$colors["Orange"],[]],
            "Electron"   => [0.25,-1.0,nil,$colors["Lime"],[]],
            "Positron"   => [0.25,1.0,nil,$colors["Purple"],[]],
            "Neutrino"   => [0.25,0.0,nil,$colors["Mint"],[]],
            "Exotic (0)"  => [-1.0,0.0,nil,$colors["Green"],[]],
            "Exotic (+)"  => [-1.0,1.0,nil,$colors["Blue"],[]],
            "Exotic (-)"  => [-1.0,-1.0,nil,$colors["Red"],[]]}

def physics(a, b) #EM force and gravity
    rr = (a.pos[0] - b.pos[0])**2 + (a.pos[1] - b.pos[1])**2 #Find the distance between the two particles, squared
    f_mag = (K_E * a.charge * b.charge)/rr + (G * a.mass * b.mass)/rr #Calculate the magnitude of the force
    f_theta = Math.atan2(b.pos[0] - a.pos[0], b.pos[1] - a.pos[1]) #Calculate the angle between the particles
    f_x = f_mag * Math.sin(f_theta) #Split the force vector into its components
    f_y = f_mag * Math.cos(f_theta)
    return [f_x, f_y] #And spit out that vector
end

def col(a, b) #Collision detection
    d = Gosu::distance(a.pos[0], a.pos[1], b.pos[0], b.pos[1]) #Find the distance between the particles
    lim = 16 * (Math.sqrt(a.mass.abs) + Math.sqrt(b.mass.abs))
    if d < lim #If it is low, combine the two particles into a new one
        k = Particle.new(a.mass + b.mass, a.charge + b.charge, nil, Gosu::Color.new(255, rand(256 - 40) + 40, rand(256 - 40) + 40, rand(256 - 40) + 40), [a,b])
        if k.mass == 0 #If the resulting particle has no mass, simply discard it and continue with the sim
            return nil
        else #Otherwise, set its position and velocity to the weighted average
            k.pos[0] = (a.pos[0]*a.mass.abs + b.pos[0]*b.mass.abs)/(a.mass.abs+b.mass.abs)
            k.pos[1] = (a.pos[1]*a.mass.abs + b.pos[1]*b.mass.abs)/(a.mass.abs+b.mass.abs)
            k.vel[0] = (a.vel[0]*a.mass + b.vel[0]*b.mass)/k.mass
            k.vel[1] = (a.vel[1]*a.mass + b.vel[1]*b.mass)/k.mass
            return k #Return the resulting particle
        end
    else return false end #If the particles are not colliding, return false
end

class SimWindow < Gosu::Window
    def initialize
        super 1280, 720 #Set the window size
        @particles = []
        @col_particles = []
        @set_particle = [1.0,0.0,nil,$colors["White"],[]] #Set the default particle to "Neutron"
        @set_name = "Neutron"
        @target = nil #No firing target yet
    end

    def needs_cursor?
        true
    end

    def button_down(id)
        if id == Gosu::MsLeft #Fire particle
            @target = [self.mouse_x, self.mouse_y] #Set the target

        elsif id == Gosu::MsMiddle #Still particle
            part = Particle.new(*@set_particle) #Create the particle...
            part.pos[0],part.pos[1] = self.mouse_x, self.mouse_y #Set its position to the cursor...
            @particles << part #And add it to the particle array.

        elsif id == Gosu::MsRight #Delete particle
            @particles.each do |i|
                d = Gosu::distance(i.pos[0], i.pos[1], self.mouse_x, self.mouse_y) #Check the distance to all particles
                lim = 20 * (Math.sqrt(i.mass.abs))
                if d < lim then @particles.delete(i) end #If it is low enough, delete it
            end

        #Preset detections
        elsif id == Gosu::Kb1 then @set_particle = $presets.values[0].clone; @set_name = $presets.keys[0]
        elsif id == Gosu::Kb2 then @set_particle = $presets.values[1].clone; @set_name = $presets.keys[1]
        elsif id == Gosu::Kb3 then @set_particle = $presets.values[2].clone; @set_name = $presets.keys[2]
        elsif id == Gosu::Kb4 then @set_particle = $presets.values[3].clone; @set_name = $presets.keys[3]
        elsif id == Gosu::Kb5 then @set_particle = $presets.values[4].clone; @set_name = $presets.keys[4]
        elsif id == Gosu::Kb6 then @set_particle = $presets.values[5].clone; @set_name = $presets.keys[5]
        elsif id == Gosu::Kb7 then @set_particle = $presets.values[6].clone; @set_name = $presets.keys[6]
        elsif id == Gosu::Kb8 then @set_particle = $presets.values[7].clone; @set_name = $presets.keys[7]
        elsif id == Gosu::Kb9 then @set_particle = $presets.values[8].clone; @set_name = $presets.keys[8]

        #Customization detections
        elsif id == Gosu::KbMinus then @set_particle[1] -= 1.0; @set_name = "Custom"
        elsif id == Gosu::KbEqual then @set_particle[1] += 1.0; @set_name = "Custom"
        elsif id == Gosu::KbBracketLeft then @set_particle[0] = @set_particle[0] * 0.5; @set_name = "Custom"
        elsif id == Gosu::KbBracketRight then @set_particle[0] = @set_particle[0] * 2.0; @set_name = "Custom"
        elsif id == Gosu::KbBackslash then @set_particle[0] = @set_particle[0] * -1.0; @set_name = "Custom"
        elsif id == Gosu::KbBackspace then @set_particle[3] = $colors.values[rand(8)]; @set_name = "Custom"

        elsif id == Gosu::KbSpace #Detect if the user is trying to toggle pause state
            if $pause == true #If paused, unpause
                $pause = false
            else $pause = true #If unpaused, pause
            end

        elsif id == Gosu::KbEscape
            @particles = []
        end
    end

    def button_up(id) #Particle launching
        if (id == Gosu::MsLeft) and (@target != nil) #If the user lets go of left mouse...
            part = Particle.new(*@set_particle) #Create a new particle...
            part.pos[0],part.pos[1] = self.mouse_x, self.mouse_y #Set its position to the mouse...
            part.vel[0] = (@target[0] - self.mouse_x)/16 #Set its velocity to the line length/16...
            part.vel[1] = (@target[1] - self.mouse_y)/16
            @particles << part #And add it to the particle array.
            @target = nil #Also, clear the target.
        end
    end

    def update
        if $pause == true then return end #If the sim is paused, don't update

        @particles.each do |i|
            if (i.pos[0].nan?) or (i.pos[1].nan?) #Delete any NaN particles
                @particles.delete(i)
            end
            if button_down?(Gosu::KbW) then i.pos[1] += PAN end #Panning
            if button_down?(Gosu::KbA) then i.pos[0] += PAN end
            if button_down?(Gosu::KbS) then i.pos[1] -= PAN end
            if button_down?(Gosu::KbD) then i.pos[0] -= PAN end
        end

        @particles.each do |i|
            @particles.each do |j|
                if i != j
                    k = col(i,j)
                    if k != false #If the particles collide, delete them
                        if k != nil #If the resulting particle has mass, create it
                            @col_particles << k #Exclude the new particle from the physics calculations
                        end
                        @particles.delete(i)
                        @particles.delete(j)
                    else #If the particles are not colliding, calculate physics
                        f = physics(i, j)
                        i.vel[0] += f[0] / i.mass #Convert force into velocity
                        i.vel[1] += f[1] / i.mass
                    end
                end
            end
        end

        @particles.each do |i|
            i.pos[0] += i.vel[0]
            i.pos[1] += i.vel[1]
        end

        @particles.push(*@col_particles) #Any particles from collisions are now added back into the sim
        @col_particles = [] #...and delted from the collision array
    end

    def draw
        @particles.each do |i| #Draw particles
            i.draw
        end

        $exo_48.draw_rel("Particle Sim", 640, 0, 0, 0.5, 0.0) #Draw middle text
        $exo_32.draw_rel("Alpha", 640, 48, 0, 0.5, 0.0)

        $exo_20.draw_rel("#{@set_name}", 0, 0, 0, 0.0, 0.0, 1.0, 1.0, @set_particle[3]) #Draw particle stats
        $exo_20.draw_rel("Mass: #{@set_particle[0]}", 0, 20, 0, 0.0, 0.0)
        $exo_20.draw_rel("Charge: #{@set_particle[1]}", 0, 40, 0, 0.0, 0.0)

        $exo_20.draw_rel("- Backspace for random color", 120, 0, 0, 0.0, 0.0, 1.0, 1.0, 0xff_666666) #Draw particle controls
        $exo_20.draw_rel("- Brackets and backslash", 120, 20, 0, 0.0, 0.0, 1.0, 1.0, 0xff_666666)
        $exo_20.draw_rel("- Plus and minus", 120, 40, 0, 0.0, 0.0, 1.0, 1.0, 0xff_666666)

        $exo_20.draw_rel("#{@particles.size} particles", 960, 0, 0, 0.5, 0.0, 1.0, 1.0, 0xff_666666) #Draw sim stats
        $exo_20.draw_rel("#{Gosu::fps} FPS", 960, 20, 0, 0.5, 0.0, 1.0, 1.0, 0xff_666666)

        $exo_20.draw_rel("LMB to fire a particle", 1280, 0, 0, 1.0, 0.0) #Draw controls
        $exo_20.draw_rel("MMB to place a particle", 1280, 20, 0, 1.0, 0.0)
        $exo_20.draw_rel("RMB to delete a particle", 1280, 40, 0, 1.0, 0.0)
        $exo_20.draw_rel("Space to pause", 1280, 60, 0, 1.0, 0.0)
        $exo_20.draw_rel("1-9 to select a preset", 1280, 80, 0, 1.0, 0.0)
        $exo_20.draw_rel("Esc to clear the screen", 1280, 100, 0, 1.0, 0.0)
        $exo_20.draw_rel("WASD to pan around", 1280, 120, 0, 1.0, 0.0)

        if @target != nil #If the user is holding LMB down, draw a line to the target
            Gosu::draw_line(self.mouse_x,self.mouse_y,$colors["White"],@target[0],@target[1],$colors["White"])
        end

        if $pause == true #If paused, tell the user
            $exo_72.draw_rel("PAUSED", 640, 696, 0, 0.5, 1.0)
        end
    end
end


sim = SimWindow.new
sim.show
