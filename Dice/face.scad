$fn = 45;
c = .17;
r = 3;
s = 22;
sphere_r = norm([(s - sqrt(2)*r)/2, s/2]);

module face(){
    at(s/2 - r, s/2 - r, s/2 - r) keep(xMin = -s/2, yMin = -s/2, zMin = -s/2, xMax = s/2, yMax = s/2, zMax = -s/2 + 2*r) {
        sphere(sphere_r, $fn = 90);
    }
}