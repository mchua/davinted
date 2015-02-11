/**
 * Camera input for Davin's TEDx talk
 * by Mel Chua
 * Outputs the total brightness of the screen,
 * divided into quadrants.
 * Quadrant brightness is output in 3 ways:
 * 1) Displays atop the onscreen video,
 * 2) outputs to terminal,
 * 3) and outputs to OSC.
 */

import processing.video.*; // Enables webcam use
import oscP5.*;            // Enables OSC messaging
import netP5.*;            // Enables OSC message sending over the network

// Video setup
Capture video;

// OSC setup
OscP5 oscP5;
NetAddress myRemoteLocation;


void setup() {
  
  // Set up screen
  size(640, 480);
  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, width, height);
  video.start();  
  noStroke();
  smooth();
  
  // Set up OSC messaging
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  
   /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. Right now it's sending to
   * Davin's office computer. You may want to change this.
   */
  myRemoteLocation = new NetAddress("10.184.168.236",12000);
  
}

void draw() {
  if (video.available()) {
    video.read();
    image(video, 0, 0, width, height); // Draw the webcam video onto the screen
    
    //Variables for holding brightness of the 4 quadrants
    // right, left, top, bottom
    float total_bright_top_right = 0;
    float total_bright_top_left = 0;
    float total_bright_bot_right = 0;
    float total_bright_bot_left = 0;
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
          }
          else{                    // Pixel is left (and top)
            total_bright_top_right += pixelBrightness/100000;
          }
        }
        else{                      // Pixel is on bottom
          if (x < video.width/2){  // Pixel is right (and bottom)
            total_bright_bot_left += pixelBrightness/100000;
          }
          else{                    // Pixel is left (and bottom)
            total_bright_bot_right += pixelBrightness/100000;
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

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}
