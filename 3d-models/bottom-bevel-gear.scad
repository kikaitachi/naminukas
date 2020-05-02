include <dimensions.scad>
use <PolyGear/PolyGear.scad>

module bottom_bevel_gear() {
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
        difference() {
            translate([0, 0, -0.2]) {
                cylinder(h = 5, d = 20, center = false, $fn = 100);
            }
            for (i = [0:5]) {
                rotate([0, 0, i * 60]) {
                    translate([0, 10, -0.2]) {
                        cylinder(h = 5, r = 0.8, center = false, $fn = 30);
                    }
                }
            }
        }
    }
}

bottom_bevel_gear();
