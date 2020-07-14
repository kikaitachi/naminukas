module valve_to_servo_connector(
        thickness = 2,
        large_screw_radius = 1.6,
        small_screw_radius = 1,
        large_screw_to_last_small_screw = 16.2,
        small_screw_to_small_screw = 3,
        small_screw_count = 4,
        valve_length = 15.5,
        valve_height = 9,
        valve_gap = 5.1) {
    difference() {
        union() {
            // Servo arm
            translate([0, 0, thickness / 2]) {
                cube(size = [valve_length + 10, valve_gap + thickness, thickness], center = true);
            }
            // Valve holder
            translate([0, (valve_gap + thickness) / 2, valve_height / 2]) {
                cube(size = [valve_length + 10, thickness, valve_height], center = true);
            }
            translate([0, -(valve_gap + thickness) / 2, valve_height / 2]) {
                cube(size = [valve_length + 10, thickness, valve_height], center = true);
            }
        }
        // Large screw head hole
        translate([0, 0, -0.1]) {
            cylinder(h = 20, r = 3, center = false, $fn = 100);
        }
        // Servo arm holes
        translate([11.9 / 2, 0, -0.1]) {
            cylinder(h = thickness + 0.2, r = small_screw_radius, center = false, $fn = 100);
        }
        translate([-11.9 / 2, 0, -0.1]) {
            cylinder(h = thickness + 0.2, r = small_screw_radius, center = false, $fn = 100);
        }
        // Servo arm holes for screw heads
        translate([11.9 / 2, 0, thickness - 0.2]) {
            cylinder(h = thickness + 0.2, r = 2, center = false, $fn = 100);
        }
        translate([-11.9 / 2, 0, thickness - 0.2]) {
            cylinder(h = thickness + 0.2, r = 2, center = false, $fn = 100);
        }
    }
}

difference() {
    valve_to_servo_connector();
    difference() {
        cylinder(h = 20, r = 20, center = true, $fn = 10);
        cylinder(h = 21, r = 16.5 / 2, center = true, $fn = 100);
    }
}
