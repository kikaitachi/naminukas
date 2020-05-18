include <dimensions.scad>

module rail() {
    difference() {
        translate([0, -tool_magnet_width / 2 - tool_wall_thickness, 0]) {
            difference() {
                cube([tool_wall_thickness * 2, tool_magnet_width + 2 * tool_wall_thickness, tool_magnet_height * 1.5]);
                translate([2 * tool_wall_thickness, tool_magnet_width / 2 + tool_wall_thickness, tool_magnet_height * 1.25 + 0.3]) {
                    rotate([90, 0, 0]) {
                        cylinder(h = tool_magnet_width + 2 * tool_wall_thickness + 1, d = tool_magnet_height / 2 + 0.2, center = true, $fn = 4);
                    }
                }
            }
        }
        // Slice of corners
        /*translate([tool_wall_thickness * 2, tool_magnet_width / 2 + tool_wall_thickness - tool_magnet_height / 2, tool_magnet_height]) {
            rotate([0, 0, 45]) {
                cube([50, 50, 50], center = false);
            }
        }*/
        translate([tool_wall_thickness * 2, -tool_magnet_width / 2 + tool_magnet_height / 2, tool_magnet_height]) {
            rotate([0, 0, -120]) {
                cube([50, 50, 50], center = false);
            }
        }
    }
}

module wheel(add_tool = false) {
    difference() {
        union() {
            difference() {
                cylinder(h = o_ring_cross_section_diameter, r = o_ring_inner_diameter / 2 + o_ring_cross_section_diameter, center = false, $fn = 200);
                translate([0, 0, -0.1]) {
                    difference() {
                        cylinder(h = o_ring_cross_section_diameter + 0.2, r = o_ring_inner_diameter / 2 + o_ring_cross_section_diameter - wheel_thickness, center = false, $fn = 200);
                        translate([0, 0, o_ring_cross_section_diameter / 2]) {
                            rotate_extrude(convexity = 10, $fn = 200) {
                                translate([o_ring_inner_diameter / 2 + o_ring_cross_section_diameter - wheel_thickness, 0, 0]) {
                                    circle(r = o_ring_cross_section_diameter / 2 + 0.2, $fn = 4);
                                }
                            }
                        }
                    }
                }
            }
            if (add_tool) {
                for (i = [0:2]) {
                    rotate([0, 0, 360 * i / 3 + 30]) {
                        // Magnet holder
                        translate([tool_magnet_distance_from_center - tool_wall_thickness, -tool_magnet_width / 2 - tool_wall_thickness, 0]) {
                            cube([tool_magnet_length + 2 * tool_wall_thickness, tool_magnet_width + 2 * tool_wall_thickness, tool_magnet_height]);
                        }
                        // Bottom rail
                        translate([tool_magnet_distance_from_center - tool_wall_thickness * 3, 0, 0]) {
                            rail();
                        }
                        // Top rail
                        translate([tool_magnet_distance_from_center + tool_magnet_length + tool_wall_thickness * 3, 0, 0]) {
                            mirror([1, 0, 0]) {
                                rail();
                            }
                        }
                        // Pin holders
                        translate([tool_magnet_distance_from_center + tool_wall_thickness + (tool_pin_diameter + tool_wall_thickness), tool_magnet_width + tool_wall_thickness / 2, 0]) {
                            cylinder(h = tool_magnet_height, d = tool_pin_diameter + tool_wall_thickness, $fn = 50);
                        }
                        translate([tool_magnet_distance_from_center + tool_magnet_length - tool_wall_thickness * 1.5, tool_magnet_width + tool_wall_thickness / 2, 0]) {
                            cylinder(h = tool_magnet_height, d = tool_pin_diameter + tool_wall_thickness, $fn = 50);
                        }
                    }
                }
            }
            // Wheel spokes
            for (i = [0:5]) {
                hull() {
                    rotate([0, 0, 360 * i / 6]) {
                        translate([0, -rim_diameter / 2 + wheel_screw_diameter / 2 + rim_thickness, 0]) {
                            cylinder(h = wheel_thickness, r = wheel_screw_diameter / 2 + rim_thickness, center = false, $fn = 32);
                        }
                    }
                    rotate([0, 0, 360 * i / 6 + 20]) {
                        translate([0, -o_ring_inner_diameter / 2 - o_ring_cross_section_diameter + wheel_thickness / 2, 0]) {
                            cylinder(h = wheel_thickness, d = wheel_thickness, center = false, $fn = 32);
                        }
                    }
                }
                hull() {
                    rotate([0, 0, 360 * i / 6]) {
                        translate([0, -rim_diameter / 2 + wheel_screw_diameter / 2 + rim_thickness, 0]) {
                            cylinder(h = wheel_thickness, r = wheel_screw_diameter / 2 + rim_thickness, center = false, $fn = 32);
                        }
                    }
                    rotate([0, 0, 360 * i / 6 - 20]) {
                        translate([0, -o_ring_inner_diameter / 2 - o_ring_cross_section_diameter + wheel_thickness / 2, 0]) {
                            cylinder(h = wheel_thickness, d = wheel_thickness, center = false, $fn = 32);
                        }
                    }
                }
                hull() {
                    rotate([0, 0, 360 * i / 6]) {
                        translate([0, -rim_diameter / 2 + wheel_screw_diameter / 2 + rim_thickness, 0]) {
                            cylinder(h = wheel_thickness, r = wheel_screw_diameter / 2 + rim_thickness, center = false, $fn = 32);
                        }
                    }
                    rotate([0, 0, 360 * i / 6]) {
                        translate([0, -o_ring_inner_diameter / 2 - o_ring_cross_section_diameter + wheel_thickness / 2, 0]) {
                            cylinder(h = wheel_thickness, d = wheel_thickness, center = false, $fn = 32);
                        }
                    }
                }
            }
        }
        translate([0, 0, o_ring_cross_section_diameter / 2]) {
            rotate_extrude(convexity = 10, $fn = 200) {
                translate([o_ring_inner_diameter / 2 + o_ring_cross_section_diameter, 0, 0]) {
                    circle(r = o_ring_cross_section_diameter / 2 + 0.01, $fn = 4);
                }
            }
        }
        // Wheel holes
        for (i = [0:5]) {
            rotate([0, 0, 360 * i / 6]) {
                translate([0, -rim_diameter / 2 + wheel_screw_diameter / 2 + rim_thickness, -0.01]) {
                    cylinder(h = wheel_thickness + 0.02, r = wheel_screw_diameter / 2 + 0.2, center = false, $fn = 32);
                }
            }
        }
        if (add_tool) {
            for (i = [0:2]) {
                rotate([0, 0, 360 * i / 3 + 30]) {
                    // Magnet hole
                    translate([tool_magnet_distance_from_center, -tool_magnet_width / 2, -0.1]) {
                        cube([tool_magnet_length, tool_magnet_width, tool_magnet_height + 1]);
                    }
                    // Pin holes
                    translate([tool_magnet_distance_from_center + tool_wall_thickness + (tool_pin_diameter + tool_wall_thickness), tool_magnet_width + tool_wall_thickness / 2, -0.1]) {
                        cylinder(h = tool_magnet_height + 1, d = tool_pin_diameter - 0.1, $fn = 50);
                    }
                    translate([tool_magnet_distance_from_center + tool_magnet_length - tool_wall_thickness * 1.5, tool_magnet_width + tool_wall_thickness / 2, -0.1]) {
                        cylinder(h = tool_magnet_height + 1, d = tool_pin_diameter - 0.1, $fn = 50);
                    }
                }
            }
        }
    }
}

wheel(add_tool = true);
