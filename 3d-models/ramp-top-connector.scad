module ramp_top_connector(
        glass_thickness = 5,
        plate_thickness = 1,
        hole_diameter = 12,
        screw_diameter = 3.8) {
    difference() {
        union() {
            cylinder(d = hole_diameter, h = plate_thickness + glass_thickness, $fn = 100);
            cylinder(d = hole_diameter + 6, h = plate_thickness, $fn = 100);
        }
        translate([0, 0, -0.1]) {
            cylinder(d = screw_diameter, h = plate_thickness + glass_thickness + 1, $fn = 100);
        }
    }
}

ramp_top_connector();
