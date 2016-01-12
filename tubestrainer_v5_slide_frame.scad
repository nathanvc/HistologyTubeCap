//----------------------------
// tubestrainer_v5_slide_frame
//----------------------------
// Nathan Vierling-Claassen
// Designed in consultation with Kevin Bath and Gabriela Manzano Nieves
// 12/2015, revised 1/2016
// OpenSCAD design
//---------------------------
// --Tube strainer cap for processing histological tissue
// --allows filling (open setting), straining (strainer setting), 
// and stirring (close setting) without changing cap or tube.
// --Cap fits on Fischer Scientific 2mL MCT Graduated Tubes, 05-408-146
// --Glue small square of nylon mesh over rectangular frame, and then fit into sliding cap
// --Nylon stockings work, but stretch firmly before gluing
// --Print quality should be quite high in order for slider to work smoothly 
// --Printed with support from the build surface
// --Remove support material carefully with scalpel or dental pick
// to ensure good fit over tube
//--Test prints were with ABS on a Lulzbot Taz4 with hexagon print head
// upgrade (which is essentially a Taz5) at fine resolution (0.16 layer height)
//-- measurements are in mm (standard for openSCAD)
//---------------------------
$fn=30;

// tube top diam
diam_tp=13.4;

// tube base diam (diameter under ridge)
diam_b=11;

// depth of groove for sliding over top of tube
d_gv=1.75;

// thickness of walls throughout
th=1;

// thickness for the thin cap to cover nylon fabric
th_c=0.5;

// depth of groove for slider
gv_d=1;

// thickness of sliding cap
sl_th=1.5;

// clearance for sliding cap groove
// NOTE: this can be adjusted if slider is to tight/loose on your printer
sl_cl=0.5;

// extra width of slider to allow for gluing screen 
sl_gl=1.5;

// width of ridge around gluing area (protects sliding space 
// from glue/nylon interference)
gl_w=0.5;

// width of sliding cap (allows for extra width for gluing screen)
sl_w=diam_tp+2*sl_gl+2*sl_cl+2*gv_d;

// width of handle tab for slider
t_w=3; 

// height of handle tab for slider
t_h=2;  

// change print direction from original for the tube cap
// (an earlier design without sliding top printed the opposite direction in z)
rotate(180,[0, 1, 0]) {
    
//----------------------------------    
// Make topper that attaches to tube
// ---------------------------------    
    difference(){
        // outer body of tube cap
        translate([-0.5*diam_tp-th-sl_gl,-sl_w/2-th-sl_cl,-sl_th-sl_cl-th])
            cube([2*diam_tp+sl_gl+gv_d+sl_cl+t_w,sl_w+2*th+2*sl_cl,d_gv+2*th+sl_th+sl_cl+th]);
        union(){
            // remove inner cylinder
            cylinder(h=20, r=diam_b/2, center=true);
            // remove slightly larger cylinder to make opening that slides onto tube
            translate([0,0,th])cylinder(h=d_gv, r=diam_tp/2);
            // remove cubes at front that extend opening on tube topper groove
            translate([-diam_tp,-diam_tp/2,th])cube([diam_tp, diam_tp , d_gv]);
            // remove wider opening at front to make it easier to load tube
            translate([-diam_tp-4,-diam_tp/2-th,th])cube([diam_tp, diam_tp+2*th , d_gv+2*th]);
            // extend narrower lower portion of groove for tube to the front
            translate([-diam_b,-diam_b/2,th])cube([diam_b, diam_b , d_gv+2*th]);
            // remove inside wider portion of slider opening for top
            translate([-1.5*diam_tp-sl_gl,-sl_w/2-sl_cl,-sl_th-sl_cl])
                cube([4*diam_tp+2*sl_gl,sl_w+2*sl_cl,sl_th+sl_cl]);
            // remove more narrow opening on top of slider groove
            translate([-1.5*diam_tp+gv_d-sl_gl,-sl_w/2+gv_d,-sl_th-sl_cl-th])
                cube([4*diam_tp+2*sl_gl,sl_w-gv_d*2,sl_th+sl_cl+th]);
        }
    }

// ---------------------------
// Make sliding top (2 pieces)
// ---------------------------
      // Main Portion of Sliding top
      //----------------------------
      // shift this downward, so that bottom of both parts are at same location in z-axis
      // shift in y so parts not joined      
      translate([0,15,d_gv+2*th-sl_th]){
        difference(){
            union(){
                // body of sliding top
                translate([-t_w,0,0])cube([2*diam_tp+sl_gl+gv_d+sl_cl+t_w, sl_w, sl_th]);
                // handle for moving sliding top
                translate([-t_w,1.5*sl_cl+gv_d,-t_h])cube([t_w,sl_w-t_w*sl_cl-2*gv_d,t_h]);
                // thin ridges at edge of opening to protect slider from glue/nylon
                translate([gv_d+sl_cl, +gv_d+sl_cl, -gl_w])
                difference(){
                    cube([diam_b+2*sl_gl, sl_w-2*gv_d-2*sl_cl,gl_w]);
                    translate([0,gl_w,0])
                    cube([diam_b+2*sl_gl, sl_w-2*gv_d-2*sl_cl-2*gl_w,gl_w]);
                }
            }
            union(){
                // remove cylindrical opening for nylon strainer
                translate([diam_tp/2+sl_gl, sl_w/2,0]) cylinder(h=5, r=diam_b/2);
                // remove opening for frame for nylon to fit above screened opening
                translate([gv_d+sl_cl, gv_d+sl_cl+gl_w, -gl_w+sl_th/2-0.25])
                    cube([diam_b+2*sl_gl, sl_w-2*gv_d-2*sl_cl-2*gl_w, sl_th/2]); 
            }          
        }
        // separate thin frame to glue nylon to, 
        // fits into slider after nylon is glued, some fiddling to get clearance between pieces 
        //---------------------------------
        // shift to own print error and such that print surface is same as other parts
        translate([gv_d+sl_cl, gv_d+sl_cl+gl_w+20, d_gv+2*th-2*sl_th+0.2]) 
                difference(){
                    translate([0.25,0.25,0])cube([diam_b+2*sl_gl-.5, sl_w-2*gv_d-2*sl_cl-2*gl_w-.5, sl_th/2-0.2]); 
                    translate([diam_b/2+sl_gl,(sl_w-2*gv_d-2*sl_cl-2*gl_w)/2,0]) cylinder(h=5, r=diam_b/2);
                }
        }
}

