include <helper.scad>
include <face.scad>
use <half_hinge.scad>

module hinge_qualdrant(){
    keep(zMax = -sqrt(2)/2*r + 2*r) diff(){
        at(s/2 - r, s/2 - r) rotate(-45*Z) keep(xMin = 0, yMax = 0) rotate(45*Z) at(r - s/2, r - s/2) face();
        at(s/2 - r, s/2 - r) at(r - s/2, r - s/2) {
            rotate(-45*X) half_hinge_construct(true);
        }
		at(0, 5*r/4) {
			up(-r) box(s, s, r/2 + c);
			up(-r/2 + c) rotate(-135*X) box(s, s, r);
		}
		at(s/2 - r,s/2 - r, -r/2 + c)  cyl(3*r/2 - c, (r + c)/2, .25, invert_bottom = true);
    }
}

hinge_qualdrant();