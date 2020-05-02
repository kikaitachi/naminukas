include <rounded-box.scad>
include <teardrop.scad>

module bbb_holder(
        bbb_leg_radius,
        bbb_screw_radius,
        bbb_screw_length,
        bbb_bottom_screw_dist,
        bbb_top_screw_dist,
        bbb_top_bottom_screw_dist) {
    difference() {
        union() {
            // Legs
            translate([- bbb_bottom_screw_dist / 2, 0, 0]) {
                cylinder(r = bbb_leg_radius, h = bbb_screw_length, $fn = 50);
            }
            translate([- bbb_top_screw_dist / 2, - bbb_top_bottom_screw_dist, 0]) {
                cylinder(r = bbb_leg_radius, h = bbb_screw_length, $fn = 50);
            }
            translate([bbb_bottom_screw_dist / 2, 0, 0]) {
                cylinder(r = bbb_leg_radius, h = bbb_screw_length, $fn = 50);
            }
            translate([bbb_top_screw_dist / 2, - bbb_top_bottom_screw_dist, 0]) {
                cylinder(r = bbb_leg_radius, h = bbb_screw_length, $fn = 50);
            }
        }
        // Holes for BBB screws
        translate([- bbb_bottom_screw_dist / 2, 0, -0.5]) {
            cylinder(r = bbb_screw_radius, h = bbb_screw_length + 1, $fn = 50);
        }
        translate([bbb_bottom_screw_dist / 2, 0, -0.5]) {
            cylinder(r = bbb_screw_radius, h = bbb_screw_length + 1, $fn = 50);
        }
        translate([- bbb_top_screw_dist / 2, - bbb_top_bottom_screw_dist, -0.5]) {
            cylinder(r = bbb_screw_radius, h = bbb_screw_length + 1, $fn = 50);
        }
        translate([bbb_top_screw_dist / 2, - bbb_top_bottom_screw_dist, -0.5]) {
            cylinder(r = bbb_screw_radius, h = bbb_screw_length + 1, $fn = 50);
        }
    }
}

module power_and_control_module(
        width = 73,
        length = 100,
        thickness = 2,
        screw_to_body_radius = 3.2 / 2,
        voltage_regulator_width = 15.2,
        voltage_regulator_length = 48.2,
        voltage_regulator_dist_between_screws_width = 10.2,
        voltage_regulator_dist_between_screws_length = 43.2,
        voltage_regulator_screw_radius = 2.2 / 2,
        battery_plug_width = 16.8,
        battery_plug_length = 20.8,
        battery_plug_groove_width = 1.5,
        battery_plug_groove_height = 1.5,
        battery_plug_dist_between_grooves = 6,
        battery_plug_screw_radius = 3.4 / 2,
        u2d2_width = 18,
        u2d2_length = 48,
        u2d2_dist_between_screws = 42,
        u2d2_screw_radius = 2.2 / 2,
        battery_width = 38,
        battery_hole_length = 19,
        switch_hole_radius = 6.5 / 2) {
    difference() {
        union() {
            // BeagleBone Blue mounting legs
            translate([46, 90, 0]) {
                bbb_holder(
                        bbb_leg_radius = 2.5,
                        bbb_screw_radius = 1.4,
                        bbb_screw_length = 22,
                        bbb_bottom_screw_dist = 42,
                        bbb_top_screw_dist = 48,
                        bbb_top_bottom_screw_dist = 66);
            }
            // Base plate
            rounded_box(width, length, thickness, [5, 12, 12, 22]);
            // Hooks for battery holding rubber band
            translate([26.5, 28, thickness / 2]) {
                    rotate([0, 15, 0]) {
                    cylinder(r1 = 1.6, r2 = 0.8, h = 5, $fn = 30);
                }
            }
            translate([26.5, 28 + battery_hole_length, thickness / 2]) {
                    rotate([0, 15, 0]) {
                    cylinder(r1 = 1.6, r2 = 0.8, h = 5, $fn = 30);
                }
            }
            translate([58.5, 28, thickness / 2]) {
                    rotate([0, -15, 0]) {
                    cylinder(r1 = 1.6, r2 = 0.8, h = 5, $fn = 30);
                }
            }
            translate([58.5, 28 + battery_hole_length, thickness / 2]) {
                    rotate([0, -15, 0]) {
                    cylinder(r1 = 1.6, r2 = 0.8, h = 5, $fn = 30);
                }
            }
            // Switch panel
            translate([thickness, u2d2_length + 1, 0]) {
                rotate([0, -90, 0]) {
                    rounded_box(18, 41, thickness, [0.1, 0.1, 5, 5]);
                }
            }
            // Voltage regulator pads
            for (i = [0:1:1]) {
                translate([29 + i * (voltage_regulator_width + 2), 50, 0]) {
                    union() {
                        translate([0, voltage_regulator_length - 5, 0]) {
                            cube([5, 5, thickness + 0.5]);
                        }
                        translate([voltage_regulator_width - 5, 0, 0]) {
                            cube([5, 5, thickness + 0.5]);
                        }
                    }
                }
            }
        }
        // Holes to connect module to robot
        for (i = [-2:1:3]) {
            translate([width - 5, length / 2 + i * 10, -0.5]) {
                cylinder(r = screw_to_body_radius, h = thickness + 1, $fn = 30);
            }
        }
        // Voltage regulators
        for (i = [0:1:1]) {
            translate([29 + i * (voltage_regulator_width + 2), 50, 0]) {
                union() {
                    difference() {
                        // Sunken area
                        translate([0, 0, 1]) {
                            cube([voltage_regulator_width, voltage_regulator_length, thickness]);
                        }
                        // Screw pads
                        translate([0, voltage_regulator_length - 5, 0]) {
                            cube([5, 5, thickness + 1]);
                        }
                        translate([voltage_regulator_width - 5, 0, 0]) {
                            cube([5, 5, thickness + 1]);
                        }
                    }
                    // Screws
                    translate([(voltage_regulator_width - voltage_regulator_dist_between_screws_width) / 2, voltage_regulator_length - (voltage_regulator_length - voltage_regulator_dist_between_screws_length) / 2, -0.5]) {
                        cylinder(r = voltage_regulator_screw_radius, h = thickness + 2, $fn = 30);
                    }
                    translate([voltage_regulator_width - (voltage_regulator_width - voltage_regulator_dist_between_screws_width) / 2, (voltage_regulator_length - voltage_regulator_dist_between_screws_length) / 2, -0.5]) {
                        cylinder(r = voltage_regulator_screw_radius, h = thickness + 2, $fn = 30);
                    }
                }
            }
        }
        // Battery plug
        translate([36, 0, 0]) {
            translate([-battery_plug_groove_width / 2, 1, thickness - battery_plug_groove_height]) {
                cube([battery_plug_groove_width, battery_plug_length - 3, thickness]);
            }
            translate([-battery_plug_groove_width / 2 + battery_plug_dist_between_grooves, 1, thickness - battery_plug_groove_height]) {
                cube([battery_plug_groove_width, battery_plug_length - 3, thickness]);
            }
            translate([battery_plug_width - battery_plug_groove_width / 2, 1, thickness - battery_plug_groove_height]) {
                cube([battery_plug_groove_width, battery_plug_length - 3, thickness]);
            }
            translate([battery_plug_width - battery_plug_groove_width / 2 - battery_plug_dist_between_grooves, 1, thickness - battery_plug_groove_height]) {
                cube([battery_plug_groove_width, battery_plug_length - 3, thickness]);
            }
            translate([battery_plug_width / 2, battery_plug_length / 2, -0.5]) {
                cylinder(r = battery_plug_screw_radius, h = thickness + 1, $fn = 30);
            }
        }
        // U2D2
        translate([-0.01, -0.01, thickness - 0.75]) {
            cube([u2d2_width + 0.5, u2d2_length + 0.5, thickness]);
        }
        translate([u2d2_width / 2, (u2d2_length - u2d2_dist_between_screws) / 2, -0.5]) {
            cylinder(r = u2d2_screw_radius, h = thickness + 1, $fn = 30);
        }
        translate([u2d2_width / 2, u2d2_length - (u2d2_length - u2d2_dist_between_screws) / 2, -0.5]) {
            cylinder(r = u2d2_screw_radius, h = thickness + 1, $fn = 30);
        }
        // Battery strap holes
        translate([22, 28, -0.5]) {
            cube([3, battery_hole_length, thickness + 1]);
        }
        translate([22 + battery_width, 28, -0.5]) {
            cube([3, battery_hole_length, thickness + 1]);
        }
        // Switch holes
        translate([thickness / 2, 61, 9]) {
            rotate([0, 0, 90]) {
                teardrop(radius = switch_hole_radius, length = thickness + 1);
            }
        }
        translate([thickness / 2, 79, 9]) {
            rotate([0, 0, 90]) {
                teardrop(radius = switch_hole_radius, length = thickness + 1);
            }
        }
    }
}

power_and_control_module();
