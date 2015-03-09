/**
 * Camera input and visualization code
 * by Mel Chua & Esteban Garcia
 * Captures the brightness of each quadrant of the screen
 * and displays awesome video stuff. 
 */
 
import codeanticode.gsvideo.*; // enables use of the GScapture library
import processing.opengl.*;
import processing.video.*; // Enables webcam use
import oscP5.*;            // Enables OSC messaging
import netP5.*;            // Enables OSC message sending over the network

// OPTION 1: Default video setup
Capture video;

/**
// OPTION 2: GScapture video setup
GSCapture video;
boolean grid = false;
**/

// OSC setup
OscP5 oscP5;
NetAddress myRemoteLocation;

boolean grid = false;
boolean movement1 = true;
boolean movement2 = false;
boolean movement3 = false;
boolean movement4 = false;
float val1,val2,val3,val4; //to store the variables
float h0,h1,h2,h3,h4; // the depth of each quadrant in movement 2
//float a,b,c; // for the cake final movement
PVector A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T; // Points for tunnel
PVector U, V, W, X, Y, Z; //Points for the cake

   

void setup() {
  
  // OPTION 1: Default screen setup
  size(640, 480);
  video = new Capture(this, width, height);
  
  /**
  // OPTION 2: GScapture screen setup
  size(800, 600,OPENGL);
  video = new GSCapture(this, width, height);
  **/
  
  // Screen setup regardless of option (default/GScapture)
  video.start();  
  noStroke();
  // smooth();
  
  // Set up OSC messaging
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  
   /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. Right now it's sending to
   * Davin's office computer. You may want to change this.
   */
  myRemoteLocation = new NetAddress("10.184.168.236",12000);
  
  h0=0;
  h1=-400;
  h2=-800;
  h3=-1200;
  h4=-1600;
  
 //Tunnel points
  A= new PVector(0, 0,h0);
  E= new PVector(0, 0,h1);
  I= new PVector(0, 0,h2);
  M= new PVector(0, 0,h3);
  Q= new PVector(0, 0,h4);
  
  B= new PVector(width, 0,h0);
  F= new PVector(width, 0,h1);
  J= new PVector(width, 0,h2);
  N= new PVector(width, 0,h3);
  R= new PVector(width, 0,h4);
  
  C= new PVector(width, height,h0);
  G= new PVector(width, height,h1);
  K= new PVector(width, height,h2);
  O= new PVector(width, height,h3);
  S= new PVector(width, height,h4);
  
  D= new PVector(0, height,h0);
  H= new PVector(0, height,h1);
  L= new PVector(0, height,h2);
  P= new PVector(0, height,h3);
  T= new PVector(0, height,h4);
  
  
    
  
  
}

void draw() {
  lights();
  ambientLight(val3,val2,val4);
   
  
   float total_bright_top_right= 0;
    float total_bright_top_left= 0;
    float total_bright_bot_right= 0;
    float total_bright_bot_left= 0;
   
  
  if (video.available()) {
    //smooth();
    background(val1);
    video.read();
    
    //Variables for holding brightness of the 4 quadrants
    // right, left, top, bottom
    
    // Sum the brightness of the screen.
    // For each row of pixels in the video image and
    // for each pixel in the yth row, add each pixel's brightness to the total.
    video.loadPixels();
    int index = 0;
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {
        // Get the color stored in the pixel
        int pixelValue = video.pixels[index];
        // Determine the brightness of the pixel
        float pixelBrightness = brightness(pixelValue);
        // Add the brightness to the proper quadrant.
        if (y < video.height/2){   // Pixel is on top
          if (x < video.width/2){  // Pixel is right (and top)
            total_bright_top_left += pixelBrightness/100000;
            val1=total_bright_top_left;
          }
          else{                    // Pixel is left (and top)
            total_bright_top_right += pixelBrightness/100000;
            val2=total_bright_top_right;
          }
        }
        else{                      // Pixel is on bottom
          if (x < video.width/2){  // Pixel is right (and bottom)
            total_bright_bot_left += pixelBrightness/100000;
            val3=total_bright_bot_left;
          }
          else{                    // Pixel is left (and bottom)
            total_bright_bot_right += pixelBrightness/100000;
            val4=total_bright_bot_right;
          }
        }
        index++;
      }
    }
    
    // Cast float values to integers
    int quadA = int(total_bright_top_left);
    int quadB = int(total_bright_top_right);
    int quadC = int(total_bright_bot_left);
    int quadD = int(total_bright_bot_right);
    // Print the total brightness of each quadrant to the terminal (debug feature).
    print("Top L, R, Bot R, L", quadA, "\t", quadB, "\t", quadC, "\t", quadD, "\n");

    // Create an OSC message with the 4 integers
    // have it come from the /camera space (OSC address)
    OscMessage myMessage = new OscMessage("/camera");
    myMessage.add(quadA);
    myMessage.add(quadB);
    myMessage.add(quadC);
    myMessage.add(quadD);
    
    // Send the message
    oscP5.send(myMessage, myRemoteLocation);

    if (movement1){ //graphics for the first movement
      noStroke();
      pushMatrix(); //layer 1-background
       
       
       rotateX(val2*0.001);
       translate(0,0,val2*-1);
       fill(val1,120,100);
        rect(0,0,width,height);
        pushMatrix();//layer 1.a - ellipse
          translate(0,0,100);
          fill(100,100,val2); 
          ellipse(val2*2,val3*2,80,80);
        popMatrix();
      popMatrix();
    }
    
    if (movement2){
      noStroke();
      tunnel();
    }
    
    if (movement3){
      noStroke();
      triangles();
    }
    
    if (movement4){
      
      pushMatrix();
      
      rotateY(val4*-0.007199);
      rotateX(-0.030);
      translate(0,0,val2*-1);
      
     
      
      
      
        
        color d = color(0,143,val1);
        color e = color(val4,173,23);
        color f = color(val3,177,207);
        color g = color(val2);
        background(39,val3,122);
        cake(val1*1.5,50,0,d);
        cake(val2*1.5,100,50,e);
        cake(val3*1.5,150,100,f);
        cake(val4*1.5,200,150,g);
      popMatrix();

      
    }
  
  
  
  
  
  if (grid){
  // Draw grey lines dividing the screen into quadrants.
   
    stroke(100); // set line color as grey
    line(video.width/2, 0, video.width/2, video.height);
    line(0, video.height/2, video.width, video.height/2);
    // Print brightness numbers in appropriate screen quadrants.
    text(str(total_bright_top_left), video.width/4, video.height/4);
    text(str(total_bright_top_right), 3*video.width/4, video.height/4); 
    text(str(total_bright_bot_left), video.width/4, 3*video.height/4); 
    text(str(total_bright_bot_right), 3*video.width/4, 3*video.height/4);  
     
  }
    
  
    
  }
 
}

void keyPressed() {
  if ( key == 'g' ) {
    grid = !grid;
    
  }
  if ( key == '1' )movement1 = !movement1;
  if ( key == '2' )movement2 = !movement2;
  if ( key == '3' )movement3 = !movement3;
  if ( key == '4' )movement4 = !movement4;


}

void mouseDragged(){
  rotY += (mouseX-pmouseX) * 0.01; //rotates on X axis
  rotX -= (mouseY-pmouseY) * -0.01;

}

/* Demo code in case you need to receive OSC messages */
/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}
