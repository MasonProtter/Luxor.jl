# More examples

A good place to look for examples (sometimes not very exciting or well-written examples, I'll admit), is in the `Luxor/test` directory.

!["tiled images"](figures/tiled-images.png)

## An early test

![Luxor test](figures/basic-test.png)

```julia
using Luxor, Colors
Drawing(1200, 1400, "basic-test.png") # or PDF/SVG filename for PDF or SVG

origin()
background("purple")

setopacity(0.7)                      # opacity from 0 to 1
sethue(0.3,0.7,0.9)                  # sethue sets the color but doesn't change the opacity
setline(20)                          # line width

rect(-400,-400,800,800, :fill)       # or :stroke, :fillstroke, :clip
randomhue()
circle(0, 0, 460, :stroke)
circle(0,-200,400,:clip)             # a circular clipping mask above the x axis
sethue("gold")
setopacity(0.7)
setline(10)
for i in 0:pi/36:2pi - pi/36
  move(0, 0)
  line(cos(i) * 600, sin(i) * 600 )
  stroke()
end
clipreset()                           # finish clipping/masking
fontsize(60)
setcolor("turquoise")
fontface("Optima-ExtraBlack")
textwidth = textextents("Luxor")[5]
textcentred("Luxor", 0, currentdrawing.height/2 - 400)
fontsize(18)
fontface("Avenir-Black")

# text on curve starting at angle 0 rads centered on origin with radius 550
textcurve("THIS IS TEXT ON A CURVE " ^ 14, 0, 550, Point(0, 0))
finish()
preview() # on macOS, opens in Preview
```

## Sierpinski triangle

The main type is the Point, an immutable composite type containing `x` and `y` fields.

![Sierpinski](figures/sierpinski.png)

```julia
using Luxor, Colors

function triangle(points::Array{Point}, degree::Int64)
    global counter, cols
    setcolor(cols[degree+1])
    poly(points, :fill)
    counter += 1
end

function sierpinski(points::Array{Point}, degree::Int64)
    triangle(points, degree)
    if degree > 0
        p1, p2, p3 = points
        sierpinski([p1, midpoint(p1, p2),
                        midpoint(p1, p3)], degree-1)
        sierpinski([p2, midpoint(p1, p2),
                        midpoint(p2, p3)], degree-1)
        sierpinski([p3, midpoint(p3, p2),
                        midpoint(p1, p3)], degree-1)
    end
end

@time begin
    depth = 8 # 12 is ok, 20 is right out
    cols = distinguishable_colors(depth + 1)
    Drawing(400, 400, "/tmp/sierpinski.svg")
    origin()
    setopacity(0.5)
    counter = 0
    my_points = [Point(-100, -50), Point(0, 100), Point(100.0, -50.0)]
    sierpinski(my_points, depth)
    println("drew $counter triangles")
end

finish()
preview()

# drew 9841 triangles
# elapsed time: 1.738649452 seconds (118966484 bytes allocated, 2.20% gc time)
```

## Luxor logo

In this example, the color scheme is mirrored so that the lighter colors are at the top of the circle.

![logo](figures/logo.png)

```
using Luxor, Colors, ColorSchemes

width = 225  # pts
height = 225 # pts
Drawing(width, height, "/tmp/logo.png")

function spiral(colscheme)
  circle(0, 0, 90, :clip)
  for theta in pi/2 - pi/8:pi/8: (19 * pi)/8 # start at the bottom
    sethue(colorscheme(colscheme, rescale(theta, pi/2, (19 * pi)/8, 0, 1)))
    gsave()
    rotate(theta)
    move(5,0)
    curve(Point(40, 40), Point(50, -40), Point(80, 30))
    closepath()
    fill()
    grestore()
  end
  clipreset()
end

origin()
background("white")
scale(1.3, 1.3)
colscheme = loadcolorscheme("solarcolors")
colschememirror = vcat(colscheme, reverse(colscheme))
spiral(colschememirror)
finish()
preview()
```