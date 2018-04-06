/*
    120mm Fan Controller Case
    Author: Devin Watson
*/

/*
    Part numbers for individual models:
    
    0: Full assembly (viewing only)
    1: Case lower
    2: Faceplate
    3: Fan housing / top lid
*/
PARTNO = 1;

button_lower_dia = 29.7;
button_upper_dia = 32.8;
button_height = 24.9;
button_upper_height = 7.9;
led_dia = 5.4;
button_lower_height = button_height - button_upper_height;

fan_width = 120; // 120mm fan
fan_thickness = 30.5;   // 29.7mm thick
floor_thickness = 2.0;
case_height = 55;

$fn = 70;

module fan() {
    roundedcube(fan_width, fan_thickness, fan_width, 2);
}

// Makes a Sanwa style arcade button slug
module arcade_button() {
    union() {
        cylinder(d=button_lower_dia, h=button_lower_height);
        translate([0,0,button_lower_height]) cylinder(d=button_upper_dia,h=button_upper_height);
    }
}

module case_lower() {
    
    union() {
        
        difference() {
            translate([-3,-3, 0]) roundedcube(fan_width + 6, fan_thickness + case_height, case_height, 2);
            translate([-5,case_height/2 - 4.5,case_height - 7]) roundedcube(fan_width + 12, case_height + 10, 10, 2);
            
            // Power supply hole
            translate([20,fan_thickness + case_height,20]) rotate([90,0,0]) cube([12.15, 12.15, 10]);
            
            // Cutouts and curves
            translate([4,23,-5]) roundedcube(fan_width - 8, fan_thickness + 25, case_height + 2, 2);
            
            // 45-degree angle on front
            translate([-4,-64,6]) rotate([-45, 0, 0]) roundedcube(130, 30, 100, 2);
            
            // Angled cutout on front for faceplace
            translate([5,-2,-1]) cube([fan_width - 10, 25.75, case_height - 2]);
            
            translate([-3, -3, 24]) { 
                rotate([45, 0, 0]) {
                    faceplate();
                }
            }
            
            // Create pin holes
            fan_housing();
        }
        
        translate([-3, -3, -floor_thickness]) {
            bottom_plate();
        }
    }
}

// Top lid to hold the fan
module fan_housing() {
    union() {
        difference() {
            translate([-3,case_height/2,case_height - 7]) roundedcube(fan_width + 6, case_height - 0.6, 8, 2);
            // Fan slug
            translate([0,30,50]) fan();
       
            // Fan power wiring hole
            translate([105,65,10]) cube([8,8,60]);
        }
        
        // TL
        translate([0.5,case_height + 22, case_height-9]) {
            cylinder(d=3, h=3);
        }
        
        // BL
        translate([0.5,case_height - 15, case_height-9]) {
            cylinder(d=3, h=3);
        }
        
        // BR
        translate([fan_width - 0.5,case_height - 15, case_height-9]) {
            cylinder(d=3, h=3);
        }
        
        // TR
        translate([fan_width - 0.5, case_height + 22, case_height - 9]) {
            cylinder(d=3, h=3);
        }
    }
}

module faceplate() {
    led_x_offset = 55;
    
    union() {
        difference() {
            roundedcube(fan_width + 6, 44, 2.4, 2);
            translate([30, 20, -12]) arcade_button();
            
            // LED passthroughs
            translate([led_x_offset, 30, -1]) cylinder(d=led_dia, h=10);
            translate([led_x_offset + 10, 30, -1]) cylinder(d=led_dia, h=10);
            translate([led_x_offset + 20, 30, -1]) cylinder(d=led_dia, h=10);
            
        }
    
        // BL
        translate([4, 5, -3]) cylinder(d=3, h=3.5);
        
        // TL
        translate([4, 30, -3]) cylinder(d=3, h=3.5);
        
        // TR
        translate([fan_width + 2, 30, -3]) cylinder(d=3, h=3.5);
        
        // BR
        translate([fan_width + 2, 5, -3]) cylinder(d=3, h=3.5);
    }
}

module bottom_plate() {
    roundedcube(fan_width + 6, fan_thickness + 55, floor_thickness, 2);
}

module full_assy() {
    case_lower();
    
    translate([-3, -3, 24]) { 
        rotate([45, 0, 0]) {
            faceplate();
        }
    }
    
    fan_housing();
}

module roundedcube(xdim, ydim, zdim, rdim) {
    hull() {
        translate([rdim, rdim, 0]) cylinder(r=rdim,h=zdim);
        translate([xdim-rdim, rdim, 0]) cylinder(r=rdim,h=zdim);
        translate([rdim, ydim-rdim, 0]) cylinder(r=rdim,h=zdim);
        translate([xdim-rdim, ydim-rdim, 0]) cylinder(r=rdim,h=zdim);
    }
}

if ( PARTNO == 0 ) full_assy();
if ( PARTNO == 1 ) case_lower();
if ( PARTNO == 2 ) faceplate();
if ( PARTNO == 3 ) fan_housing();