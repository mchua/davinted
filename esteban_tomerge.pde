/**
 * Esteban's code to merge
 * 
 * Uses GScapture to get video input
 * and outputs a dot/plane visual.
 * I want to merge these features into the mature codebase.
 */
 

import codeanticode.gsvideo.*;

GSCapture video;
boolean grid = false;
float val1,val2,val3,val4; //to store the variables

   

void setup() {
  size(800, 600,OPENGL);
  // Uses the default video input, see the reference if this causes an error
  video = new GSCapture(this, width, height);
  video.start();  
  noStroke();
  smooth();
}

void draw() {
  //lights();
   float total_bright_top_right= 0;
    float total_bright_top_left= 0;
    float total_bright_bot_right= 0;
    float total_bright_bot_left= 0;
   
  
  if (video.available()) {
    background(val1);
    video.read();
    //image(video, 0, 0, width, height); // Draw the webcam video onto the screen
    
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
    
  noStroke();
  pushMatrix(); //layer 1-background
 
   rotateX(mouseX*0.01);// This is a mouse variable that will be replaced later. It changes the viewpoint
   translate(0,0,val2*-1);
   fill(val1,120,100);
    rect(0,0,width,height);
      pushMatrix();//layer 1.a - ellipse
        translate(0,0,100);
        fill(100,100,val2); 
        ellipse(val2*2,val3*2,80,80);
      popMatrix();
      
    popMatrix();
  
  
  
  
  
  if (grid){
  // Draw grey lines dividing the screen into quadrants.
    //video.read();
    image(video,(width/2)-160,height-240,320,240);//does not work with openGL yet
    
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

}




