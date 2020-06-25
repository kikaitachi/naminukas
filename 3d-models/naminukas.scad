use <bevel-gear-to-cup-fixing.scad>
use <bbb-holder-plate.scad>
use <bottom-bevel-gear.scad>
use <servo-bracket.scad>
use <servo-joining-plate.scad>
use <side-bevel-gear.scad>
use <suction-cup-connector.scad>
use <tool-holder.scad>
use <wheel.scad>

translate([-150 / 2, 0, 0]) {
    translate([0, 0, -25]) {
        suction_cup_connector();
    }
    translate([0, 0, 32]) {
        bottom_bevel_gear();
    }
    translate([0, 40, 50]) {
        rotate([90, 0, 0]) {
            side_bevel_gear();
        }
    }
    translate([50, 0, 20]) {
        rotate([-90, 0, 90]) {
            servo_bracket();
        }
    }
    translate([-50, 0, 20]) {
        rotate([-90, 0, -90]) {
            servo_bracket();
        }
    }
    translate([60, 0, 30]) {
        rotate([0, -45, 180]) {
            servo_joining_plate();
        }
    }
    translate([0, 0, 50]) {
        bevel_gear_to_cup_fixing();
    }
    wheel(add_tool = false);
}
translate([150 / 2, 0, 0]) {
    translate([0, 0, -25]) {
        suction_cup_connector();
    }
    translate([0, 0, 32]) {
        bottom_bevel_gear();
    }
    translate([0, 40, 50]) {
        rotate([90, 0, 0]) {
            side_bevel_gear();
        }
    }
    translate([50, 0, 20]) {
        rotate([-90, 0, 90]) {
            servo_bracket();
        }
    }
    translate([-50, 0, 20]) {
        rotate([-90, 0, -90]) {
            servo_bracket();
        }
    }
    translate([-60, 0, 30]) {
        rotate([0, -45, 0]) {
            servo_joining_plate();
        }
    }
    translate([0, 0, 50]) {
        bevel_gear_to_cup_fixing();
    }
    wheel(add_tool = true);
    translate([30, 0, 70]) {
        rotate([180, -70, 180]) {
            tool_holder();
        }
    }
}
translate([-50, 50, 130]) {
    rotate([0, 90, 180]) {
        power_and_control_module();
    }
}
