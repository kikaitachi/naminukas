include <dimensions.scad>

module tool_holder() {
    difference() {
        union() {
            translate([-tool_magnet_distance_from_center + 8.3, 0, 0]) {
                // Magnet holders
                for (i = [-floor(tool_count / 2):floor(tool_count / 2)]) {
                    rotate([0, 0, i * tool_angle_between_magnets]) {
                        translate([tool_magnet_distance_from_center - tool_wall_thickness, -tool_magnet_width / 2 - tool_wall_thickness, 0]) {
                            cube([tool_magnet_length + 2 * tool_wall_thickness, tool_magnet_width + 2 * tool_wall_thickness, tool_magnet_height]);
                        }
                    }
                }
                // Pin holders
                for (i = [-floor(tool_count / 2):floor(tool_count / 2)]) {
                    rotate([0, 0, i * tool_angle_between_magnets]) {
                        translate([tool_magnet_distance_from_center + tool_wall_thickness * 1.5, tool_magnet_width + tool_wall_thickness / 2, 0]) {
                            cylinder(h = tool_magnet_height, d = tool_pin_diameter + tool_wall_thickness, $fn = 50);
                        }
                        translate([tool_magnet_distance_from_center + tool_magnet_length - tool_wall_thickness - (tool_pin_diameter + tool_wall_thickness), tool_magnet_width + tool_wall_thickness / 2, 0]) {
                            cylinder(h = tool_magnet_height, d = tool_pin_diameter + tool_wall_thickness, $fn = 50);
                        }
                    }
                }
                // Magnet holder connector
                hull() {
                    for (i = [-floor(tool_count / 2):floor(tool_count / 2)]) {
                        rotate([0, 0, i * tool_angle_between_magnets]) {
                            translate([tool_magnet_distance_from_center - tool_wall_thickness / 2, 0, 0]) {
                                cylinder(h = tool_magnet_height, d = tool_wall_thickness, $fn = 25);
                            }
                        }
                    }
                }
            }
            // Connecting plate
            rotate([0, -90 + 20, 0]) {
                translate([0, 0, -tool_connecting_plate_thickness]) {
                    difference() {
                        translate([0, -tool_connecting_plate_width / 2, 0]) {
                            cube([tool_connecting_plate_length, tool_connecting_plate_width, tool_connecting_plate_thickness]);
                        }
                        for (i = [-1:1]) {
                            translate([0, i * 10, 0]) {
                                hull() {
                                    translate([tool_connecting_plate_screw_diameter * 2.3, 0, -0.1]) {
                                        cylinder(h = tool_connecting_plate_thickness + 1, d = tool_connecting_plate_screw_diameter, $fn = 25);
                                    }
                                    translate([tool_connecting_plate_length - tool_connecting_plate_screw_diameter * 1.2, 0, -0.1]) {
                                        cylinder(h = tool_connecting_plate_thickness + 1, d = tool_connecting_plate_screw_diameter, $fn = 25);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        translate([-tool_magnet_distance_from_center + 8.3, 0, 0]) {
            // Magnet holes
            for (i = [-floor(tool_count / 2):floor(tool_count / 2)]) {
                rotate([0, 0, i * tool_angle_between_magnets]) {
                    translate([tool_magnet_distance_from_center, -tool_magnet_width / 2, -0.1]) {
                        cube([tool_magnet_length, tool_magnet_width, tool_magnet_height + 1]);
                    }
                }
            }
            // Pin holdes
            for (i = [-floor(tool_count / 2):floor(tool_count / 2)]) {
                rotate([0, 0, i * tool_angle_between_magnets]) {
                    translate([tool_magnet_distance_from_center + tool_wall_thickness * 1.5, tool_magnet_width + tool_wall_thickness / 2, -0.1]) {
                        cylinder(h = tool_magnet_height + 1, d = tool_pin_diameter, $fn = 50);
                    }
                    translate([tool_magnet_distance_from_center + tool_magnet_length - tool_wall_thickness - (tool_pin_diameter + tool_wall_thickness), tool_magnet_width + tool_wall_thickness / 2, -0.1]) {
                        cylinder(h = tool_magnet_height + 1, d = tool_pin_diameter, $fn = 50);
                    }
                }
            }
        }
        // Cut bottom
        translate([0, 0, -49.99]) {
            cube([100, 100, 100], center = true);
        }
    }
}

tool_holder();
