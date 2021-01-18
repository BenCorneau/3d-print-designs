

//$fn => number of fragments, increase to create higher res rendering for 3D printing 
$fn=60;

//dimensions of power supply
WIDTH = 38;
HEIGTH = 28;
LENGTH = 93;

BASE_OPENING_WIDTH = 30;
BASE_OPENING_HEIGHT = 20;

FRONT_OPENING_OFFSET = 6;

WALL_THICKNESS = 1.8;

HOLE_SIZE = 1;
COUNTER_SINK_DEPTH = 0.8;


outter_cube_width = WIDTH + WALL_THICKNESS*2;
outter_cube_height = HEIGTH + WALL_THICKNESS*2;
module outter_cube(){
    linear_extrude(height = LENGTH + WALL_THICKNESS)
        square([outter_cube_width, outter_cube_height]);
}

module inner_cube() {
    translate([WALL_THICKNESS, WALL_THICKNESS, WALL_THICKNESS])    
        linear_extrude(height = LENGTH)
            square([WIDTH, HEIGTH]);   
}

module hollow_box(){
    difference(){
        outter_cube();
        inner_cube();
    }
}

base_opening_x_offset = (outter_cube_width - BASE_OPENING_WIDTH)/2;
base_opening_y_offset = (outter_cube_height - BASE_OPENING_HEIGHT)/2;
module base_opening(){
    linear_extrude(height = WALL_THICKNESS)
        translate([base_opening_x_offset, base_opening_y_offset, 0])
            square([BASE_OPENING_WIDTH ,BASE_OPENING_HEIGHT ]);
}

front_opening_width = WIDTH - (FRONT_OPENING_OFFSET * 2);
front_opening_x_offset = FRONT_OPENING_OFFSET + WALL_THICKNESS;
front_opening_z_offset = FRONT_OPENING_OFFSET + WALL_THICKNESS;
module front_opening(){
    translate([front_opening_x_offset, 0, front_opening_z_offset])
        linear_extrude(height = LENGTH)
            square([front_opening_width ,WALL_THICKNESS ]);
}


module mounting_hole(){
    union(){
        translate([0, HEIGTH + WALL_THICKNESS*2, 0]){
            rotate([90, 0, 0])    
                linear_extrude(height = WALL_THICKNESS) circle(HOLE_SIZE);
        }
        translate([0, HEIGTH+WALL_THICKNESS+COUNTER_SINK_DEPTH, 0]){
            rotate([90, 0, 0])    
                linear_extrude(height = COUNTER_SINK_DEPTH) circle(HOLE_SIZE*3);
        }
    }      
}

center_back = outter_cube_width/2;

difference(){
    hollow_box();
   # union(){
        base_opening();
        front_opening();
        translate([center_back, 0, 20])  mounting_hole();
        translate([center_back, 0, 70])  mounting_hole();
    }
}


    

