

//$fn => number of fragments, increase to create higher res rendering for 3D printing 
$fn=360;



CUP_WIDTH = 65.2;
CUP_HOLDER_BORDER =16;
HOLDER_WIDTH = CUP_WIDTH + CUP_HOLDER_BORDER*2;

THICKNESS = 2;

WALL_MOUNT_HEIGTH = 45;

BRACE_HEIGHT = WALL_MOUNT_HEIGTH * .6;
BRACE_WIDTH = HOLDER_WIDTH - CUP_HOLDER_BORDER - THICKNESS;


HOLE_SIZE = 1;
COUNTER_SINK_DEPTH = 0.8;

module rounded_square(width, height, corner_radius){
    cr = corner_radius;
     union(){
         //+ shape, needs circles to fill in the corners of the plus
         translate([0, cr, 0])square([width,      height-cr*2]);
         translate([cr,0,  0])square([width-cr*2, height]);
         
         //round corners
         translate([cr,       cr,        0]) circle(cr);
         translate([width-cr, cr,        0]) circle(cr);
         translate([cr,       height-cr, 0]) circle(cr);
         translate([width-cr, height-cr, 0]) circle(cr);
    }   
}

module brace(){
    
    translate([THICKNESS,THICKNESS,THICKNESS]){
        rotate([0,-90,0]){
            linear_extrude(height = THICKNESS){
                polygon(points = [ [0, 0],
                                   [0, BRACE_WIDTH],
                                   [BRACE_HEIGHT, 0],
                                   [0,0]]);
            }
        }
    }
}


module half_rounded_rect(width, height, corner_radius){
    union(){
        rounded_square(width, height, corner_radius);
        square([width, height/2]);
   }  
}


module cup_holder_top(){
    linear_extrude(height = THICKNESS){
        difference(){
            half_rounded_rect(HOLDER_WIDTH, HOLDER_WIDTH, 10);
            translate([CUP_HOLDER_BORDER, CUP_HOLDER_BORDER, 0]){
                rounded_square(CUP_WIDTH,CUP_WIDTH, 10);
            }
        }            
    }
}

SCREW_THREAD_DIAMETER = 3.4;
SCREW_HEAD_DIAMETER =  7.3;
SCREW_HEAD_HEIGHT = 2.4;
SCRE_HEAD_OUTER_RIM_HEIGHT = 0.78;

SCREW_THREAD_RADIUS = SCREW_THREAD_DIAMETER/2;
SCREW_HEAD_RADIUS =  SCREW_HEAD_DIAMETER/2;
SCREW_LENGTH = 10;

module screwWhole(){  
    rotate_extrude(angle = 360, convexity = 2){
        polygon(points = [
         [0, 0],
         [SCREW_HEAD_RADIUS, 0],
         [SCREW_HEAD_RADIUS, SCRE_HEAD_OUTER_RIM_HEIGHT],
         [SCREW_THREAD_RADIUS, SCREW_HEAD_HEIGHT],
         [SCREW_THREAD_RADIUS, SCREW_LENGTH],
         [0, SCREW_LENGTH],
         [0,0]]); 
    }
}


module wall_mount(){
    translate([0,THICKNESS,0]){
        rotate([90,0,0]){
            difference(){
                linear_extrude(height = THICKNESS){
                    half_rounded_rect(HOLDER_WIDTH, WALL_MOUNT_HEIGTH,10);
                }
                union(){
                    translate([HOLDER_WIDTH/2,WALL_MOUNT_HEIGTH*.25 + THICKNESS,0]){
                        screwWhole();
                    }
                    
                    translate([HOLDER_WIDTH/2,WALL_MOUNT_HEIGTH*.75,0]){
                        screwWhole();
                    }
                }
            }
        }
    }
}

module top_support(){
    
    leftOffset = CUP_HOLDER_BORDER/2-THICKNESS/2;
    rightOffset = HOLDER_WIDTH-THICKNESS-CUP_HOLDER_BORDER/2+THICKNESS/2;
    
    supportRingWidth = rightOffset - leftOffset + THICKNESS;
    supportRingHeight = HOLDER_WIDTH - THICKNESS - leftOffset;
    
    //left angle brace
    translate([leftOffset,0,0]){
        brace();
    }

    //right angle brace
    translate([rightOffset,0,0]){
        brace();
    }
    
    //ring reinforcement
    translate([leftOffset,THICKNESS,THICKNESS]){
        linear_extrude(height = THICKNESS*2){
            difference(){
                half_rounded_rect(supportRingWidth, supportRingHeight, 12);
                translate([THICKNESS,0,0]){
                    half_rounded_rect(supportRingWidth-THICKNESS*2, supportRingHeight-THICKNESS,10);
             }
         }     
    }
}
    
}

module object(){
    cup_holder_top();
    wall_mount();
    top_support();
    
    
}

object();






