include <helper.scad>
include <face.scad>

module half_hinge_construct(negative = false){
    hinge_r = (1 - sqrt(2)/2)*r - c;
    c_shrinks = (negative ? 0 : c);//shrinks to leave more with face
    c_grows = (negative ? c : 0);//grows to subtract more from face
    x1 = 31/16*r - hinge_r - c;//start
    x2 = x1 + 4*hinge_r + 5*c;
    x3 = s - 2*r - x1;//end
    x4 = s - 2*r - x2;
	
//	if (!negative){
//		at(x1 + hinge_r + 2*c_shrinks, 0, (sqrt(2) + 1)/2*r - .25) box(x4 - (x1 + hinge_r + 2*c_shrinks), s/3, .25);
//		at(x2, 0, (sqrt(2) + 1)/2*r - .25) box(2*hinge_r, s/3, .25);
//	}
    union(){
        keep(yMin = 0) diff(){
            intersection(){
                union(){
                    keep(zMax = r/2) rotate(90*Y) up(-r) cyl(s, r + c/2 + c_grows);
                    box(s - 2*r, r + c/2 + c_grows, 3*r/2);
                    ////rotate(90*Y) up(x1 - hinge_r - c_grows) cyl(x3 - x1 + 2*hinge_r + 2*c_grows, r + c/2 + c_grows);
                    //at(x1 - hinge_r - c_grows) box(x3 - x1 + 2*hinge_r + 2*c_grows, r + c/2 + c_grows, r/2);
                }
                //keep(zMax = r/2) rotate(90*Y) up(-r) cyl(s, r + c/2 + c_grows);
                if (!negative) {
                    at(s/2 - r, s/2 - r + r/2 - c, -2*r) rotate(-135*Z) box(sqrt(2)*s, sqrt(2)*s, 4*r);
                }
                rotate(45*X) at(s/2 - r, s/2 - r + sqrt(2)*c_grows, -2*r) rotate(-135*Z) box(sqrt(2)*s, sqrt(2)*s, 4*r);
                at(s/2 - r, 0, sqrt(2)/2*s - sqrt(2)*r) rotate(-45*X) sphere(sphere_r + 2*c_grows, $fn = 90);
            }
            at(0, r/2, -r/2){//centered at hinge center
                
                at(x1 + c_grows) {
                    at(0, -hinge_r - c_shrinks) box(hinge_r + 2*c_shrinks, r, 2*r);
                    if (!negative){
                        at(0, 0, -hinge_r) box(hinge_r + 2*c_shrinks, r, 2*r);
                    }
                    else{
                        at(0, sqrt(2)/2*hinge_r, -sqrt(2)/2*hinge_r) rotate(45*X) box(hinge_r + 2*c_shrinks, hinge_r, hinge_r);
                    }
                }
                at(x2 - hinge_r - 2*c + c_grows) {
                    at(0, -hinge_r - c_shrinks) box(hinge_r + 2*c_shrinks, r, 2*r);
                    if (!negative){
                        at(0, 0, -hinge_r) box(hinge_r + 2*c_shrinks, r, 2*r);
                    }
                    else{
                        at(0, sqrt(2)/2*hinge_r, -sqrt(2)/2*hinge_r) rotate(45*X) box(hinge_r + 2*c_shrinks, hinge_r, hinge_r);
                    }
                }
                at(x3 - hinge_r - 2*c + c_grows) {
                    at(0, -hinge_r - c_shrinks) box(hinge_r + 2*c_shrinks, r, 2*r);
                    if (!negative){
                        at(0, 0, -hinge_r) box(hinge_r + 2*c_shrinks, r, 2*r);
                    }
                    else{
                        at(0, sqrt(2)/2*hinge_r, -sqrt(2)/2*hinge_r) rotate(45*X) box(hinge_r + 2*c_shrinks, hinge_r, hinge_r);
                    }
                }
                at(x4 + c_grows) {
                    at(0, -hinge_r - c_shrinks) box(hinge_r + 2*c_shrinks, r, 2*r);
                    if (!negative){
                        at(0, 0, -hinge_r) box(hinge_r + 2*c_shrinks, r, 2*r);
                    }
                    else{
                        at(0, sqrt(2)/2*hinge_r, -sqrt(2)/2*hinge_r) rotate(45*X) box(hinge_r + 2*c_shrinks, hinge_r, hinge_r);
                    }
                }
                
                at(x1){
                        at(c_grows) rotate(90*Y) cyl(hinge_r, hinge_r + c_shrinks, $fn = 20);
                        at(hinge_r + c) sphere(hinge_r + c_shrinks, $fn = 20);
                }
                at(x2){
                        //at(-c - c_grows) rotate(90*Y) cyl(hinge_r + c, hinge_r + c_shrinks);
                        at(-hinge_r - c) sphere(hinge_r + c_shrinks, $fn = 20);
                }
                at(x3){
                        at(-c_grows - hinge_r) rotate(90*Y) cyl(hinge_r, hinge_r + c_shrinks, $fn = 20);
                        at(-hinge_r - c) sphere(hinge_r + c_shrinks, $fn = 20);
                }
                at(x4){
                        //at(c_grows - hinge_r) rotate(90*Y) cyl(hinge_r + c, hinge_r + c_shrinks);
                        at(hinge_r + c) sphere(hinge_r + c_shrinks, $fn = 20);
                }
            }
        }
        
        if (negative){
            at(-r, -2*r, -2*r) box(s, 2*r, 4*r);
            //at(x1 - hinge_r - c_grows, -2*r, -2*r) box(x3 - x1 + 2*hinge_r + 2*c_grows, 2*r, 4*r);
        }
    }
}

module half_hinge(){
	keep(zMax = r) up(-sqrt(2)/2*r) rotate(45*X) up(sqrt(2)/2*r) rotate(-45*X)
	half_hinge_construct(false);
}

half_hinge();