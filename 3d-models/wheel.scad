include <dimensions.scad>
use <tool-attachment-hole.scad>

module wheel(add_tool_rim = false) {
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
            if (add_tool_rim) {
                // Tool rim
                difference() {
                    cylinder(h = tool_attachment_hole_depth, r = tool_attachment_distance_from_center + tool_attachment_hole_depth + wheel_thickness, center = false, $fn = 200);
                    translate([0, 0, -0.1]) {
                    cylinder(h = tool_attachment_hole_depth + 1, r = tool_attachment_distance_from_center - tool_attachment_hole_depth - wheel_thickness, center = false, $fn = 200);
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
        if (add_tool_rim) {
            // Tool attachment holes
            for (i = [0:11]) {
                rotate([0, 0, 360 * i / 12]) {
                    translate([0, 0, -0.01]) {
                        tool_attachment_hole(half_depth = tool_attachment_hole_depth / 2 + 0.05);
                    }
                }
            }
        }
    }
}

wheel(add_tool_rim = false);
