include <dimensions.scad>
use <threadlib/threadlib.scad>

module suction_cup_connector() {
    difference() {
        union() {
            difference() {
                union() {
                    // Axle
                    cylinder(h = axle_top_height + axle_bottom_height, r = axle_top_diameter / 2, center = false, $fn = 100);
                    cylinder(h = axle_bottom_height, r = axle_bottom_diameter / 2, center = false, $fn = 100);
                    // Bottom plate
                    cylinder(h = bottom_plate_height, r = 72 / 2, center = false, $fn = 200);
                    // Rim
                    difference() {
                        cylinder(h = bottom_plate_height + rim_height, r = rim_diameter / 2, center = false, $fn = 200);
                        translate([0, 0, 0.1]) {
                            cylinder(h = bottom_plate_height + rim_height, r = (rim_diameter - rim_thickness * 2) / 2, center = false, $fn = 200);
                        }
                    }
                    // Wheel fixing pillars
                    for (i = [0:5]) {
                        rotate([0, 0, 360 * i / 6]) {
                            translate([0, -rim_diameter / 2 + wheel_screw_diameter / 2 + rim_thickness, 0]) {
                                cylinder(h = bottom_plate_height + rim_height, r = wheel_screw_diameter / 2 + rim_thickness, center = false, $fn = 32);
                            }
                        }
                    }
                }
                translate([0, 0, -0.1]) {
                    cylinder(h = axle_bottom_height + axle_top_height + 1, r = axle_hole_diameter / 2, center = false, $fn = 50);
                }
            }
            translate([0, 0, 0.4535]) {
                nut("G1/8", turns = 25.02 + 6.61, Douter = 16);
            }
        }
        // Bearing fixing screw holes
        for (i = [0:5]) {
            rotate([0, 0, 360 * i / 6]) {
                translate([0, -axle_top_diameter / 2 + 2, axle_bottom_height + 0.01]) {
                    cylinder(h = axle_bottom_height, r = 1.3 / 2, center = false, $fn = 20);
                }
            }
        }
        // Bevel gear fixing ridges
        for (i = [0:5]) {
            rotate([0, 0, i * 60 + 30]) {
                translate([0, 10, axle_bottom_height + 0.01]) {
                    cylinder(h = axle_top_height, r = 1, center = false, $fn = 30);
                }
            }
        }
        // Wheel fixing holes
        for (i = [0:5]) {
            rotate([0, 0, 360 * i / 6]) {
                translate([0, -rim_diameter / 2 + wheel_screw_diameter / 2 + rim_thickness, bottom_plate_height]) {
                    cylinder(h = bottom_plate_height + rim_height, r = wheel_screw_diameter / 2, center = false, $fn = 32);
                }
            }
        }
    }
}

suction_cup_connector();
