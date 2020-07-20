module ramp_side_connector(
        glass_thickness = 5,
        plate_thickness = 1,
        hole_diameter = 11,
        dist_x = 8.5 + 12 / 2) {
    union() {
        translate([-dist_x, 0, 0]) {
            cylinder(d = hole_diameter, h = plate_thickness + glass_thickness, $fn = 100);
        }
        translate([dist_x, 0, 0]) {
            cylinder(d = hole_diameter, h = plate_thickness + glass_thickness, $fn = 100);
        }
        hull() {
            translate([-dist_x, 0, 0]) {
                cylinder(d = hole_diameter, h = plate_thickness, $fn = 100);
            }
            translate([dist_x, 0, 0]) {
                cylinder(d = hole_diameter, h = plate_thickness, $fn = 100);
            }
        }
    }
}

ramp_side_connector();