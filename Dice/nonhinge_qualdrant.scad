include <helper.scad>
include <face.scad>

u = (sqrt(2)*(sqrt(3) - 1))/4*r;
echo(u);

module non_hinge(){
    rotate(45*Y) at(-u - 2*r - c, -r, -r - 1) box(2*r + c, s + c, 3*r);
    //adjust c's doesn't have to be as wide and needs to be taller to fix droop
    at(0, 0, -2*c) rotate(45*Y) at(u - 2*r, -r + s/2 - r, -r + 4*u) box(2*r, r/2 - c, 2*r); 
    at(-sqrt(2)/2*(r - 5*u) - r, -r + s/2 - r, -sqrt(2)/2*(r - 3*u) - 2*c) box(r, r/2 - c, 2*r); 
    at((s - r)/2, (s - r)/2) rotate(90*Z) at(-(s - r)/2, -(s - r)/2) at(-r, -r + s/2 + r, -r) rotate(-45*Y) box(4*r, s/2 - r/2, 3*r);		
	
    intersection(){
        at(s/2 - r, s/2 - r, -r) rotate(135*Z) box(s, s, 2*r);
        rotate(45*Y) at(u - 2*r, -r + s/2 + r, -r - 1) box(2*r, s/2 - r/2, 3*r); 
    }
    rotate(45*Y) at(u - 2*r, -r + s/2 - .001, -r - 1) box(2*r, r/2, 3*r); 
	
    rotate(45*Y) at(u - 2*r, -r + s/2 + r/2, -r - 1) box(2*r, r, 2*u + 1); 
    at(-sqrt(2)/2*(r - 3*u) - r, -r + s/2 + r/2, -sqrt(2)/2*(r - u)) box(r, r, 2*r); 
}

module non_hinge9(){
    u = (sqrt(2)*(sqrt(3) - 1))/4*r;
    
    rotate(45*Y) at(-u - r - c, -r, -r - 1) box(r + c, s + c, 3*r);
    //adjust c's doesn't have to be as wide and needs to be taller to fix droop
    at(-2*c, 0, -2*c) rotate(45*Y) at(u - 2*r, -r + s/2 - r - c/2, -r + 4*u) box(2*r, r/2 + c, 2*r); 
    at(-sqrt(2)/2*(r - 5*u) - r - 2*c, -r + s/2 - r - c/2, -sqrt(2)/2*(r - 3*u) - 2*c) box(r, r/2 + c, 2*r); 
    
    intersection(){
        at(s/2 - r, s/2 - r, -r) rotate(135*Z) box(s, s, 2*r);
        //at(-r, s/2 - r, s/2 - r) rotate(-135*X) box(2*r, s, s);
        rotate(45*Y) at(u - 2*r, -r + s/2 + r, -r - 1) box(2*r, s/2 - r/2, 3*r); 
    }
    at((s - r)/2, (s - r)/2) rotate(90*Z) at(-(s - r)/2, -(s - r)/2) at(-r, -r + s/2 + r, -r) rotate(-45*Y) box(4*r, s/2 - r/2, 3*r);
    
    rotate(45*Y) at(u - 2*r, -r + s/2 - c/2, -r - 1) box(2*r, r/2 + c/2, 3*r); 
    rotate(45*Y) at(u - 2*r, -r + s/2 + r/2, -r - 1) box(2*r, r/2 + c, 2*u + 1); 
    at(-sqrt(2)/2*(r - 3*u) - r, -r + s/2 + r/2, -sqrt(2)/2*(r - u)) box(r, r/2 + c, 2*r); 
}

module non_hinge_inner(include_curve = true){
    rotate(45*Y) at(-u - 2*r - c, -r, -r - 1) box(2*r + c, s + c, 3*r);
    //adjust c's doesn't have to be as wide and needs to be taller to fix droop
    at(-2*c, 0, -2*c) rotate(45*Y) at(u - 2*r, -r + s/2 - r - c/2, -r + 4*u) box(2*r, r/2 + c, 2*r); 
    at(-sqrt(2)/2*(r - 5*u) - r - 2*c, -r + s/2 - r - c/2, -sqrt(2)/2*(r - 3*u) - 2*c) box(r, r/2 + c, 2*r); 
    at((s - r)/2, (s - r)/2) rotate(90*Z) at(-(s - r)/2, -(s - r)/2) at(-r, -r + s/2 + r, -r) rotate(-45*Y) box(4*r, s/2 - r/2, 3*r);		
	
	if (include_curve){
		rotate(45*Y) at(0, s/2 - r, -2*r) rotate(90*Z) linear_extrude(4*r) polygon(points=
		[
			for (i = [-s/2*10:s/2*10]) [-i/10, u*atan(i/10)/90],
			[s/2, 1],
		]);
	}
}

module non_hinge2(){
	diff(){
		non_hinge_inner();
		rotate(45*Y) at(0, s/2 - r) rotate(180*Z) at(0, -s/2 + r) rotate(-45*Y) non_hinge_inner(false);
	}
}

//non_hinge();

module nonhinge_qualdrant(){
    keep(zMax = -sqrt(2)/2*r + 2*r) diff(){
        at(s/2 - r, s/2 - r) rotate(-45*Z) keep(xMin = 0, yMax = 0) rotate(45*Z) at(r - s/2, r - s/2) face();
        at(s/2 - r, s/2 - r) rotate(90*Z) at(-s/2 + r, -s/2 + r) non_hinge();
		at(0, 5*r/4) {
			up(-r) box(s, s, r/2 + c);
			up(-r/2 + c) rotate(-135*X) box(s, s, r);
		}
		at(s/2 - r,s/2 - r, -r/2 + c)  cyl(3*r/2 - c, (r + c)/2, .25, invert_bottom = true);
	}
}

echo(s/2 - 9*r/4);
//at(7*r/4, 5*r/4) {
//			up(-r) box(s/2 - 9*r/4, s/2 - 9*r/4, r/2);
//			//up(-r/2) rotate(-135*X) box(s, s, r);
//		}
//intersection()
{
	nonhinge_qualdrant();
	at(s - 2*r, -r) rotate(180*Z) nonhinge_qualdrant();
}
//rotate(-90*X) at(s - 2*r) rotate(180*Z) nonhinge_qualdrant();
