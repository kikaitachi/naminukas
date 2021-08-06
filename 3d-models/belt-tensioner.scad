module belt_tensioner(
        feet_height = 10,
        feet_thickness = 1,
        feet_length = 10,
        plate_height = 20,
        plate_thickness = 3,
        plate_screw_diamerer = 3.2,
        plate_screw_count = 2,
        saddle_thickness = 2,
        saddle_length = 15,
        saddle_gap = 5.6,
        saddle_screw_diameter = 2.2) {
    difference() {
        union() {
            cube([feet_height, feet_thickness, feet_length]);
            translate([0, feet_thickness + saddle_gap, 0]) {
                cube([feet_height, feet_thickness, feet_length]);
            }
            translate([-saddle_thickness, 0, 0]) {
                cube([saddle_thickness, feet_thickness * 2 + saddle_gap, saddle_length]);
            }
            translate([-saddle_thickness - plate_height, 0, 0]) {
                cube([plate_height, plate_thickness, feet_length]);
            }
        }
        // Saddle screw
        translate([-saddle_thickness - 0.1, saddle_gap / 2 + feet_thickness, saddle_length - saddle_screw_diameter]) {
            rotate([0, 90, 0]) {
                cylinder(d = saddle_screw_diameter, h = saddle_thickness + 1, $fn = 20);
            }
        }
        // Plate screws
        for (i = [0 : plate_screw_count - 1]) {
            translate([-plate_height + 0.5, plate_thickness + 0.1, saddle_screw_diameter * 2 * i + 2.7]) {
                rotate([90, 0, 0]) {
                    cylinder(d = plate_screw_diamerer, h = plate_thickness + 1, $fn = 50);
                }
            }
        }
    }
}

//mirror([0, 1, 0]) {
    belt_tensioner();
//}
