module led_holder(
        thickness = 2,
        length = 30,
        screw_diameter = 3.2,
        led_board_thickness = 1.6,
        led_board_diameter = 15.3,
        diameter_fraction = 0.4) {
    difference() {
        union() {
            // Base
            rotate([0, 90, 0]) {
                cylinder(d = led_board_diameter + thickness, h = length, center = false, $fn = 200);
            }
        }
        // Main hole
        translate([thickness, 0, 0]) {
            rotate([0, 90, 0]) {
                cylinder(d = led_board_diameter - thickness / 2, h = length, center = false, $fn = 200);
            }
        }
        // Screw hole
        translate([-thickness, 0, 0]) {
            rotate([0, 90, 0]) {
                cylinder(d = screw_diameter, h = thickness * 3, center = false, $fn = 100);
            }
        }
        // Cut off end
        translate([30, 0, 50]) {
            rotate([0, 45, 0]) {
                cube([100, 100, 100], center = true);
            }
        }
        // Cut off top
        translate([0, 0, 50 + led_board_diameter * diameter_fraction / 2]) {
            cube([100, 100, 100], center = true);
        }
        // Cut off bottom
        translate([0, 0, -50 - led_board_diameter * diameter_fraction / 2]) {
            cube([100, 100, 100], center = true);
        }
        // Board hole
        translate([6.5, 0, 0]) {
            rotate([0, 45, 0]) {
                #cylinder(d = led_board_diameter, h = led_board_thickness, center = false, $fn = 200);
            }
        }
    }
}

led_holder();
