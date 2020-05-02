include <dimensions.scad>
use <PolyGear/PolyGear.scad>

module side_bevel_gear() {
    difference() {
        translate([0, 0, 2.3]) {
            bevel_pair(
                m = 3,
                w = 5,
                n1 = 12,
                n2 = 12,
                only = 1,
                axis_angle = 90,
                helix_angle = zerol(0),
                backlash = bevel_gear_backlash,
                $fn = 50);
        }
        translate([0, 0, 1.2]) {
            cylinder(h = 3, r1 = 21 / 2, r2 = 24 / 2, center = false, $fn = 100);
        }
        // Servo horn center hole
        translate([0, 0, -0.1]) {
            cylinder(h = 4, r = 9 / 2, center = false, $fn = 50);
        }
        // Servo horn screw holes
        for (i = [0:7]) {
            rotate([0, 0, i * (360 / 8)]) {
                translate([0, 16 / 2, -0.1]) {
                    cylinder(h = 4, r = 1.1, center = false, $fn = 24);
                }
            }
        }
    }
}

side_bevel_gear();
