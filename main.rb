require "gosu"
require_relative "particle"

K_E = -500
G = 5
#DRAG = 1.0
PAN = 10

$exo_72 = Gosu::Font.new(72, {:name => "./Exo2.ttf"})
$exo_48 = Gosu::Font.new(48, {:name => "./Exo2.ttf"})
$exo_32 = Gosu::Font.new(32, {:name => "./Exo2.ttf"})
$exo_20 = Gosu::Font.new(20, {:name => "./Exo2.ttf"})

$colors = {"White" => 0xff_ffffff, "Orange" => 0xff_ffcc33, "Lime" => 0xff_ccff33,
        "Azure" => 0xff_33ccff, "Purple" => 0xff_cc33ff, "Mint" => 0xff_66ffcc,
        "Red" => 0xff_ff6633, "Green" => 0xff_33ff66, "Blue" => 0xff_6633ff}
$presets = {"Neutron"    => [1.0,0.0,nil,$colors["White"],[]],
            "Proton"     => [1.0,1.0,nil,$colors["Azure"],[]],
            "Antiproton" => [1.0,-1.0,nil,$colors["Orange"],[]],
            "Electron"   => [0.25,-1.0,nil,$colors["Lime"],[]],
            "Positron"   => [0.25,1.0,nil,$colors["Purple"],[]],
            "Neutrino"   => [0.25,0.0,nil,$colors["Mint"],[]],
            "Exotic (0)"  => [-1.0,0.0,nil,$colors["Green"],[]],
            "Exotic (+)"  => [-1.0,1.0,nil,$colors["Blue"],[]],
            "Exotic (-)"  => [-1.0,-1.0,nil,$colors["Red"],[]]}

def physics(a, b)
    rr = (a.pos[0] - b.pos[0])**2 + (a.pos[1] - b.pos[1])**2
    f_mag = (K_E * a.charge * b.charge)/rr + (G * a.mass * b.mass)/rr
    f_theta = Math.atan2(b.pos[0] - a.pos[0], b.pos[1] - a.pos[1])
    f_x = f_mag * Math.sin(f_theta)
    f_y = f_mag * Math.cos(f_theta)
    return [f_x, f_y]
end

def col(a, b)
    d = Gosu::distance(a.pos[0], a.pos[1], b.pos[0], b.pos[1])
    lim = 16 * (Math.sqrt(a.mass.abs) + Math.sqrt(b.mass.abs))
    if d < lim
        k = Particle.new(a.mass + b.mass, a.charge + b.charge, nil, Gosu::Color.new(255, rand(256 - 40) + 40, rand(256 - 40) + 40, rand(256 - 40) + 40), [a,b])
        if k.mass == 0
            return nil
        else
            k.pos[0] = (a.pos[0]*a.mass.abs + b.pos[0]*b.mass.abs)/(a.mass.abs+b.mass.abs)
            k.pos[1] = (a.pos[1]*a.mass.abs + b.pos[1]*b.mass.abs)/(a.mass.abs+b.mass.abs)
            k.vel[0] = (a.vel[0]*a.mass + b.vel[0]*b.mass)/k.mass
            k.vel[1] = (a.vel[1]*a.mass + b.vel[1]*b.mass)/k.mass
            return k
        end
    else return false end
end
class SimWindow < Gosu::Window
    def initialize
        super 1280, 720
        @particles = []
        @new_particles = []
        @col_particles = []
        @set_particle = [1.0,0.0,nil,$colors["White"],[]]
        @set_name = "Neutron"
        @target = nil
    end

    def needs_cursor?
        true
    end

    def button_down(id)
        if id == Gosu::MsLeft #Begin particle shot
            @target = [self.mouse_x, self.mouse_y]

        elsif id == (Gosu::MsMiddle or Gosu::KbSpace) #Create particle in place
            part = Particle.new(*@set_particle)
            part.pos[0],part.pos[1] = self.mouse_x, self.mouse_y
            @particles << part

        #Presets
        elsif id == Gosu::Kb1 then @set_particle = $presets.values[0]; @set_name = $presets.keys[0]
        elsif id == Gosu::Kb2 then @set_particle = $presets.values[1]; @set_name = $presets.keys[1]
        elsif id == Gosu::Kb3 then @set_particle = $presets.values[2]; @set_name = $presets.keys[2]
        elsif id == Gosu::Kb4 then @set_particle = $presets.values[3]; @set_name = $presets.keys[3]
        elsif id == Gosu::Kb5 then @set_particle = $presets.values[4]; @set_name = $presets.keys[4]
        elsif id == Gosu::Kb6 then @set_particle = $presets.values[5]; @set_name = $presets.keys[5]
        elsif id == Gosu::Kb7 then @set_particle = $presets.values[6]; @set_name = $presets.keys[6]
        elsif id == Gosu::Kb8 then @set_particle = $presets.values[7]; @set_name = $presets.keys[7]
        elsif id == Gosu::Kb9 then @set_particle = $presets.values[8]; @set_name = $presets.keys[8]
        #Modifications
        elsif id == Gosu::KbMinus then @set_particle[1] -= 1.0; @set_name = "Custom"
        elsif id == Gosu::KbEqual then @set_particle[1] += 1.0; @set_name = "Custom"
        elsif id == Gosu::KbBracketLeft then @set_particle[0] = @set_particle[0] * 0.5; @set_name = "Custom"
        elsif id == Gosu::KbBracketRight then @set_particle[0] = @set_particle[0] * 2.0; @set_name = "Custom"
        elsif id == Gosu::KbBackslash then @set_particle[0] = @set_particle[0] * -1.0; @set_name = "Custom"
        elsif id == Gosu::KbBackspace then @set_particle[3] = $colors.values[rand(8)]; @set_name = "Custom"

        elsif id == Gosu::KbEscape
            @particles = []
        end
    end

    def button_up(id)
        if (id == Gosu::MsLeft) and (@target != nil)
            part = Particle.new(*@set_particle)
            part.pos[0],part.pos[1] = self.mouse_x, self.mouse_y
            part.vel[0] = (@target[0] - self.mouse_x)/16
            part.vel[1] = (@target[1] - self.mouse_y)/16
            @particles << part
            @target = nil
        end
    end

    def update
        @particles.each do |i|
            if (i.pos[0].nan?) or (i.pos[1].nan?)
                @particles.delete(i)
            end
            if button_down?(Gosu::KbW) then i.pos[1] += PAN end
            if button_down?(Gosu::KbA) then i.pos[0] += PAN end
            if button_down?(Gosu::KbS) then i.pos[1] -= PAN end
            if button_down?(Gosu::KbD) then i.pos[0] -= PAN end
        end
        @new_particles = @particles.clone
        @new_particles.each do |i|
            @particles.each do |j|
                if i != j
                    k = col(i,j)
                    if k == nil
                        @new_particles.delete(i)
                        @new_particles.delete(j)
                    elsif k == false
                        f = physics(i, j)
                        i.vel[0] += f[0] / i.mass
                        i.vel[1] += f[1] / i.mass
                    else
                        @new_particles.delete(i)
                        @new_particles.delete(j)
                        @col_particles << k
                    end
                end
            end
            i.pos[0] += i.vel[0]
            i.pos[1] += i.vel[1]
            #i.vel[0] = i.vel[0] * DRAG
            #i.vel[1] = i.vel[1] * DRAG
        end

        @particles = @new_particles.clone
        @particles.push(*@col_particles)
        @col_particles = []
    end

    def draw
        $exo_48.draw_rel("Particle Sim", 640, 0, 0, 0.5, 0.0)
        $exo_32.draw_rel("Alpha", 640, 48, 0, 0.5, 0.0)

        $exo_20.draw_rel("#{@set_name}", 0, 0, 0, 0.0, 0.0, 1.0, 1.0, @set_particle[3])
        $exo_20.draw_rel("Mass: #{@set_particle[0]}", 0, 20, 0, 0.0, 0.0)
        $exo_20.draw_rel("Charge: #{@set_particle[1]}", 0, 40, 0, 0.0, 0.0)

        $exo_20.draw_rel("- Backspace for random color", 120, 0, 0, 0.0, 0.0, 1.0, 1.0, 0xff_666666)
        $exo_20.draw_rel("- Brackets and backslash", 120, 20, 0, 0.0, 0.0, 1.0, 1.0, 0xff_666666)
        $exo_20.draw_rel("- Plus and minus", 120, 40, 0, 0.0, 0.0, 1.0, 1.0, 0xff_666666)

        $exo_20.draw_rel("#{@particles.size} particles", 960, 0, 0, 0.5, 0.0, 1.0, 1.0, 0xff_666666)
        $exo_20.draw_rel("#{Gosu::fps} FPS", 960, 20, 0, 0.5, 0.0, 1.0, 1.0, 0xff_666666)

        $exo_20.draw_rel("LMB to add a particle", 1280, 0, 0, 1.0, 0.0)
        $exo_20.draw_rel("1-9 to select a preset", 1280, 20, 0, 1.0, 0.0)
        $exo_20.draw_rel("Esc to clear the screen", 1280, 40, 0, 1.0, 0.0)
        $exo_20.draw_rel("WASD to pan around", 1280, 60, 0, 1.0, 0.0)

        if @target != nil
            Gosu::draw_line(self.mouse_x,self.mouse_y,$colors["White"],@target[0],@target[1],$colors["White"])
        end

        @particles.each do |i|
            i.draw
        end
    end
end


sim = SimWindow.new
sim.show
