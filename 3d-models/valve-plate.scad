module valve_plate(
        thickness = 2,
        valve_height = 17.8,
        dist_between_connector_crews = 16,
        dist_between_valve_crews = 16,
        dist_between_valve_crew_and_servo = 52,
        dist_between_valve_crew_and_connector_screw = 41,
        penumatic_screw_radius = 1.5,
        generic_screw_radius = 1.5,
        servo_bracket_length = 48.16,
        servo_heigth = 15,
        servo_length = 35,
        servo_screw_radius = 2.1,
        servo_horizontal_dist_between_screws = 41.96,
        servo_vertical_dist_between_screws = 7.43,
        servo_to_axle_center = 8.3) {
    servo_bracket_heigth = valve_height / 2 + servo_heigth / 2;
    difference() {
        union() {
            // Servo backet
            cube(size = [servo_bracket_length, thickness, servo_bracket_heigth + thickness], center = false);
            cube(size = [servo_bracket_length, 5, thickness], center = false);
            // Servo bracket to pneumatic parts
            translate([3.39, 0, 0]) {
                cube(size = [6, 52.5, thickness], center = false);
            }
            translate([42.15, 0, 0]) {
                cube(size = [6, 52.5, thickness], center = false);
            }
            // Valve to connector plate
            hull() {
                translate([servo_to_axle_center + (servo_bracket_length - servo_length) / 2 - dist_between_valve_crews / 2, dist_between_valve_crew_and_servo, 0]) {
                    cylinder(h = thickness, r = penumatic_screw_radius + thickness, center = false, $fn = 100);
                }
                translate([servo_to_axle_center + (servo_bracket_length - servo_length) / 2 - dist_between_valve_crews / 2 + dist_between_valve_crew_and_connector_screw, dist_between_valve_crew_and_servo, 0]) {
                    cylinder(h = thickness, r = penumatic_screw_radius + thickness, center = false, $fn = 100);
                }
            }
            // Connector plate
            hull() {
                translate([servo_to_axle_center + (servo_bracket_length - servo_length) / 2 - dist_between_valve_crews / 2 + dist_between_valve_crew_and_connector_screw, dist_between_valve_crew_and_servo, 0]) {
                    cylinder(h = thickness, r = penumatic_screw_radius + thickness, center = false, $fn = 100);
                }
                translate([servo_to_axle_center + (servo_bracket_length - servo_length) / 2 - dist_between_valve_crews / 2 + dist_between_valve_crew_and_connector_screw, dist_between_valve_crew_and_servo - dist_between_connector_crews, 0]) {
                    cylinder(h = thickness, r = penumatic_screw_radius + thickness, center = false, $fn = 100);
                }
            }
        }
        // Servo hole
        translate([(servo_bracket_length - servo_length ) / 2, -0.1, thickness]) {
            cube(size = [servo_length, thickness + 0.2, servo_bracket_heigth + thickness], center = false);
        }
        // Servo screw holes
        translate([(servo_bracket_length - servo_horizontal_dist_between_screws) / 2, thickness + 0.1, thickness + valve_height / 2 + servo_heigth / 2 - (servo_heigth - servo_vertical_dist_between_screws) / 2]) {
            rotate([90, 0, 0]) {
                cylinder(h = thickness + 0.2, r = servo_screw_radius, center = false, $fn = 100);
            }
        }
        translate([(servo_bracket_length - servo_horizontal_dist_between_screws) / 2, thickness + 0.1, thickness + valve_height / 2 + servo_heigth / 2 - (servo_heigth - servo_vertical_dist_between_screws) / 2 - servo_vertical_dist_between_screws]) {
            rotate([90, 0, 0]) {
                cylinder(h = thickness + 0.2, r = servo_screw_radius, center = false, $fn = 100);
            }
        }
        translate([servo_bracket_length - (servo_bracket_length - servo_horizontal_dist_between_screws) / 2, thickness + 0.1, thickness + valve_height / 2 + servo_heigth / 2 - (servo_heigth - servo_vertical_dist_between_screws) / 2]) {
            rotate([90, 0, 0]) {
                cylinder(h = thickness + 0.2, r = servo_screw_radius, center = false, $fn = 100);
            }
        }
        translate([servo_bracket_length - (servo_bracket_length - servo_horizontal_dist_between_screws) / 2, thickness + 0.1, thickness + valve_height / 2 + servo_heigth / 2 - (servo_heigth - servo_vertical_dist_between_screws) / 2 - servo_vertical_dist_between_screws]) {
            rotate([90, 0, 0]) {
                cylinder(h = thickness + 0.2, r = servo_screw_radius, center = false, $fn = 100);
            }
        }
        // Valve screws
        translate([servo_to_axle_center + (servo_bracket_length - servo_length) / 2 - dist_between_valve_crews / 2, dist_between_valve_crew_and_servo, -0.1]) {
            cylinder(h = thickness + 0.2, r = penumatic_screw_radius, center = false, $fn = 100);
        }
        translate([servo_to_axle_center + (servo_bracket_length - servo_length) / 2 + dist_between_valve_crews / 2, dist_between_valve_crew_and_servo, -0.1]) {
            cylinder(h = thickness + 0.2, r = penumatic_screw_radius, center = false, $fn = 100);
        }
        // Connector screws
        translate([servo_to_axle_center + (servo_bracket_length - servo_length) / 2 - dist_between_valve_crews / 2 + dist_between_valve_crew_and_connector_screw, dist_between_valve_crew_and_servo, -0.1]) {
            cylinder(h = thickness + 0.2, r = penumatic_screw_radius, center = false, $fn = 100);
        }
        translate([servo_to_axle_center + (servo_bracket_length - servo_length) / 2 - dist_between_valve_crews / 2 + dist_between_valve_crew_and_connector_screw, dist_between_valve_crew_and_servo - dist_between_connector_crews, -0.1]) {
            cylinder(h = thickness + 0.2, r = penumatic_screw_radius, center = false, $fn = 100);
        }
        // Servo bracket to pneumatic parts screws
        for (i = [1:4]) {
            translate([3.39 + 3, i * 10, -0.1]) {
                cylinder(h = thickness + 0.2, r = generic_screw_radius, center = false, $fn = 100);
            }
        }
        for (i = [1:3]) {
            translate([42.15 + 3, i * 10, -0.1]) {
                cylinder(h = thickness + 0.2, r = generic_screw_radius, center = false, $fn = 100);
            }
        }
    }
}

valve_plate();
