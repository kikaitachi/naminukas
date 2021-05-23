use <MCAD/2Dshapes.scad>;

cell_width = 125;
cell_width_diagonal = 160;
frame_thickness = 3;
frame_height = 2;
gap_between_cells = 2;
shaft_gap = 0.1;
shaft_ridge = 0.5;
shaft_thickness = 3;
wire_thickness = 1.5;

module solar_cell_C60() {
    color([22 / 255, 33 / 255, 75 / 255]) {
        intersection() {
            cube([cell_width, cell_width, 1], center = true);
            rotate([0, 0, 45]) {
                cube([cell_width_diagonal, cell_width_diagonal, 1], center = true);
            }
        }
    }
}

module frame() {
    difference() {
        intersection() {
            cube([cell_width + frame_thickness, cell_width + frame_thickness, frame_height], center = true);
            rotate([0, 0, 45]) {
                cube([cell_width_diagonal + frame_thickness, cell_width_diagonal + frame_thickness, frame_height], center = true);
            }
        }
        intersection() {
            cube([cell_width, cell_width, frame_height + 1], center = true);
            rotate([0, 0, 45]) {
                cube([cell_width_diagonal, cell_width_diagonal, frame_height + 1], center = true);
            }
        }
    }
}

module shaft(diameter, height, top_height, tail_length) {
    difference() {
        union() {
            // Main body
            cylinder(d = diameter, h = height, $fn = 100);
            // Top solid part
            translate([0, 0, height - top_height]) {
                cylinder(d = diameter + shaft_ridge * 2, h = top_height, $fn = 100);
            }
            // Bottom part with turn stopping ridge
            linear_extrude(height, $fn = 100) {
                pieSlice(size = diameter / 2 + shaft_ridge, start_angle = 180, end_angle = 270);
            }
            // Tail
            translate([-frame_thickness / 2, 0, height - frame_height]) {
                cube([frame_thickness, tail_length, frame_height]);
            }
        }
        translate([0, 0, -0.1]) {
            // Main hole
            cylinder(d = diameter - shaft_thickness * 2 + shaft_gap * 2, h = height + 1, $fn = 100);
            // Turn stopping ridge hole
            linear_extrude(height + 1, $fn = 100) {
                pieSlice(size = diameter / 2 - shaft_thickness + shaft_gap + shaft_ridge, start_angle = 180, end_angle = 360);
            }
        }
        // Wire holes
        wire_in_angles = wire_thickness * 360 / (PI * (diameter - 2 * shaft_thickness));
        for (i = [-45 : 90 : 45]) {
            // Side holes
            rotate([0, 0, i]) {
                translate([0, diameter / 2, height - sqrt(pow(wire_thickness, 2) + pow(wire_thickness, 2)) / 2]) {
                    rotate([0, 45, 0]) {
                        cube([wire_thickness, diameter, wire_thickness], center = true);
                    }
                }
            }
            // Inner ridges
            translate([0, 0, -0.1]) {
                linear_extrude(height + 1, $fn = 100) {
                    pieSlice(size = diameter / 2 - shaft_thickness + shaft_gap + wire_thickness, start_angle = i - wire_in_angles / 2 + 90, end_angle = i + wire_in_angles / 2 + 90);
                }
            }
        }
    }
}

//solar_cell_C60();
frame();
shaft(10, 10, 5, 20);

/*
shaft_diameter = 30;
shaft_thickness = 3;
shaft_gap = 0.1;
shaft_height_bottom = 9;
cable_diameter = 2;

module C60() {
    width = 125;
    width_diagonal = 160;
    height = 0.5;
    color([22 / 255, 33 / 255, 75 / 255]) {
        intersection() {
            cube([width, width, height], center = true);
            rotate([0, 0, 45]) {
                cube([width_diagonal, width_diagonal, height], center = true);
            }
        }
    }
    color([206 / 255, 198 / 255, 195 / 255]) {
        translate([0, 0, -height]) {
            intersection() {
                cube([width, width, height], center = true);
                rotate([0, 0, 45]) {
                    cube([width_diagonal, width_diagonal, height], center = true);
                }
            }
        }
    }
}

module shaft(diameter, height, thickness) {
    difference() {
        union() {
            cylinder(d = diameter, h = height, $fn = 100);
            linear_extrude(height, $fn = 100) {
                pieSlice(size = diameter / 2 + (shaft_thickness / 6), start_angle = 20, end_angle = 25);
            }
        }
        translate([0, 0, -0.1]) {
            cylinder(d = diameter - thickness * 2, h = height + 1, $fn = 100);            
            linear_extrude(height + 1, $fn = 100) {
                pieSlice(size = diameter / 2 - shaft_thickness * 5 / 6, start_angle = 20, end_angle = 115);
            }
            linear_extrude(height + 1, $fn = 100) {
                pieSlice(size = diameter / 2 - shaft_thickness * 3 / 6, start_angle = 350, end_angle = 370);
            }
        }
    }
}

module frame(index, height) {
    diameter = shaft_diameter - index * (shaft_thickness + shaft_gap) * 2;
    difference() {
        union() {
            translate([cell_width / 2 + frame_width, cell_width / 2 + frame_width, frame_height * 2 / 3]) {
                mirror([0, 0, index == 0 ? 0 : 1]) {
                    for (i = [0 : cell_height / cell_width - 1]) {
                        translate([0, i * cell_width, 0]) {
                            C60();
                        }
                    }
                }
            }
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
                translate([- shaft_diameter / 2, 0, 0]) {
                    shaft(diameter, height, shaft_thickness);
                }
                translate([-(index + 1) * shaft_thickness + shaft_thickness / 2, - frame_width, 0]) {
                    cube([frame_width + (index + 1) * shaft_thickness - shaft_thickness / 2, frame_width * 2, frame_height + cell_gap - 0.1]);
                }
            }
        }
        // Cable hole
        #hull() {
            translate([-diameter / 2, -diameter / 2, frame_height / 2]) {
                sphere(d = cable_diameter, $fn = 32);
            }
            translate([cell_width + diameter / 2, cell_height + diameter / 2, frame_height / 2]) {
                sphere(d = cable_diameter, $fn = 32);
            }
        }
    }
}

delta = sqrt(pow(shaft_diameter / 2, 2) * 2) / 2;
translate([delta, delta, 0]) {
    union() {
        frame(0, frame_height);
        translate([cell_width + 2 * frame_width, cell_height + 2 * frame_width, 0]) {
            rotate([0, 0, 180]) {
               frame(0, frame_height);
            }
        }
    }
}
for (i = [1 : 3]) {
    translate([0, 0, (frame_height + cell_gap) * (i + 1)]) {
        rotate([0, 0, 90 * i * $t]) {
            translate([delta, delta, 0]) {
                mirror([0, 0, 1]) {
                    frame(i, frame_height * (i + 1) + (i == 3 ? shaft_height_bottom : 0));
                }
            }
        }
    }
    translate([cell_width + (delta + frame_width) * 2, cell_height + (delta + frame_width) * 2, (frame_height + cell_gap) * (i + 4)]) {
        rotate([0, 0, 90 * i * $t - 180]) {
            translate([delta, delta, 0]) {
                mirror([0, 0, 1]) {
                    frame(i, frame_height * (i + 4) + (i == 3 ? shaft_height_bottom : 0));
                }
            }
        }
    }
}
*/