include <dimensions.scad>

module tool() {
    difference() {
        union() {
            translate([0, -tool_magnet_width / 2 - tool_wall_thickness, 0]) {
                cube([tool_length, tool_magnet_width + 2 * tool_wall_thickness, tool_magnet_height]);
            }
        }
        translate([tool_wall_thickness, -tool_magnet_width / 2, -0.1]) {
            cube([tool_magnet_length, tool_magnet_width, tool_magnet_height + 1]);
        }
        translate([tool_magnet_length + 5 * tool_wall_thickness, 0, tool_diameter / 2 + tool_wall_thickness]) {
            rotate([0, 90, 0]) {
                cylinder(h = tool_length, d = tool_diameter, $fn = 100);
            }
        }
        translate([tool_length - 2.5, 0, -0.1]) {
            cylinder(h = tool_magnet_height, d = tool_hole_diameter, $fn = 50);
        }
        translate([tool_length - 12.5, 0, -0.1]) {
            cylinder(h = tool_magnet_height, d = tool_hole_diameter, $fn = 50);
        }
    }
}

tool() {
}
