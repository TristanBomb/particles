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
        @sign_color.alpha = 255*(1-(0.7)**(@charge/@mass).abs)
        @@image.draw_rot(@pos[0], @pos[1], 0, 0, 0.5, 0.5, Math.sqrt(@mass.abs)/4, Math.sqrt(@mass.abs)/4, @color, :add)
        if @mass < 0
            @@image.draw_rot(@pos[0], @pos[1], 0, 0, 0.5, 0.5, Math.sqrt(@mass.abs)/8, Math.sqrt(@mass.abs)/8, Gosu::Color::BLACK, :default)
        end
        if @charge > 0
            @@plus.draw_rot(@pos[0], @pos[1], 0, 0, 0.5, 0.5, Math.sqrt(@mass.abs)/4, Math.sqrt(@mass.abs)/4, @sign_color, :add)
        elsif @charge < 0
            @@minus.draw_rot(@pos[0], @pos[1], 0, 0, 0.5, 0.5, Math.sqrt(@mass.abs)/4, Math.sqrt(@mass.abs)/4, @sign_color, :add)
        end
    end
end
