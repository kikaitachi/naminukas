use <MCAD/2Dshapes.scad>;

cell_width = 20; //125 + 10;
cell_height = cell_width * 4 / 3;
frame_width = 3;
frame_height = 4;
shaft_diameter = 30;
shaft_thickness = 5;
shaft_gap = 0.1;
cable_diameter = 2;

module shaft(diameter, height, thickness) {
    difference() {
        union() {
            cylinder(d = diameter - (shaft_thickness / 6) * 2, h = height, $fn = 100);
            linear_extrude(height, $fn = 100) {
                pieSlice(size = diameter / 2, start_angle = 20, end_angle = 25);
            }
        }
        translate([0, 0, -0.1]) {
            cylinder(d = diameter - thickness * 2, h = height + 1, $fn = 100);            
            linear_extrude(height + 1, $fn = 100) {
                pieSlice(size = diameter / 2 - shaft_thickness * 5 / 6, start_angle = 20, end_angle = 110);
            }
            linear_extrude(height + 1, $fn = 100) {
                pieSlice(size = diameter / 2 - shaft_thickness * 3 / 6, start_angle = 350, end_angle = 370);
            }
        }
    }
}

module frame(index) {
    difference() {
        union() {
            difference() {
                cube([
                    cell_width + 2 * frame_width,
                    cell_height + 2 * frame_width,
                    frame_height
                ]);
                translate([frame_width, frame_width, -0.1]) {
                    cube([
                        cell_width,
                        cell_height,
                        frame_height + 1
                    ]);
                }
            }
            rotate([0, 0, 45]) {
                diameter = shaft_diameter - index * shaft_thickness * 2;
                translate([- diameter / 2 + shaft_thickness / 6, 0, 0]) {
                    shaft(diameter, frame_height * (index + 1), shaft_thickness);
                }
                translate([- frame_width / 2, - frame_width, 0]) {
                    cube([5, frame_width * 2, frame_height]);
                }
            }
        }
        rotate([0, 45, -45]) {
            cube([cable_diameter, 20, cable_diameter], center = true);
        }
    }
}

frame(0);
/*for (i = [1 : 1]) {
    translate([0, 0, frame_height * i]) {
        rotate([0, 0, 90 * i]) {
            frame(i);
        }
    }
}*/
