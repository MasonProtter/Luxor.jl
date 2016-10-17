#!/usr/bin/env julia

using Luxor
Drawing(1000, 1000, "/tmp/julia-logo-drawing.pdf")

origin()
background("white")

for (pos, n) in Tiler(1000, 1000, 2, 2)
    gsave()
    translate(pos - Point(150, 100))
    if n == 1
        julialogo()
        fill()
    elseif n == 2
        randomhue()
        setline(0.3)
        julialogo(action=:stroke)
    elseif n == 3
        sethue("orange")
        julialogo(color=false)
    elseif n == 4
        julialogo(action=:clip)
        setopacity(0.6)
        for i in 1:400
            randomhue()
            gsave()
            box(Point(rand(0:250), rand(0:250)), 350, 5, :fill)
            grestore()
        end
        clipreset()
    end
    grestore()
end

finish()