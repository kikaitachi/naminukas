module roller(
        hole_diameter = 13,
        height = 15,
        min_diameter = 15,
        max_diameter = 15 + 10) {
    difference() {
        union() {
            cylinder(d1 = max_diameter, d2 = min_diameter, h = height / 2, $fn = 100);
            translate([0, 0, height / 2]) {
                cylinder(d1 = min_diameter, d2 = max_diameter, h = height / 2, $fn = 100);
            }
        }
        translate([0, 0, -0.1]) {
            cylinder(d = hole_diameter, h = height + 1, $fn = 100);
        }
    }
}

roller();