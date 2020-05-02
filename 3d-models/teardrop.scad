module teardrop(radius = 10, length = 20) {
    rotate([90, 0, 0]) {
        rotate([0, 0, 45]) {
            translate([0, 0, -length / 2]) {
                linear_extrude(height = length) {
                    union() {
                        circle(r = radius, $fn = 64);
                        square([radius, radius]);
                    }
                }
            }
        }
    }
}
