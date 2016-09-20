require "gosu"

class Particle
    attr_accessor :pos, :vel, :mass, :charge, :halflife, :color
    @@image = Gosu::Image.new("assets/particle.png")
    @@plus = Gosu::Image.new("assets/plus.png")
    @@minus = Gosu::Image.new("assets/minus.png")

    def initialize(m = 1.0, q = 1.0, t = nil, c = Gosu::Color.argb(0xff_ffffff), d = [])
        @mass, @charge, @halflife, @color = m, q, t, c
        @decay = d #What the particle will decay into
        @pos = [640, 360], @vel = [0,0]
        @sign_color = Gosu::Color.argb(0xff_ffffff)
    end

    def draw
        @sign_color.alpha = 255*(1-(0.7)**(@charge/@mass).abs) #Calculate the opacity of the charge symbol
        @@image.draw_rot(@pos[0], @pos[1], 0, 0, 0.5, 0.5, Math.sqrt(@mass.abs)/4, Math.sqrt(@mass.abs)/4, @color, :add) #Draw the particle itself
        if @mass < 0 #If the particle has negative mass, draw a black core
            @@image.draw_rot(@pos[0], @pos[1], 0, 0, 0.5, 0.5, Math.sqrt(@mass.abs)/6, Math.sqrt(@mass.abs)/6, Gosu::Color::BLACK, :default)
        end
        if @charge > 0 #If the particle has positive charge, draw a + sign
            @@plus.draw_rot(@pos[0], @pos[1], 0, 0, 0.5, 0.5, Math.sqrt(@mass.abs)/4, Math.sqrt(@mass.abs)/4, @sign_color, :add)
        elsif @charge < 0 #If the particle has negative charge, draw a + sign
            @@minus.draw_rot(@pos[0], @pos[1], 0, 0, 0.5, 0.5, Math.sqrt(@mass.abs)/4, Math.sqrt(@mass.abs)/4, @sign_color, :add)
        end
    end
end
