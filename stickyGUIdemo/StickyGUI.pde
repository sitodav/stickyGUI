import processing.awt.PSurfaceAWT.SmoothCanvas; 
import javax.swing.JFrame;
import controlP5.*;


/** THIS IS THE GUI LIBRARY
 I WILL TRY TO EXPORT IT AS JAR */

class StickyGUI extends PApplet
{
  color[][] colors = new color[][]{ 

    new color[]{#ffbe0b, #fb5607, #ff006e, #8338ec, #3a86ff, #8ecae6, #219ebc, #126782, #023047}, 
    new color[]{#ffbe0b, #fb5607, #ff006e, #7400b8, #6930c3, #5e60ce, #5390d9, #4ea8de, #48bfe3, #56cfe1, #64dfdf, #72efdd, #80ffdb}, 
    new color[]{#ffbe0b, #fb5607, #ff006e, #8ecae6, #219ebc, #126782, #023047, #ffb703, #fd9e02, #fb8500}, 
    new color[]{#ffbe0b, #fb5607, #ff006e, #f94144, #f3722c, #f8961e, #f9c74f, #90be6d, #43aa8b}, 
    new color[]{#590d22, #800f2f, #a4133c, #c9184a, #ff4d6d, #ff758f, #ff8fa3, #ffb3c1, #ffccd5, #fff0f3}, 
    new color[]{#ff6d00, #ff7900, #ff8500, #ff9100, #ff9e00, #240046, #3c096c, #5a189a, #7b2cbf, #9d4edd}, 
    new color[]{#ff6d00, #b7094c, #a01a58, #892b64, #723c70, #5c4d7d, #455e89, #2e6f95, #1780a1, #0091ad}, 
    new color[]{#ff6d00, #b7094c, #a01a58, #892b64, #723c70, #ff595e, #ffca3a, #8ac926, #1982c4, #6a4c93}, 
    new color[]{#00111c, #001523, #001a2c, #002137, #00253e, #002945, #002e4e, #003356, #003a61, #00406c}, 
    new color[]{#ff6d00, #ff8500, #ff9100, #ff9e00, #3a86ff, #0096c7, #0077b6, #023e8a, #03045e}
  };
  
  HashMap<Integer,String> SPECIAL_KEYS_EVENTS_MAP = new HashMap<Integer,String>();

  JFrame internalJFrame;
  int _width, _height;
  PApplet mainSketch;
  ControlP5 controlP5; 
  Object[] startingEvents;
  ArrayList<Button> buttons = new ArrayList<Button>();
  ArrayList<Object> correspondingEvt = new ArrayList<Object>();
  ArrayList<Boolean> alternativeInterface = new ArrayList<Boolean>();
  PVector gridUpperCorner = new PVector(50, 50);
  int NUM_COLS_GRID;
  int NUM_ROWS_GRID;
  float GRID_WIDTH, GRID_HEIGHT;
  float GRID_COL_WIDTH, GRID_ROW_HEIGHT;
  int MAX_NUM_BUTTONS;
  boolean DISABLE_ADD_BUTTON = false;
  boolean DISABLE_REMOVE_BUTTON = true; 
  boolean IS_WAITING_FOR_KEYINPUT = false;
  boolean SHOW_HINT_MESSAGE = false;
  int PULSE_CLOCK = 0;
  boolean IN_P5_CONTROLLER; //to differentiate between a mouse clicked on the p5buttons, and the ones on the processing sketch




  public StickyGUI( int _width, int _height, int gridNumberOfRows, int gridNumberOfCols, PApplet mainSketch)
  {
    this._width = _width;
    this._height = _height; 
    this.mainSketch = mainSketch;
    this.setNewGridSize(gridNumberOfRows, gridNumberOfCols);
    this.calculateElementsSize();
    
    SPECIAL_KEYS_EVENTS_MAP.put(Integer.valueOf(ENTER),"ENTER");
    SPECIAL_KEYS_EVENTS_MAP.put(Integer.valueOf(SHIFT),"SHIFT");
    SPECIAL_KEYS_EVENTS_MAP.put(Integer.valueOf(CONTROL),"CONTROL");
    SPECIAL_KEYS_EVENTS_MAP.put(Integer.valueOf(UP),"UP"); 
    SPECIAL_KEYS_EVENTS_MAP.put(Integer.valueOf(DOWN),"DOWN"); 
    SPECIAL_KEYS_EVENTS_MAP.put(Integer.valueOf(LEFT),"LEFT"); 
    SPECIAL_KEYS_EVENTS_MAP.put(Integer.valueOf(RIGHT),"RIGHT"); 
    SPECIAL_KEYS_EVENTS_MAP.put(Integer.valueOf(TAB),"TAB"); 
    SPECIAL_KEYS_EVENTS_MAP.put(Integer.valueOf(BACKSPACE),"RIGHT"); 
    
    
  }

  public StickyGUI( Object[] events, int _width, int _height, int gridNumberOfRows, int gridNumberOfCols, PApplet mainSketch)
  {
    this(_width, _height, gridNumberOfRows, gridNumberOfCols, mainSketch);
    this.startingEvents = events;
  }

  void startSketch()
  {
    runSketch(new String[]{}); /*this starts the sketch in a new jframe */
  }

  /*setup for the external frame */
  void setup()
  {
    surface.setResizable(false);   
    this.internalJFrame = getJFrame(this);
    this.internalJFrame.setResizable(true);

    background(0);
    surface.setSize(this._width, this._height); 

    controlP5 = new ControlP5(this);


    controlP5.addButton("+") 
      .setPosition(10, 10)
      .setSize(30, 20) 
      ;

    controlP5.addButton("-") 
      .setPosition(45, 10)
      .setSize(30, 20)  
      ;

    controlP5.addButton("Remove All") 
      .setPosition(_width-70, 10)
      .setSize(60, 20) 
      ;


    if (null != startingEvents  && 4*4 < startingEvents.length)
    {
      int newSize = ceil(sqrt( startingEvents.length ));
      this.setNewGridSize(newSize, newSize);
      this.calculateElementsSize();
    }

    if (null != startingEvents && startingEvents.length > 0)
    {
      addSeveralButtons(startingEvents);
    }
  }


  public void keyPressed()
  {
     
    //if there is a button in alternative state, it's waiting for the input to register event code
    for (int i = 0; i< correspondingEvt.size(); i++)
    {   
      if (alternativeInterface.get(i))
      {
        Integer specialKeyAscii = isSpecialKey();
        if(null != specialKeyAscii) //it was a special key
        {  //for the description we use the one mapped (we cannot use the value in the keyCode processing variable because it's the ascii)
           String specialKeyDescription = SPECIAL_KEYS_EVENTS_MAP.get(keyCode);
           buttons.get(i).setCaptionLabel(""+specialKeyDescription); 
           correspondingEvt.set(i, Integer.valueOf(""+keyCode)); //the event to dispatch, associated to the button, is a integer
        }
        else //normal key
        {  //for the description we use the value in key because it's the real char
           buttons.get(i).setCaptionLabel(""+key);
           correspondingEvt.set(i, String.valueOf(""+key)); //the event to dispatch, associated to the button, is a string
        }
        
        alternativeInterface.set(i, false);
      }
    }
    SHOW_HINT_MESSAGE = false;
  }
  public void mousePressed()
  {
    if (!IN_P5_CONTROLLER)
    {
       
      //we reset all the alternative interfaces
      for (int i = 0; i< correspondingEvt.size(); i++)
      {   
        alternativeInterface.set(i, false);
      }
    }
  }
  public void controlEvent(ControlEvent theEvent) {

    IN_P5_CONTROLLER = true;
    //RIGHT CLICK, WE CHANGE THE INTERFACE
    if (mouseButton == RIGHT)
    {
      for (int i = 0; i< correspondingEvt.size(); i++)
      {  
        if (buttons.get(i).getName().equals((theEvent.getController().getName())))
        {
          alternativeInterface.set(i, !alternativeInterface.get(i));

          SHOW_HINT_MESSAGE = true;
        }
      }
    } else //LEFT CLICK EVENT ON BUTTONS
    {
      SHOW_HINT_MESSAGE = false;
      for (int i = 0; i< correspondingEvt.size(); i++)
      {   
        alternativeInterface.set(i, false);
      }

      //NORMAL CLICK
      if ("+".equals(theEvent.getController().getName()) )
      {
        if (buttons.size() == MAX_NUM_BUTTONS)
        {
          setNewGridSize(NUM_ROWS_GRID+1, NUM_COLS_GRID+1);
          calculateElementsSize();
        }
        this.addButton(""+buttons.size(), ""+buttons.size());
      } else if ("Remove All".equals((theEvent.getController().getName())) && buttons.size() > 0)
      {
        setNewGridSize(4, 4);
        calculateElementsSize();
        this.removeAllButtons();
      } else if ("-".equals(((theEvent.getController().getName()))) && buttons.size() > 0)
      {
        this.removeLastButton();
      } else
      {  //EVENT TO DISPATCH
        for (int i = 0; i< correspondingEvt.size(); i++)
        {  
          if (buttons.get(i).getName().equals((theEvent.getController().getName())))
          {
            dispatchEvent(correspondingEvt.get(i));
          }
        }
      }

      DISABLE_ADD_BUTTON = buttons.size() == MAX_NUM_BUTTONS;
      DISABLE_REMOVE_BUTTON = buttons.size() == 0;
    }

    IN_P5_CONTROLLER = false;
  }


  void draw() {

    background(0);
    noFill(); 
    stroke(255, 255);
    rect(9, 9, 31, 21);
    rect(44, 9, 31, 21);
    rect(_width-70-1, 9, 61, 21);

    if (DISABLE_ADD_BUTTON)
    {
      fill(0, 200); 
      stroke(0, 200);
      rect(9, 9, 31, 21);
    }
    if (DISABLE_REMOVE_BUTTON)
    {
      fill(0, 200); 
      stroke(0, 200);
      rect(44, 9, 31, 21);
      rect(_width-70-1, 9, 61, 21);
    }


    for (int i = 0; i< buttons.size(); i++)
    {
      int idxColInGrid = i % NUM_ROWS_GRID;
      int idxRowInGrid = i/ NUM_ROWS_GRID;

      color col = colors[0][idxColInGrid];

      float xPosition = gridUpperCorner.x + idxColInGrid * GRID_COL_WIDTH;
      float yPosition = gridUpperCorner.y + idxRowInGrid * GRID_ROW_HEIGHT;

      if (alternativeInterface.get(i)) //alternative interface for the button, we hide the button and show only a pulsing rect, waiting for input
      {
        buttons.get(i).hide(); 

        float alpha = 20;
        if (PULSE_CLOCK == 1) { 
          alpha = 90;
        } else {
          alpha = 20;
        }
        PULSE_CLOCK = (PULSE_CLOCK+1) % 2; 
        fill(col, alpha); 
        noStroke();
        rect(xPosition, yPosition, (int)GRID_COL_WIDTH-10, (int)GRID_ROW_HEIGHT-10);
        stroke(255, 255);
        textSize(32);
        text("_", xPosition+GRID_COL_WIDTH * 0.34, yPosition+GRID_ROW_HEIGHT*0.5);
      } else
      {
        buttons.get(i).show();
        buttons.get(i).setColorBackground(col);
      }


      //rounding rect white
      noFill();
      stroke(255, 255);
      rect(xPosition-1, yPosition-1, (int)GRID_COL_WIDTH- 8, (int)GRID_ROW_HEIGHT-8);
    }


    stroke(255, 200);
    fill(255, 200);

    textSize(10);
    text("RIGHT mouse on button to register input", _width*.5 -100, 10);

    textSize(12);
    if (SHOW_HINT_MESSAGE)
      text("Press key to register input", _width*.5 - 80, 30);

    text("https://www.instagram.com/stickyb1t/", _width*.5 - 115, _height-30);
  }


  /** UTILITY METHODS **/
 
  private Integer isSpecialKey()
  {
    if(SPECIAL_KEYS_EVENTS_MAP.containsKey(Integer.valueOf(keyCode)))
    {
       return Integer.valueOf(keyCode);
    }
    return null;
  }
  private void dispatchEvent(Object event)
  {
     mainSketch.key = 0;
     mainSketch.keyCode = 0;
    if (event != null ) //dispatch a key
    {
      if(!(event instanceof Integer)) //the registered event was a string, of 1 char (so it was registered as normal key event)
        mainSketch.key = (char)((String)event).charAt(0);
      else //if the registered event is an integer, then it was the ascii of a special key
        mainSketch.keyCode = ((Integer)event).intValue();
    }

    mainSketch.keyPressed();
  }

  private void addSeveralButtons(Object[] evts)
  {
    for (Object evt : evts)
    {
      if(evt instanceof String)
      {
        addButton((String)evt,(String)evt);
      }
      else
      {
        Integer evtI = Integer.valueOf((int)evt);
        String specialKeyDescription = SPECIAL_KEYS_EVENTS_MAP.get(evtI);
        addButton( specialKeyDescription, evtI); //<>//
      }
      
     
    }
  }  

  private void addButton(String eventName, String processingKeyPressedEvent)
  {
    int newIdx = buttons.size();
    PVector buttonPosition = calculateXYPositionButton(newIdx);
    PVector buttonSize = calculateSizeForButton();
    buttons.add(controlP5.addButton(eventName).setPosition(buttonPosition.x, buttonPosition.y).setSize((int)buttonSize.x, (int)buttonSize.y));
    correspondingEvt.add(processingKeyPressedEvent);
    alternativeInterface.add(false);
  }
  
  private void addButton(String eventName, Integer processingKeyPressedEvent)
  {
    int newIdx = buttons.size();
    PVector buttonPosition = calculateXYPositionButton(newIdx);
    PVector buttonSize = calculateSizeForButton(); //<>//
    buttons.add(controlP5.addButton(eventName).setPosition(buttonPosition.x, buttonPosition.y).setSize((int)buttonSize.x, (int)buttonSize.y));
    correspondingEvt.add(processingKeyPressedEvent);
    alternativeInterface.add(false);
  }
  private void removeLastButton()
  {
    Button btn = buttons.get(buttons.size()-1);
    controlP5.remove(btn.getName());
    buttons.remove(buttons.size()-1);
    correspondingEvt.remove(correspondingEvt.size()-1);
    alternativeInterface.remove(correspondingEvt.size()-1);
  }

  private void removeAllButtons()
  {
    for (Button button : buttons)
    {
      controlP5.remove(button.getName());
    }
    buttons.clear();
    correspondingEvt.clear();
    alternativeInterface.clear();
  }

  private PVector calculateXYPositionButton(int linearIndexButton)
  {
    int idxRowInGrid = linearIndexButton / NUM_ROWS_GRID;
    int idxColInGrid = linearIndexButton % NUM_COLS_GRID;
    float xPosition = gridUpperCorner.x + idxColInGrid * GRID_COL_WIDTH;
    float yPosition = gridUpperCorner.y + idxRowInGrid * GRID_ROW_HEIGHT;
    return new PVector(xPosition, yPosition);
  }

  private PVector calculateSizeForButton()
  {
    return new PVector((int)GRID_COL_WIDTH- 10, (int)GRID_ROW_HEIGHT-10);
  }

  private void setNewGridSize(int newNumRows, int newNumCols)
  {
    NUM_COLS_GRID = newNumCols;
    NUM_ROWS_GRID = newNumRows;
    MAX_NUM_BUTTONS = NUM_COLS_GRID * NUM_ROWS_GRID;
  }
  private void calculateElementsSize()
  {
    this.GRID_WIDTH = (_width- 2*50 );
    this.GRID_HEIGHT = (_height- 2*50 );
    this.GRID_COL_WIDTH = GRID_WIDTH / (float)NUM_COLS_GRID;
    this.GRID_ROW_HEIGHT = GRID_HEIGHT / (float)NUM_ROWS_GRID;

    //for all the buttons size (in p5) have to be updated
    if (null != buttons && buttons.size() > 0)
    {

      PVector newSize = calculateSizeForButton();
      for (int i = 0; i< buttons.size(); i++)
      {
        Button btn = buttons.get(i);
        PVector newPosition = calculateXYPositionButton(i);
        btn.setPosition((int)newPosition.x, (int)newPosition.y);
        btn.setSize((int)newSize.x, (int)newSize.y);
      }
    }
  }


  final JFrame getJFrame(PApplet sketch) {
    return (JFrame) ((SmoothCanvas) sketch.getSurface().getNative()).getFrame();
  }
}
