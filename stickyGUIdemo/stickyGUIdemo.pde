

/**MAIN SKETCH */
import controlP5.*;
StickyGUI guiApplet;

String whatToPrint = null;
void setup()
{
  size(300,300);
  //WE SET UP THE GUI CONTROLLER
  //INITIALIZING IT WITH ALREADY TWO KEY BINDING EVENTS
  guiApplet = new StickyGUI(new Object[]{ "a", "b"   },400,400,4,4,this); 
  guiApplet.startSketch();
 
}


/*THIS IS CLASSIC PROCESSING STUFF ... */
void draw()
{
  background(0);
  if(null != whatToPrint)
  {
     textAlign(CENTER);
     textMode(CENTER);
     stroke(255,255);
     textSize(32);
     text(whatToPrint,width*0.5,height*0.5);
  }
}

void keyPressed()
{
 
  whatToPrint = "You pressed: ";
  if(keyCode == ENTER) { whatToPrint += "ENTER";}
  else if(keyCode == SHIFT) { whatToPrint += "SHIFT";}
  else if(keyCode == TAB) { whatToPrint += "TAB";}
  else if(keyCode == BACKSPACE) { whatToPrint += "BACKSPACE";}
  else if(keyCode == UP) { whatToPrint += "UP";}
  else if(keyCode == DOWN) { whatToPrint += "DOWN";}
  else if(keyCode == LEFT) { whatToPrint += "LEFT";}
  else if(keyCode == RIGHT) { whatToPrint += "RIGHT";}
  else whatToPrint += key;
  
}
