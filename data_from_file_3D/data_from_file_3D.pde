
/*
DDF 2018
Gets data from text file and generates a series of spheres
*/
int[] data;

void setup() {
  size(800, 400, P3D);
  String[] stringFromdata = loadStrings("data.txt");          // load our file into a string array
  data= int(split (stringFromdata[0], ',')); 
  fill(255, 0, 0);                                            // our string arry only has one item because the file had one line
  noStroke();
}                                                             // split the String to items using ',' as deliminato                                                                                 
                                                              // cast the strings into an int array data[]


void draw() { 
  lights();
  background(0); 
  rotateX(mouseY/100.0);                                       // these rotations are just for viewing the geometry from different angles
  rotateY(mouseX/100.0);
  translate (0, 50);                                          
  for (int i = 0; i<data.length; i++) {
    translate (50, 0);                                           // translate to space the spheres
    sphere(data[i]);                                            // draw a sphere with diamater based on data in file
  }                                                             // remember that spere always draws in location 0,0,0 but we translated.
}