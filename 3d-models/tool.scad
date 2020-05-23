include <dimensions.scad>

module rail() {
    difference() {
        rotate([90, 0, 0]) {
            cylinder(h = tool_magnet_width + 2 * tool_wall_thickness, d = tool_magnet_height / 2 - 0.2, center = true, $fn = 4);
        }
        // Slice of corners
        translate([-tool_magnet_height / 2, tool_magnet_width / 2 + tool_wall_thickness - tool_magnet_height / 2, -tool_magnet_height / 2]) {
            rotate([0, 0, 45]) {
                cube([50, 50, 50], center = false);
            }
        }
        translate([-tool_magnet_height / 2, -tool_magnet_width / 2 - tool_wall_thickness + tool_magnet_height / 2, -tool_magnet_height / 2]) {
            rotate([0, 0, -135]) {
                cube([50, 50, 50], center = false);
            }
        }
    }
}

module tool() {
    difference() {
        union() {
            // Magnet holder
            translate([0, -tool_magnet_width / 2 - tool_wall_thickness, 0]) {
                cube([tool_magnet_length + 2 * tool_wall_thickness, tool_magnet_width + 2 * tool_wall_thickness, tool_magnet_height]);
            }
            // Slider bottom
            translate([0, 0, tool_magnet_height * 3 / 4]) {
                rail();
            }
            // Slider top
            translate([tool_magnet_length + 2 * tool_wall_thickness, 0, tool_magnet_height * 3 / 4]) {
                rotate([0, 0, 180]) {
                    rail();
                }
            }
            // Tool holder
            translate([0, -tool_magnet_width / 2 - tool_wall_thickness, 0]) {
                cube([tool_length, tool_magnet_width + 2 * tool_wall_thickness, tool_magnet_height / 2]);
            }
            // Round bracket
            translate([tool_length, 0, 0]) {
                cylinder(h = tool_bracket_height, d = tool_diameter + tool_wall_thickness, $fn = 100);
            }
            // Tightener block
            translate([tool_length + tool_diameter / 2, 0, tool_bracket_height / 2]) {
                cube([8, 6, tool_bracket_height], center = true);
            }
        }
        // Magnet hole
        translate([tool_wall_thickness, -tool_magnet_width / 2, -0.1]) {
            cube([tool_magnet_length, tool_magnet_width, tool_magnet_height + 1]);
        }
        // Round tool hole
        translate([tool_length, 0, -0.1]) {
            rotate([0, 0, 0]) {
                cylinder(h = 10, d = tool_diameter, $fn = 100);
            }
        }        
        // Tightener gap
        translate([tool_length + tool_diameter / 2, 0, tool_bracket_height / 2]) {
            cube([9, 3, tool_bracket_height + 1], center = true);
        }
        // Tightener screw
        translate([tool_length + tool_diameter / 2 + 2, 0, tool_bracket_height / 2]) {
            rotate([90, 0, 0]) {
                cylinder(h = tool_bracket_height + 1, d = tool_hole_diameter, center = true, $fn = 50);
            }    
        }
        /*translate([tool_length - 2.5, 0, -0.1]) {
            cylinder(h = tool_magnet_height, d = tool_hole_diameter, $fn = 50);
        }
        translate([tool_length - 12.5, 0, -0.1]) {
            cylinder(h = tool_magnet_height, d = tool_hole_diameter, $fn = 50);
        }*/
    }
}

tool();
