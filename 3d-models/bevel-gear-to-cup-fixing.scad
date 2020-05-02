include <dimensions.scad>

module bevel_gear_to_cup_fixing() {
    difference() {
        cylinder(h = bevel_gear_to_cup_fixing_thickness, r = axle_bottom_diameter / 2, center = false, $fn = 50);
        for (i = [0:5]) {
            rotate([0, 0, 360 * i / 6]) {
                translate([0, -axle_top_diameter / 2 + 2, -0.01]) {
                    cylinder(h = bevel_gear_to_cup_fixing_thickness + 0.02, r = 1.3 / 2, center = false, $fn = 20);
                }
            }
        }
        translate([0, 0, -0.01]) {
            cylinder(h = bevel_gear_to_cup_fixing_thickness + 0.02, r = axle_bottom_diameter / 2 - 5.3, center = false, $fn = 50);
        }
    }
}

bevel_gear_to_cup_fixing();
