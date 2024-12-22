include <helper.scad>
include <face.scad>
use <half_hinge.scad>
use <nonhinge_qualdrant.scad>
use <hinge_qualdrant.scad>

offsets = [[0, -1], [1, 0], [0, 1], [-1, 0]];

function get_neighbor_coords(x, y, width, height) = [for (i = valid_offset_indices(x, y, width, height)) [x, y] + offsets[i]];
    
function valid_offset_indices(x, y, width, height) = [for (i = [0:3]) if ((x + 1 + offsets[i][0])%(width + 1) - 1 >= 0 && (y + 1 + offsets[i][1])%(height + 1) - 1 >= 0) i];

function index_to_coords(i, width) = [i%width, floor(i/width)];

function coords_to_index(coords, width) = width*coords[1] + coords[0];

function decode(encoding, width, height) = [for (i = [0:width*height - 1]) encoding[(height - 1 - floor(i/width))*width + i%width]];
    
function searchable(coords, width) = [for (coord = coords) coords_to_index(coord, width)]; 
    
module flat_dice(encoding, width = width, height = height){
    decoded = decode(encoding, width, height);
    face_coords = [for (i = [0:width*height - 1]) if (decoded[i] == "1") index_to_coords(i, width)];
    for (coord = face_coords) {
        nieghbor_indices = valid_offset_indices(coord[0], coord[1], width, height);
        neighbor_coords = get_neighbor_coords(coord[0], coord[1], width, height);
        found = search(searchable(neighbor_coords, width), searchable(face_coords, width), num_returns_per_match = 4);
        hinge_edges = [for (i = [0:len(found) - 1]) if (found[i] != []) nieghbor_indices[i]];
            
        at(coord[0]*(s - r), coord[1]*(s - r)){
            for (i = hinge_edges){
                at(s/2 - r, s/2 - r) rotate(i*90*Z) at(r - s/2, r - s/2) {
					half_hinge();
					hinge_qualdrant();
                }
            }

            for (j = [0:3]){
                if (search(j, hinge_edges) == []){
                    at(s/2 - r, s/2 - r) rotate(j*90*Z) at(-s/2 + r, -s/2 + r) nonhinge_qualdrant();
                }
            }
        }
        //echo("side_at(", coord, ") the_side(", hinge_edges, ")");
    }
}

module perform_transformation(angle, x, y, came_from_x, came_from_y){
    if ([came_from_x, came_from_y] != [undef, undef]){
        translate(((s - 2*r)/2*(1 + cos(2*angle)) + r*cos(angle))*[x - came_from_x, y - came_from_y, 0]) {
            up((s - 2*r)/2*sin(2*angle) + r*sin(angle)){
                at(s/2 - r, s/2 - r, -sqrt(2)/2*r) rotate(2*angle*[y - came_from_y, -x + came_from_x, 0]) at(r - s/2, r - s/2, sqrt(2)/2*r) {
                    children();
                }
            }
        }
    }
    else{
        children();
    }
}

module perform_inverse_transformation(angle, x, y, came_from_x, came_from_y){
    if ([came_from_x, came_from_y] != [undef, undef]){
        //translate((s - r)*[x - came_from_x, y - came_from_y, 0]) {
            at(s/2 - r, s/2 - r, -sqrt(2)/2*r) rotate(-2*angle*[y - came_from_y, -x + came_from_x, 0]) at(r - s/2, r - s/2, sqrt(2)/2*r) {
                up(-(s - 2*r)/2*sin(2*angle) - r*sin(angle)){
                    translate(-((s - 2*r)/2*(1 + cos(2*angle)) + r*cos(angle))*[x - came_from_x, y - came_from_y, 0]) {
                        children();
                    }
                }
            }
        //}
    }
    else{
        children();
    }
}

module engraving(encoding, width = width, height = height){
    decoded = decode(encoding, width, height);
    face_coords = [for (i = [0:width*height - 1]) if (decoded[i] == "1") index_to_coords(i, width)];
    for (coord = face_coords){
        at(width/2 - coord[0] - 1, coord[1] - height/2, -1) box(1, 1, 2);
    }
}

module corner_engravings(encoding, width = width, height = height){
    at(s/2 - r, s/2 - r, s/2 - r) 
    for (z_angle = [0, 90, 180, 270]) {
        for (x_off = [0, 180]){
            rotate((z_angle + 45)*Z) rotate((90 - atan(1/sqrt(2)) + x_off)*X) up(sphere_r) rotate(15*Z) engraving(encoding, width, height);
        }
    }
}

module engrave_corners(encoding, angle, width, height, x, y, came_from_x, came_from_y, should_engrave){
    if (should_engrave){
        perform_inverse_transformation(45, x, y, came_from_x, came_from_y) diff() {
            perform_transformation(45, x, y, came_from_x, came_from_y){
                //cur hinge
                children(1);
                //cur nonhinge
                children(2);
            }
            // the engraving
            children(0);
        }
        // other faces generated from the recursion are excluded from the diff
        children(3);
    }
    else{
        children();
    }
}

module recursive_flat_dice(encoding, width = width, height = height, angle = 0, x = 1, y = 2, came_from_x = undef, came_from_y = undef, should_engrave = false){
    decoded = decode(encoding, width, height);
    face_coords = [for (i = [0:width*height - 1]) if (decoded[i] == "1") index_to_coords(i, width)];
    nieghbor_indices = valid_offset_indices(x, y, width, height);
    neighbor_coords = get_neighbor_coords(x, y, width, height);
    found = search(searchable(neighbor_coords, width), searchable(face_coords, width), num_returns_per_match = 4);
    hinge_edges = [for (i = [0:len(found) - 1]) if (found[i] != []) nieghbor_indices[i]];
    //engrave_corners(encoding, width, height, x, y, came_from_x, came_from_y)
    perform_transformation($preview ? angle : 0, x, y, came_from_x, came_from_y) engrave_corners(encoding, angle, width, height, x, y, came_from_x, came_from_y, should_engrave) {
        if (should_engrave){
            children(0);
        }
        for (i = hinge_edges){
            at(s/2 - r, s/2 - r) rotate(i*90*Z) at(r - s/2, r - s/2) {
                if ($preview){
                    up(-sqrt(2)/2*r) rotate(-angle*X) up(sqrt(2)/2*r) import("half_hinge.stl");
                    import("hinge_qualdrant.stl");
                }
                else{
//                    half_hinge();
//                    hinge_qualdrant();
                    up(-sqrt(2)/2*r) rotate(-angle*X) up(sqrt(2)/2*r) half_hinge(); //import("half_hinge.stl");
                    hinge_qualdrant();
                }
            }
            
        }
        
        for (j = [0:3]){
            if (search(j, hinge_edges) == []){
                at(s/2 - r, s/2 - r) rotate(j*90*Z) at(-s/2 + r, -s/2 + r) import("nonhinge_qualdrant.stl");//nonhinge_qualdrant(); //import("nonhinge_qualdrant.stl");
            }
        }
        
        for (i = hinge_edges){
            if ([x, y] + offsets[i] != [came_from_x, came_from_y]){
                recursive_flat_dice(encoding, width = width, height = height, angle = angle, x = x + offsets[i][0], y = y + offsets[i][1], came_from_x = x, came_from_y = y) {
                    // pass along reference to untransformed engraving
                    if(should_engrave){
                        perform_inverse_transformation($preview ? angle : 0, x, y, came_from_x, came_from_y) children(0);
                    }
                }
            }
        }
    }
}

module test_engraving(angle, x = 1, y = 2, came_from_x = undef, came_from_y = undef, count = 0){
    if (count < 1){
        perform_transformation(angle, x, y, came_from_x, came_from_y) engrave_corners("
011
010
110
100
        ", width, height, 1, 2, undef, undef){
            at(-r + s/2, -r + s/2, -r + s/2) sphere(sphere_r);
            box(0, 0, 0);
            test_engraving(angle, x = x + 1, y = y, came_from_x = x, came_from_y = y, count = count + 1);
        }
    }
}

module side_at(x, y){
    at(x*(s - r), y*(s - r)) children(0);
}

param1 = "
100
110
010
011
";
encoding = param1;
echo(param1);
param2 = 3;
width = param2;
param3 = 4;
height = param3;
param4 = 0;
x = param4;
param5 = 0;
y = param5;

//side_at(0, 8) flat_dice(encoding, width, height);
//side_at(0, 4) flat_dice(encoding, width, height);
//side_at(6, 8) flat_dice(encoding, width, height);
//side_at(9, 8) flat_dice(encoding, width, height);
//side_at(9, 0) flat_dice(encoding, width, height);
side_at(x, y) flat_dice(encoding, width, height);

//corner_engravings("
//011
//010
//110
//100
//");

//recursive_flat_dice("
//001
//011
//110
//100
//", angle = min($t*60, 45), x = 0, y = 0, came_from_x = 0, came_from_y = 0);

//recursive_flat_dice("
//10
//10
//11
//01
//01
//", angle = min($t*60, 45), width = 2, height = 5, x = 0, y = 4, came_from_x = 0, came_from_y = 4);
